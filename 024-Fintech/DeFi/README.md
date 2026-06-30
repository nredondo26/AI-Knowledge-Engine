# DeFi — Finanzas Descentralizadas en Blockchain

## Visión General

DeFi (Decentralized Finance) es un ecosistema de aplicaciones financieras construidas sobre blockchains públicas, principalmente Ethereum. Utiliza smart contracts para replicar y mejorar servicios financieros tradicionales: préstamos, intercambios, mercados de dinero, derivados, seguros y gestión de activos sin intermediarios centralizados. DeFi alcanzó más de $100B en Total Value Locked (TVL) en su pico de 2021-2022.

## Arquitectura Técnica

```
┌──────────────────────────────────────────────────┐
│           Frontend (dApps — Web3)                 │
│  React/Next.js + ethers.js + Web3Modal + Wallet  │
├──────────────────────────────────────────────────┤
│             Smart Contracts (Solidity)            │
│  ERC-20 · ERC-721 · ERC-4626 · Lending Pools    │
├──────────────────────────────────────────────────┤
│           Protocol Layer (Blockchain)              │
│  Ethereum · Polygon · Arbitrum · Optimism · Base  │
├──────────────────────────────────────────────────┤
│      Oracles (Chainlink) · Bridges · Layer 2      │
│  Precios off-chain · Cross-chain · Rollups        │
└──────────────────────────────────────────────────┘
```

## Componentes Clave de DeFi

```
DeFi Ecosystem
├── DEX (Decentralized Exchanges)
│   ├── Uniswap (AMM — Automated Market Maker)
│   ├── Curve (StableSwap para stablecoins)
│   └── Balancer (AMM multi-token con pesos)
├── Lending & Borrowing
│   ├── Aave (Money Market, Flash Loans)
│   ├── Compound (cTokens, rate oracle)
│   └── MakerDAO (DAI stablecoin, Vaults)
├── Yield Aggregators
│   ├── Yearn Finance (yVaults, strategy vaults)
│   └── Convex (CRV staking optimizer)
├── Derivatives
│   ├── Synthetix (synthetic assets)
│   ├── dYdX (perpetual futures, orderbook L2)
│   └── GMX (perpetuals on Arbitrum/Avalanche)
└── Insurance
    ├── Nexus Mutual (discretionary mutual)
    └── Euler (cover protocol)
```

## Smart Contracts en Solidity

