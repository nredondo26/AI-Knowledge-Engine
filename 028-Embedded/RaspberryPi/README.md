# Raspberry Pi — Embedded Linux

## Visión General

Raspberry Pi es un ordenador de placa reducida (SBC) basado en ARM. Ejecuta Linux completo (Raspberry Pi OS, Ubuntu, etc.) y ofrece GPIO para control de hardware, ideal para prototipado, IoT, servidores domésticos y educación.

## Modelos Principales

| Modelo | SoC | RAM | GPIO | Conectividad | Precio aprox. |
|--------|-----|-----|------|-------------|---------------|
| Pi 5 | BCM2712 (Cortex-A76) | 4/8 GB | 40 pines | WiFi 5, BT 5.0, USB 3.0, PCIe 2.0 | $60-80 |
| Pi 4 Model B | BCM2711 (Cortex-A72) | 1-8 GB | 40 pines | WiFi 5, BT 5.0, USB 3.0 | $35-75 |
| Pi 3 Model B+ | BCM2837B0 (Cortex-A53) | 1 GB | 40 pines | WiFi, BT 4.2 | $35 |
| Pi Zero 2 W | RP3A0 (Cortex-A53) | 512 MB | 40 pines | WiFi, BT 4.2 | $15 |
| Pi Pico | RP2040 (Dual Cortex-M0+) | 264 KB | 26 pines | No inalámbrico | $4 |

## Configuración Inicial (Headless)

```bash
# 1. Escribir imagen en SD
sudo dd if=2024-01-01-raspios-bookworm-arm64.img of=/dev/sdX bs=4M status=progress

# 2. Montar boot partition y habilitar SSH
touch /mnt/boot/ssh

# 3. Configurar WiFi
cat > /mnt/boot/wpa_supplicant.conf << EOF
country=ES
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="MiWiFi"
    psk="contraseña"
    key_mgmt=WPA-PSK
}
EOF

# 4. Conectar por SSH
ssh pi@raspberrypi.local  # password: raspberry
```

## GPIO (General Purpose Input/Output)

```python
import RPi.GPIO as GPIO
import time

LED_PIN = 18
BUTTON_PIN = 17

GPIO.setmode(GPIO.BCM)
GPIO.setup(LED_PIN, GPIO.OUT)
GPIO.setup(BUTTON_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

def button_callback(channel):
    print("Botón presionado")
    GPIO.output(LED_PIN, not GPIO.input(LED_PIN))

GPIO.add_event_detect(BUTTON_PIN, GPIO.FALLING,
                      callback=button_callback, bouncetime=300)

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    GPIO.cleanup()
```

## PWM con pigpio

```bash
# Servicio pigpiod debe estar corriendo
sudo pigpiod
```

```python
import pigpio
import time

pi = pigpio.pi()
SERVO_PIN = 18

# Servomotor: 500-2500 µs
pi.set_servo_pulsewidth(SERVO_PIN, 1500)  # Centro
time.sleep(1)
pi.set_servo_pulsewidth(SERVO_PIN, 1000)  # 0°
time.sleep(1)
pi.set_servo_pulsewidth(SERVO_PIN, 2000)  # 180°

pi.stop()
```

## I2C (Conexión de Sensores)

```bash
# Habilitar I2C en raspi-config o /boot/config.txt
dtparam=i2c_arm=on
```

```python
import smbus2
import time

bus = smbus2.SMBus(1)
MPU6050_ADDR = 0x68

# Wake up MPU6050
bus.write_byte_data(MPU6050_ADDR, 0x6B, 0)

def read_word(reg):
    high = bus.read_byte_data(MPU6050_ADDR, reg)
    low = bus.read_byte_data(MPU6050_ADDR, reg + 1)
    value = (high << 8) + low
    return value - 65536 if value > 32767 else value

while True:
    ax = read_word(0x3B)
    ay = read_word(0x3D)
    az = read_word(0x3F)
    print(f"Accel: {ax}, {ay}, {az}")
    time.sleep(0.5)
```

## SPI con Python

```python
import spidev
import time

spi = spidev.SpiDev()
spi.open(0, 0)  # bus 0, device 0 (CE0)
spi.max_speed_hz = 1000000

def read_mcp3208(channel):
    # MCP3208 ADC de 12 bits
    cmd = 0x06 | ((channel & 0x07) << 4)
    reply = spi.xfer2([cmd, 0x00, 0x00])
    value = ((reply[0] & 0x01) << 11) | (reply[1] << 3) | (reply[2] >> 5)
    return value

while True:
    ch0 = read_mcp3208(0)
    voltage = ch0 * 3.3 / 4095
    print(f"Canal 0: {voltage:.3f}V")
    time.sleep(0.5)
```

## Cámara (libcamera)

```bash
# Capturar imagen
libcamera-still -o foto.jpg

# Video 10s
libcamera-vid -t 10000 -o video.h264

# Streaming
libcamera-vid -t 0 --inline --listen -o tcp://0.0.0.0:8888
```

```python
from picamera2 import Picamera2
import cv2

picam2 = Picamera2()
config = picam2.create_preview_configuration(
    main={"size": (640, 480)},
    controls={"FrameRate": 30}
)
picam2.configure(config)
picam2.start()

while True:
    frame = picam2.capture_array()
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    cv2.imshow("Camera", gray)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cv2.destroyAllWindows()
```

## Docker en Raspberry Pi

```yaml
# docker-compose.yml
version: '3'
services:
  mosquitto:
    image: eclipse-mosquitto:latest
    ports:
      - "1883:1883"
      - "9001:9001"
    volumes:
      - ./mosquitto.conf:/mosquitto/config/mosquitto.conf

  node-red:
    image: nodered/node-red:latest
    ports:
      - "1880:1880"
    volumes:
      - node-red-data:/data

volumes:
  node-red-data:
```

## Kubernetes Ligero (K3s)

```bash
# Master node
curl -sfL https://get.k3s.io | sh -

# Worker node
curl -sfL https://get.k3s.io | K3S_URL=https://master:6443 \
  K3S_TOKEN=<token> sh -

# Ver estado
sudo k3s kubectl get nodes
sudo k3s kubectl get pods --all-namespaces
```

## Cluster con Raspberry Pi

Para un cluster de 4 nodos:

```bash
# Configurar hostnames
sudo hostnamectl set-hostname k3s-master
sudo hostnamectl set-hostname k3s-worker1  # (en cada worker)

# NFS para storage compartido
sudo apt install nfs-kernel-server
echo "/mnt/data *(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports
```

## Configuración de Red (WiFi AP)

```bash
# Usar NetworkManager para crear hotspot
nmcli device wifi hotspot ifname wlan0 ssid "Pi-Hotspot" password "miclave123"
```

## Overclocking y Performance

```bash
# /boot/config.txt
over_voltage=4
arm_freq=2000
gpu_freq=700

# Monitoring
vcgencmd measure_temp
vcgencmd measure_clock arm
vcgencmd get_throttled
```

## Referencias

- [Raspberry Pi Documentation](https://www.raspberrypi.com/documentation/)
- [RPi.GPIO](https://sourceforge.net/projects/raspberry-gpio-python/)
- [pigpio Library](http://abyz.me.uk/rpi/pigpio/)
- [Picamera2](https://github.com/raspberrypi/picamera2)
- [K3s](https://k3s.io/)
