# Robótica (030-Robotics)

## Descripción del dominio

La robótica es la rama multidisciplinaria de la ingeniería y la ciencia que se ocupa del diseño, construcción, operación y uso de robots. Combina mecánica, electrónica, control, computación e inteligencia artificial para crear sistemas capaces de percibir su entorno, tomar decisiones y ejecutar acciones físicas. Los robots modernos integran sensores (LIDAR, cámaras, IMUs), actuadores (motores, servos, efector final), sistemas de control (PID, modelo predictivo) y software de alto nivel para navegación autónoma, manipulación e interacción humano-robot. ROS (Robot Operating System) y ROS2 son los frameworks estándar de facto para desarrollo robótico.

## Conceptos clave

- **Cinemática**: Estudio del movimiento sin considerar fuerzas. Cinemática directa (posición desde ángulos de articulaciones) e inversa (ángulos desde posición deseada).
- **Dinámica**: Estudio de fuerzas y torques que producen movimiento. Modelos Newton-Euler y Lagrange.
- **SLAM** (Simultaneous Localization and Mapping): Construcción de un mapa del entorno mientras se localiza el robot dentro de él.
- **ROS/ROS2**: Framework middleware para desarrollo robótico. ROS2 usa DDS para comunicación en tiempo real.
- **Sensores**: LIDAR, RGB-D (Kinect/RealSense), encoders, IMU (acelerómetro + giroscopio), cámaras estéreo, sensores táctiles.
- **Actuadores**: Servomotores, motores DC con encoder, actuadores neumáticos, hidráulicos, soft robotics.
- **Control**: PID, LQR, control predictivo (MPC), control adaptativo, control basado en aprendizaje (aprendizaje por refuerzo).
- **Planificación de movimiento**: RRT, A*, PRM, planificación basada en muestreo, campos potenciales.
- **Odometría**: Estimación de posición usando datos de sensores (encoders, IMU, visión).
- **Manipulación**: Cinemática de brazos robóticos, pinzas, efector final, grasping, force control.
- **Navegación autónoma**: Costmaps, global planner, local planner (DWA, TEB), evitación de obstáculos.

## Tecnologías principales

- **ROS Noetic / ROS2 (Humble, Iron, Rolling)**: Middleware robótico.
- **Gazebo / Ignition**: Simuladores físicos realistas.
- **MoveIt2**: Framework para manipulación y planificación de movimiento.
- **Navigation2 (Nav2)**: Pila completa de navegación autónoma.
- **PCL (Point Cloud Library)**: Procesamiento de nubes de puntos 3D.
- **OpenCV**: Visión por computadora para robótica.
- **TF2**: Biblioteca de transformaciones de coordenadas.
- **Cartographer**: SLAM basado en LIDAR (Google).
- **ORB-SLAM**: SLAM visual y visual-inercial.
- **Librealsense**: SDK para cámaras Intel RealSense.
- **Micro-ROS**: ROS2 para microcontroladores.
- **Python (rospy/rclpy) y C++ (roscpp/rclcpp)**: Lenguajes principales.

## Hoja de ruta

**Principiante:**
1. Fundamentos de programación (Python, C++) y Linux básico.
2. Conceptos de cinemática (directa e inversa) y dinámica.
3. Introducción a ROS: nodos, tópicos, servicios, acciones.
4. Simulación básica con Gazebo y TurtleBot3.
5. Lectura de sensores: LIDAR, IMU, odometría de encoders.

**Intermedio:**
1. ROS2 avanzado: parámetros, launch files, lifecyle nodes.
2. SLAM con Cartographer o slam_toolbox.
3. Navegación autónoma con Nav2: mapas, costmaps, planners.
4. Visión robótica: detección de objetos, seguimiento, calibración de cámaras.
5. MoveIt2 para planificación de movimiento de brazos robóticos.

**Avanzado:**
1. Control avanzado: MPC, aprendizaje por refuerzo en simulación.
2. Manipulación avanzada: grasp planning, force control, ensamblaje.
3. Robótica móvil: navegación en entornos dinámicos, swarm robotics.
4. Sistemas multi-robot: coordinación, comunicación, planificación distribuida.
5. Integración con IA: deep reinforcement learning (PyTorch + ROS2).

## Relaciones con otros módulos

- `../029-IoT/`: Sensores embebidos y comunicación MQTT en robots IoT.
- `../031-AI/`: Algoritmos de inteligencia artificial aplicados a robótica autónoma.
- `../032-MachineLearning/`: ML clásico para percepción y control robótico.
- `../033-DeepLearning/`: Deep Learning para visión robótica y control end-to-end.
- `../034-LLM/`: Integración de LLMs para razonamiento y planificación robótica.
- `../037-AgenticAI/`: Agentes robóticos autónomos con planificación y ejecución.
- `../028-Embedded/`: Sistemas embebidos en microcontroladores robóticos.
- `../038-VectorDatabases/`: Búsqueda semántica en memoria de experiencias robóticas.

## Recursos recomendados

- **Libro**: "Introduction to Autonomous Mobile Robots" (Siegwart, Nourbakhsh, Scaramuzza).
- **Libro**: "Robotics: Modelling, Planning and Control" (Siciliano, Sciavicco, Villani, Oriolo).
- **Curso**: "Robotics Specialization" (University of Pennsylvania) en Coursera.
- **Documentación oficial**: ROS2 Humble Docs (docs.ros.org).
- **Paper**: "PIXO: Leveraging Episodic Memory for Robot Task Planning" (2024).
- **Repositorio**: ros2/examples en GitHub, Navigation2, MoveIt2.
- **Video**: "ROS2 Basics in 5 Days" (The Construct).