### ERC-20 — Token Fungible Estándar

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract KnowledgeToken is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10 ** 18; // 1 billion
    uint256 public constant TAX_RATE = 50; // 0.5% (50/10000)
    mapping(address => bool) public blacklist;
    address public treasury;

    event Mint(address indexed to, uint256 amount);
    event BlacklistUpdated(address indexed account, bool status);

    constructor(address _treasury) ERC20("AI Knowledge Token", "AIKT") Ownable(msg.sender) {
        require(_treasury != address(0), "Invalid treasury");
        treasury = _treasury;
        _mint(msg.sender, 100_000_000 * 10 ** 18); // 10% inicial
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds max supply");
        _mint(to, amount);
        emit Mint(to, amount);
    }

    function _update(address from, address to, uint256 value) internal override {
        require(!blacklist[from], "Sender blacklisted");
        require(!blacklist[to], "Recipient blacklisted");

        if (from != address(0) && to != address(0) && value > 0) {
            uint256 tax = (value * TAX_RATE) / 10000;
            if (tax > 0) {
                super._update(from, treasury, tax);
                value -= tax;
            }
        }
        super._update(from, to, value);
    }

    function toggleBlacklist(address account) external onlyOwner {
        blacklist[account] = !blacklist[account];
        emit BlacklistUpdated(account, blacklist[account]);
    }
}
```

### AMM — Automated Market Maker (Uniswap V2 Style)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract SimpleAMM {
    using SafeERC20 for IERC20;

    IERC20 public token0;
    IERC20 public token1;
    uint256 public reserve0;
    uint256 public reserve1;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(address indexed sender, uint256 amount0, uint256 amount1);
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );

    constructor(address _token0, address _token1) {
        require(_token0 < _token1, "token0 < token1 required");
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address to, uint256 amount) private {
        balanceOf[to] += amount;
        totalSupply += amount;
    }

    function _burn(address from, uint256 amount) private {
        balanceOf[from] -= amount;
        totalSupply -= amount;
    }

    function _update(uint256 bal0, uint256 bal1) private {
        reserve0 = bal0;
        reserve1 = bal1;
    }

    // Añadir liquidez
    function addLiquidity(uint256 amount0, uint256 amount1)
        external returns (uint256 shares)
    {
        token0.safeTransferFrom(msg.sender, address(this), amount0);
        token1.safeTransferFrom(msg.sender, address(this), amount1);

        if (totalSupply == 0) {
            shares = _sqrt(amount0 * amount1);
        } else {
            shares = _min(
                (amount0 * totalSupply) / reserve0,
                (amount1 * totalSupply) / reserve1
            );
        }
        require(shares > 0, "shares = 0");

        _mint(msg.sender, shares);
        _update(token0.balanceOf(address(this)), token1.balanceOf(address(this)));
        emit Mint(msg.sender, amount0, amount1);
    }

    // Retirar liquidez
    function removeLiquidity(uint256 shares)
        external returns (uint256 amount0, uint256 amount1)
    {
        amount0 = (shares * reserve0) / totalSupply;
        amount1 = (shares * reserve1) / totalSupply;
        require(amount0 > 0 && amount1 > 0, "amount = 0");

        _burn(msg.sender, shares);
        _update(reserve0 - amount0, reserve1 - amount1);

        token0.safeTransfer(msg.sender, amount0);
        token1.safeTransfer(msg.sender, amount1);
        emit Burn(msg.sender, amount0, amount1);
    }

    // Swap: product constant k = reserve0 * reserve1
    function swap(uint256 amount0Out, uint256 amount1Out, address to) external {
        require(amount0Out > 0 || amount1Out > 0, "output = 0");
        require(amount0Out < reserve0 && amount1Out < reserve1, "insufficient liquidity");

        if (amount0Out > 0) token0.safeTransfer(to, amount0Out);
        if (amount1Out > 0) token1.safeTransfer(to, amount1Out);

        uint256 balance0 = token0.balanceOf(address(this));
        uint256 balance1 = token1.balanceOf(address(this));

        uint256 amount0In = balance0 > reserve0 - amount0Out ? balance0 - (reserve0 - amount0Out) : 0;
        uint256 amount1In = balance1 > reserve1 - amount1Out ? balance1 - (reserve1 - amount1Out) : 0;

        require(amount0In > 0 || amount1In > 0, "input = 0");

        // k >= k_initial (constant product invariant with 0.3% fee)
        uint256 balance0Adjusted = balance0 * 1000 - amount0In * 3;
        uint256 balance1Adjusted = balance1 * 1000 - amount1In * 3;
        require(
            balance0Adjusted * balance1Adjusted >= (reserve0 * reserve1) * (1000 ** 2),
            "K invariant failed"
        );

        _update(balance0, balance1);
        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
    }

    function _sqrt(uint256 y) private pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function _min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }
}
```

