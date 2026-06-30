# Redes Generativas Antagónicas (GANs)

## Descripción del dominio

Las Redes Generativas Antagónicas (GANs) son una clase de modelos generativos introducidos por Ian Goodfellow en 2014. Consisten en dos redes neuronales que compiten en un juego de suma cero: el Generador crea datos sintéticos que imitan los datos reales, mientras que el Discriminador intenta distinguir entre datos reales y falsos. Esta competencia impulsa a ambas redes a mejorar: el generador produce muestras cada vez más realistas, y el discriminador se vuelve más hábil detectando falsificaciones. Las GANs han revolucionado la generación de imágenes, superresolución, edición facial, transferencia de estilo, creación de arte y síntesis de datos médicos.

## Conceptos clave

- **Generador (G)**: Red que toma ruido aleatorio (z ∼ p_z) y lo transforma en datos sintéticos G(z) que imitan la distribución real.
- **Discriminador (D)**: Red clasificadora binaria que distingue entre datos reales (x ∼ p_data) y datos generados G(z).
- **Juego Min-Max**: G intenta minimizar log(1 - D(G(z))), D intenta maximizar log(D(x)) + log(1 - D(G(z))).
- **Equilibrio de Nash**: Punto óptimo donde D no puede distinguir (D(x) = 0.5 para todo x) y G genera la distribución real.
- **DCGAN (Deep Convolutional GAN)**: Arquitectura que usa convoluciones transpuestas en el generador y convoluciones en el discriminador.
- **WGAN (Wasserstein GAN)**: Usa distancia de Wasserstein en lugar de Jensen-Shannon divergencia. Entrenamiento más estable, evita mode collapse.
- **Conditional GAN (cGAN)**: Tanto G como D reciben una condición adicional (etiqueta de clase, imagen), permitiendo generación dirigida.
- **CycleGAN**: Traducción entre dominios sin pares de datos (ej: foto ↔ pintura, caballo ↔ cebra).
- **StyleGAN**: Arquitectura de NVIDIA para generación de caras realistas de alta resolución. Control de estilo en múltiples escalas.
- **Mode Collapse**: Problema donde el generador produce solo una variedad limitada de muestras.

## Ejemplo: DCGAN simple en PyTorch

```python
import torch
import torch.nn as nn

class Generator(nn.Module):
    def __init__(self, latent_dim=100, img_channels=3):
        super().__init__()
        self.model = nn.Sequential(
            nn.ConvTranspose2d(latent_dim, 512, 4, 1, 0, bias=False),
            nn.BatchNorm2d(512), nn.ReLU(True),
            nn.ConvTranspose2d(512, 256, 4, 2, 1, bias=False),
            nn.BatchNorm2d(256), nn.ReLU(True),
            nn.ConvTranspose2d(256, 128, 4, 2, 1, bias=False),
            nn.BatchNorm2d(128), nn.ReLU(True),
            nn.ConvTranspose2d(128, 64, 4, 2, 1, bias=False),
            nn.BatchNorm2d(64), nn.ReLU(True),
            nn.ConvTranspose2d(64, img_channels, 4, 2, 1, bias=False),
            nn.Tanh()
        )

    def forward(self, z):
        return self.model(z.view(z.size(0), -1, 1, 1))

class Discriminator(nn.Module):
    def __init__(self, img_channels=3):
        super().__init__()
        self.model = nn.Sequential(
            nn.Conv2d(img_channels, 64, 4, 2, 1, bias=False),
            nn.LeakyReLU(0.2, inplace=True),
            nn.Conv2d(64, 128, 4, 2, 1, bias=False),
            nn.BatchNorm2d(128), nn.LeakyReLU(0.2, inplace=True),
            nn.Conv2d(128, 256, 4, 2, 1, bias=False),
            nn.BatchNorm2d(256), nn.LeakyReLU(0.2, inplace=True),
            nn.Conv2d(256, 1, 4, 1, 0, bias=False),
            nn.Sigmoid()
        )

    def forward(self, x):
        return self.model(x).view(-1, 1)
```

## Ejemplo: Ciclo de entrenamiento GAN

```python
def train_gan(G, D, dataloader, epochs, lr=0.0002, latent_dim=100, device='cuda'):
    criterion = nn.BCELoss()
    opt_G = torch.optim.Adam(G.parameters(), lr=lr, betas=(0.5, 0.999))
    opt_D = torch.optim.Adam(D.parameters(), lr=lr, betas=(0.5, 0.999))

    for epoch in range(epochs):
        for real_imgs, _ in dataloader:
            batch = real_imgs.size(0)
            real_imgs = real_imgs.to(device)

            # Entrenar Discriminador
            opt_D.zero_grad()
            z = torch.randn(batch, latent_dim, device=device)
            fake_imgs = G(z)
            loss_D = criterion(D(real_imgs), torch.ones(batch, 1, device=device))
            loss_D += criterion(D(fake_imgs.detach()), torch.zeros(batch, 1, device=device))
            loss_D.backward()
            opt_D.step()

            # Entrenar Generador
            opt_G.zero_grad()
            z = torch.randn(batch, latent_dim, device=device)
            fake_imgs = G(z)
            loss_G = criterion(D(fake_imgs), torch.ones(batch, 1, device=device))
            loss_G.backward()
            opt_G.step()
```

## Tecnologías principales

- **PyTorch**: Framework principal para implementación de GANs.
- **TensorFlow/Keras**: tf.keras con capas Conv2DTranspose.
- **StyleGAN2-ADA**: Arquitectura state-of-the-art de NVIDIA.
- **Stable Diffusion**: Modelo generativo de última generación (diffusion, no GAN).
- **Proyecto**: CycleGAN, Pix2Pix, GauGAN, BigGAN.

## Hoja de ruta

1. Teoría del juego min-max, función de pérdida, equilibrio Nash.
2. Implementar DCGAN desde cero en PyTorch.
3. Técnicas de entrenamiento estable: label smoothing, gradient penalty, one-sided label smoothing.
4. WGAN y WGAN-GP para evitar mode collapse.
5. Conditional GAN para generación dirigida por clase.
6. CycleGAN para traducción entre dominios no pareados.
7. StyleGAN: control de estilo, mezcla de estilos.

## Relaciones con otros módulos

- `../../032-MachineLearning/Unsupervised/`: GANs como método de aprendizaje no supervisado/generativo.
- `../TransferLearning/`: GANs pre-entrenadas para transferencia de estilo.
- `../ModelOptimization/`: Optimización de GANs para inferencia eficiente.
- `../../034-LLM/Security/`: Deepfakes y detección de contenido generado.

## Recursos recomendados

- **Paper**: "Generative Adversarial Nets" (Goodfellow et al., 2014) — El paper original.
- **Paper**: "Unsupervised Representation Learning with Deep Convolutional GANs" (DCGAN, 2015).
- **Paper**: "A Style-Based Generator Architecture for GANs" (StyleGAN, 2019).
- **Curso**: "CS236: Deep Generative Models" (Stanford).
- **Repositorio**: pytorch/examples/dcgan, stylegan2-ada-pytorch.