## Lending Pool — Aave Style

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract LendingPool {
    using SafeERC20 for IERC20;

    IERC20 public asset;
    uint256 public totalDeposits;
    uint256 public totalBorrows;
    uint256 public utilizationRate;
    uint256 public constant BASE_RATE = 0;       // 0%
    uint256 public constant SLOPE1 = 4_00;        // 4%
    uint256 public constant SLOPE2 = 100_00;      // 100%
    uint256 public constant OPTIMAL_RATE = 80_00; // 80%
    uint256 public constant PRECISION = 1e4;

    mapping(address => uint256) public depositShares;
    uint256 public totalDepositShares;

    mapping(address => uint256) public borrowShares;
    uint256 public totalBorrowShares;

    constructor(IERC20 _asset) {
        asset = _asset;
    }

    // Depositar colateral
    function deposit(uint256 amount) external {
        require(amount > 0, "amount = 0");
        asset.safeTransferFrom(msg.sender, address(this), amount);

        uint256 shares = totalDepositShares == 0
            ? amount
            : (amount * totalDepositShares) / totalDeposits;

        depositShares[msg.sender] += shares;
        totalDepositShares += shares;
        totalDeposits += amount;

        _updateUtilization();
    }

    // Retirar colateral
    function withdraw(uint256 shares) external {
        require(shares > 0 && shares <= depositShares[msg.sender], "invalid shares");
        uint256 amount = (shares * totalDeposits) / totalDepositShares;

        depositShares[msg.sender] -= shares;
        totalDepositShares -= shares;
        totalDeposits -= amount;

        asset.safeTransfer(msg.sender, amount);
        _updateUtilization();
    }

    // Pedir préstamo
    function borrow(uint256 amount) external {
        require(amount <= totalDeposits - totalBorrows, "insufficient liquidity");

        uint256 shares = totalBorrowShares == 0
            ? amount
            : (amount * totalBorrowShares) / totalBorrows;

        borrowShares[msg.sender] += shares;
        totalBorrowShares += shares;
        totalBorrows += amount;

        asset.safeTransfer(msg.sender, amount);
        _updateUtilization();
    }

    // Repagar préstamo
    function repay(uint256 amount) external {
        require(amount > 0, "amount = 0");
        asset.safeTransferFrom(msg.sender, address(this), amount);

        uint256 shares = (amount * totalBorrowShares) / totalBorrows;
        borrowShares[msg.sender] -= shares;
        totalBorrowShares -= shares;
        totalBorrows -= amount;

        _updateUtilization();
    }

    // Tasa de interés variable
    function getBorrowRate() public view returns (uint256) {
        if (utilizationRate <= OPTIMAL_RATE) {
            return BASE_RATE + (utilizationRate * SLOPE1) / OPTIMAL_RATE;
        } else {
            return BASE_RATE + SLOPE1 + ((utilizationRate - OPTIMAL_RATE) * SLOPE2) / (PRECISION - OPTIMAL_RATE);
        }
    }

    function getDepositRate() public view returns (uint256) {
        return (getBorrowRate() * utilizationRate) / PRECISION;
    }

    function _updateUtilization() private {
        if (totalDeposits == 0) {
            utilizationRate = 0;
        } else {
            utilizationRate = (totalBorrows * PRECISION) / totalDeposits;
        }
    }
}
```

## Flash Loans — Préstamos Flash

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IFlashLoanReceiver {
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator
    ) external returns (bool);
}

contract FlashLoanProvider {
    IERC20 public asset;
    uint256 public constant PREMIUM = 9; // 0.09%

    event FlashLoan(
        address indexed receiver,
        address indexed asset,
        uint256 amount,
        uint256 premium
    );

    constructor(address _asset) {
        asset = IERC20(_asset);
    }

    function flashLoan(
        IFlashLoanReceiver receiver,
        uint256 amount,
        bytes calldata params
    ) external {
        uint256 balanceBefore = asset.balanceOf(address(this));
        require(amount <= balanceBefore, "insufficient balance");

        uint256 premium = (amount * PREMIUM) / 10000;

        // Transferir al receptor
        asset.transfer(address(receiver), amount);

        // Ejecutar lógica del receptor
        require(
            receiver.executeOperation(
                address(asset),
                amount,
                premium,
                msg.sender
            ),
            "flash loan callback failed"
        );

        // Verificar que se devolvió + premium
        uint256 balanceAfter = asset.balanceOf(address(this));
        require(
            balanceAfter >= balanceBefore + premium,
            "flash loan not repaid"
        );

        emit FlashLoan(address(receiver), address(asset), amount, premium);
    }
}
```

## Yield Aggregator — Yearn Style

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IStrategy {
    function harvest() external returns (uint256);
    function withdraw(uint256) external;
    function balanceOf() external view returns (uint256);
}

contract YieldVault is Ownable {
    IERC20 public asset;
    uint256 public totalAssets_;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    IStrategy public strategy;

    constructor(address _asset, address _strategy) Ownable(msg.sender) {
        asset = IERC20(_asset);
        strategy = IStrategy(_strategy);
    }

    // Depositar y obtener shares
    function deposit(uint256 amount) external returns (uint256 shares) {
        asset.transferFrom(msg.sender, address(this), amount);

        shares = totalSupply == 0
            ? amount
            : (amount * totalSupply) / totalAssets_;

        balanceOf[msg.sender] += shares;
        totalSupply += shares;
        totalAssets_ += amount;

        // Invertir en estrategia
        asset.transfer(address(strategy), amount);
        strategy.harvest();
    }

    // Retirar shares y obtener activos
    function withdraw(uint256 shares) external returns (uint256 amount) {
        require(shares <= balanceOf[msg.sender], "insufficient shares");

        amount = (shares * totalAssets_) / totalSupply;

        balanceOf[msg.sender] -= shares;
        totalSupply -= shares;
        totalAssets_ -= amount;

        // Retirar de estrategia si es necesario
        strategy.withdraw(amount);
        asset.transfer(msg.sender, amount);
    }

    function pricePerShare() public view returns (uint256) {
        return totalSupply == 0 ? 1e18 : (totalAssets_ * 1e18) / totalSupply;
    }

    function harvest() external onlyOwner {
        uint256 profit = strategy.harvest();
        if (profit > 0) {
            totalAssets_ += profit;
        }
    }
}
```

## DeFi Composability — Ejemplo de Arbitraje

```javascript
// Flash Swap + Arbitraje entre DEXes (Hardhat/ethers.js)
const hre = require("hardhat");
const { ethers } = hre;

async function executeArbitrage() {
    const [deployer] = await ethers.getSigners();

    // Direcciones de pools Uniswap V3 y Sushiswap
    const UNISWAP_POOL = "0x...";
    const SUSHISWAP_PAIR = "0x...";
    const WETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
    const USDC = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";

    // Obtener precios
    const uniQuoter = await ethers.getContractAt("IQuoter", "0xb27308f9F90D607463bb33eA1BeBb41C27CE5AB6");
    const sushiRouter = await ethers.getContractAt("IUniswapV2Router02", "0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F");

    const [uniPrice] = await uniQuoter.quoteExactInputSingle(
        WETH, USDC, 3000, ethers.parseEther("100"), 0
    );

    const sushiPrice = await sushiRouter.getAmountsOut(
        ethers.parseEther("100"),
        [WETH, USDC]
    );

    const amountInWETH = ethers.parseEther("100");
    const profit = uniPrice - sushiPrice[1];

    if (profit > 0n) {
        console.log(`Arbitraje rentable: ${ethers.formatUnits(profit, 6)} USDC`);

        // Ejecutar flash loan + swap
        const arbContract = await ethers.getContract("ArbitrageExecutor");
        const tx = await arbContract.execute(
            WETH,
            amountInWETH,
            UNISWAP_POOL,
            SUSHISWAP_PAIR,
            { gasLimit: 500000 }
        );
        await tx.wait();
        console.log("Arbitraje ejecutado");
    }
}
```

## Oráculos — Chainlink Price Feeds

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceOracle {
    AggregatorV3Interface internal immutable priceFeed;

    // ETH/USD en Ethereum Mainnet
    constructor() {
        priceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
    }

    function getLatestPrice() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price) * 1e10; // Convertir a 18 decimales
    }

    function getDecimals() public view returns (uint8) {
        return priceFeed.decimals();
    }

    // Precio con chequeo de staleness
    function getPriceSafe(uint256 maxAge) external view returns (uint256) {
        (, int256 price, , uint256 updatedAt, ) = priceFeed.latestRoundData();
        require(block.timestamp - updatedAt <= maxAge, "Price feed is stale");
        require(price > 0, "Invalid price");
        return uint256(price) * 1e10;
    }
}
```

## Herramientas de Desarrollo

```bash
# Hardhat — Framework de desarrollo Ethereum
npx hardhat init
npx hardhat compile
npx hardhat test
npx hardhat run scripts/deploy.js --network goerli

# Foundry — Suite rápida en Rust
forge init
forge build
forge test -vvv
forge snapshot
cast call 0x... "balanceOf(address)" 0x...

# Verificación de contratos
npx hardhat verify --network mainnet CONTRACT_ADDRESS constructorArgs

# Análisis de gas
npx hardhat gas-report
forge inspect MyContract gas
```

## Riesgos en DeFi

| Riesgo | Descripción | Mitigación |
|--------|-------------|------------|
| Smart Contract Bug | Error en código del contrato | Auditorías, bug bounties, insurance |
| Oracle Manipulation | Manipulación de precio vía flash loans | Usar TWAP, múltiples oráculos |
| Impermanent Loss | Pérdida en AMM por volatilidad | Pools con stablecoins, fees |
| Liquidation Risk | Liquidación de colateral en lending | Mantener ratio saludable (>150%) |
| Governance Attack | Toma de control via governance tokens | Timelocks, multisig, veto power |
| Regulatory | Cambios regulatorios en DeFi | Geolocking, KYC en entry points |
| Bridge Risk | Hack de bridges cross-chain | Usar bridges auditados, limitar TVL |

## Buenas Prácticas

1. **Auditoría** — Contratar auditorías profesionales (Trail of Bits, ConsenSys Diligence, OpenZeppelin).
2. **Pruebas** — Cubrir edge cases en Solidity (reentrancy, integer overflow, rounding).
3. **Gas optimization** — Usar `unchecked` para operaciones seguras, empaquetar structs.
4. **upgradeable** — Usar patrón Proxy (UUPS o Transparent) para contratos actualizables.
5. **Emergency stop** — Implementar pausa de emergencia en protocolos de préstamo.
6. **Timelock** — Retrasar ejecución de cambios críticos (mínimo 24h).
7. **Composability** — Diseñar contratos para que otros protocolos puedan integrarlos.
8. **Frontend** — Usar WalletConnect, ethers.js, y Web3Modal para conectar wallets.
