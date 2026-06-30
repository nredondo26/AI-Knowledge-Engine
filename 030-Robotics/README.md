# 030-Robotics: Robótica

## Descripción ampliada del dominio

La robótica es un campo interdisciplinario que combina ingeniería mecánica, electrónica, control, informática e inteligencia artificial para diseñar, construir, programar y operar robots. Este módulo cubre robótica industrial, robots autónomos, sistemas robóticos (ROS 2), cinemática y dinámica, planificación de movimiento, control, percepción, simuladores, y tendencias como robótica con IA, robots humanoides y cobots (robots colaborativos). El mercado global de robótica superó $40B en 2024. Los robots industriales (ABB, KUKA, Fanuc, Yaskawa) dominan manufacturing, mientras robots de servicio (Boston Dynamics, Unitree, Tesla Optimus) y robots autónomos (Waymo, Zoox, Nuro) avanzan rápidamente. La evolución: robots manipuladores industriales (1960s, Unimate) → robots con sensores y control (1980s-90s) → robots móviles autónomos (2000s, Roomba) → robots colaborativos/cobots (2010s, Universal Robots) → robots con AI/ML (2020s, deep reinforcement learning, foundation models for robotics). Las tendencias actuales incluyen: foundation models for robotics (RT-2, PaLM-E), humanoid robots (Tesla Optimus, Figure 01, Boston Dynamics Atlas), robot learning (imitation learning, reinforcement learning in sim-to-real), edge robotics, y soft robotics.

## Tabla de conceptos clave

| Concepto | Descripción | Tecnologías/Herramientas |
|----------|-------------|------------------------|
| Cinemática (Forward/Inverse) | Relación entre ángulos de articulaciones y posición del efector final | Denavit-Hartenberg (DH), URDF, Pinocchio, Drake |
| Dinámica | Fuerzas y torques que causan movimiento | Euler-Lagrange, Newton-Euler, MuJoCo, Bullet, Drake |
| Planificación de movimiento | Cálculo de trayectoria evitando obstáculos | RRT, RRT*, A* (config space), PRM, CHOMP, TrajOpt |
| Control (PID, MPC) | Regulación de posición/velocidad/fuerza del robot | PID, LQR, Model Predictive Control (MPC) |
| Percepción robótica | Visión, LIDAR, fuerza, tacto para entender el entorno | OpenCV, PCL, TensorFlow, PointNet, YOLO |
| SLAM | Localización y mapeo simultáneos | ICP, GMapping, Cartographer, ORB-SLAM, RTAB-Map |
| ROS 2 | Robot Operating System: framework middleware para robótica | ROS 2 (Humble, Iron), rclcpp, rclpy, Gazebo |
| URDF/SDF | Formatos de descripción de robot (cinemática, geometría, inercia) | URDF, SDFormat, XACRO, Mesh (STL, DAE) |
| Sim-to-Real | Transferencia de políticas aprendidas en simulación al mundo real | Domain randomization, MuJoCo, Isaac Sim, Gazebo |
| Cobot (Collaborative Robot) | Robot diseñado para trabajar junto a humanos sin protecciones | Universal Robots (UR3e, UR5e, UR10e), Fanuc CRX |
| Manipulación | Control de brazos robóticos para interactuar con objetos | Grasping (6-DOF pose, force closure), pick-and-place |
| Movilidad | Navegación de robots móviles (ruedas, patas, tracks) | Differential drive, Ackermann, legged locomotion |

## Tecnologías principales

| Framework | Propósito | Lenguaje | Simulador | Comunidad | Licencia |
|-----------|-----------|----------|-----------|-----------|----------|
| ROS 2 | Middleware robótico, drivers, navegación, manipulación | C++, Python | Gazebo, Ignition | Muy grande (Open Robotics) | Apache 2.0 |
| MoveIt 2 | Planificación de movimiento, manipulación, IK | C++, Python | Gazebo, MuJoCo | Grande | BSD |
| NVIDIA Isaac | Robotics AI, simulation, manipulación, perception | Python, C++ | Isaac Sim (Omniverse) | Creciente | Proprietaria |
| Drake (MIT) | Análisis, planificación, control de robots | C++, Python | Drake Visualizer | Mediana | BSD |
| PyBullet | Simulación, RL, physical engine | Python | PyBullet (standalone) | Mediana | BSD |
| MuJoCo | Simulación física (acelerada, contacto rico) | C, Python, C++ | MuJoCo standalone | Media (Google DeepMind) | Apache 2.0 |
| CoppeliaSim (V-REP) | Simulador robótico, prototipado | C++, Python, Lua, Java | CoppeliaSim | Mediana | Proprietaria |
| Webots | Simulador open source multi-robot | C++, Python, Java, MATLAB | Webots | Mediana | Apache 2.0 |

## Hoja de ruta detallada

1. **Principiante (0-3 meses)**: Conceptos fundamentales: qué es un robot, componentes (actuadores, sensores, controlador, estructura). Tipos de robots: industrial (manipulador 6-DOF), móvil (differential drive, Ackermann), humanoide, aéreo (dron), subacuático, robótica blanda. Cinemática: joints (revolute, prismatic, continuous, planar), links, degrees of freedom (DOF). Cinemática directa: transformation matrices (4×4 homogeneous), Denavit-Hartenberg params (a, alpha, d, theta). ROS 2 básico: instalación (Ubuntu + ROS 2 Humble), nodes, topics, services, actions, launch files. Simulador: Gazebo (world creation, robot models). TurtleBot3 simulation: teleop, SLAM, navigation. Python para robótica: numpy, transformations library.
   - Práctica: Simular TurtleBot3 en Gazebo con ROS 2. Controlar con teleop. Mapear entorno con SLAM y navegar con Nav2.
   - Lectura: "ROS Robot Programming" (Yoon), ROS 2 documentation (docs.ros.org).

2. **Intermedio (3-8 meses)**: Cinemática inversa: métodos geométricos vs numéricos (Jacobian pseudoinverse, Levenberg-Marquardt), IK solvers (TRAC-IK, IKFast). MoveIt 2: setup assistant, planning scene, motion planning (OMPL planners: RRT, RRTConnect, PRM, STOMP), collision checking (FCL), pick-and-place pipeline. Control: PID (proportional, integral, derivative) para posición, velocidad, torque. Odometry: wheel odometry, visual odometry, IMU fusion (EKF, UKF). SLAM: GMapping (2D), Cartographer (2D/3D LIDAR), ORB-SLAM3 (visual+inertial). Navigation Stack (Nav2): map server, AMCL (localization), global planner (Navfn, Smac), local planner (DWB, Pure Pursuit, MPC). Perception: OpenCV (camera calibration, feature matching, ArUco markers), PCL (point clouds, RANSAC plane fitting, clustering), AprilTag detection. Sim-to-Real: sensor noise models, dynamics randomization basics. URDF modeling: creating robot model (links, joints, visuals, collision). Arduino/Raspberry Pi para control de bajo nivel: PWM motor control, encoder reading, PID loops.
   - Proyecto: Manipulador simulado con MoveIt 2 pick-and-place. Robot móvil con Nav2 navigation + SLAM + obstacle avoidance. Real robot + perception pipeline.
   - Lectura: "Introduction to Autonomous Robots" (Siegwart, Nourbakhsh), "Modern Robotics" (Lynch, Park), "Programming Robots with ROS" (Quigley).

3. **Avanzado (8-14 meses)**: Reinforcement Learning para robótica: sim-to-real (domain randomization, DRL algorithms: PPO, SAC, TD3), RL frameworks (Stable-Baselines3, RLlib, Isaac Gym). Task and Motion Planning (TAMP): planificación de tareas (PDDL, PDDLStream) + motion planning. Dynamics modeling: Euler-Lagrange equations, recursive Newton-Euler, URDF dynamics parameters, identification. Force control: impedance control, admittance control, force/torque sensing, assembly tasks. Grasping: grasping synthesis (6-DOF grasp pose, force closure, form closure), suction grasping, compliant grasping. Deep learning for perception: object detection (YOLO, DETR), 6-DOF pose estimation (DenseFusion, PoseCNN), semantic segmentation (PointNet++, SparseConvNet). Multi-robot coordination: centralized vs decentralized planning, collision avoidance (ORCA, CBF), task allocation. Robot calibration: kinematic calibration, hand-eye calibration (eye-in-hand, eye-to-hand), sensor calibration. Real-time control: real-time Linux (PREEMPT_RT), EtherCAT (fieldbus), OROCOS (real-time control), Simulink code generation to real hardware.
   - Proyecto: RL-based grasping policy in simulation → transfer to real. Custom robot arm URDF + MoveIt + real hardware (Dynamixel servos). Multi-robot warehouse coordination.
   - Lectura: "Reinforcement Learning: An Introduction" (Sutton, Barto), "Planning Algorithms" (LaValle), "Robot Dynamics and Control" (Spong, Hutchinson, Vidyasagar).

4. **Experto (12+ meses)**: Foundation models for robotics: RT-2 (Google DeepMind, vision-language-action), PaLM-E (embodied multimodal language model), Llama-Robot (LLM + robot). Robotic foundation models: generalist manipulation policies, zero-shot transfer. Humanoid robotics: whole-body control, walking gait generation (Model Predictive Control + WBC), balance (linear inverted pendulum, capture point). Mobile manipulation: base + arm coordinated control (SE(3) end-effector → base + arm decomposition). Soft robotics: continuum manipulator modeling, pneumatic artificial muscles, Variable stiffness actuators. Swarm robotics: multi-robot systems (1K+ robots), decentralized consensus, swarm intelligence. Medical robotics: surgical robots (da Vinci), capsule endoscopy, rehabilitation robotics. Autonomous driving: planning (behavior planner, trajectory optimization), control (steering, throttle), perception (deep learning on LIDAR/Camera/Radar), localization (HD maps, GPS+IMU). Micro-robotics: nanoscale robots, magnetic actuation. Ethics of robotics: safety standards (ISO 13482, ISO 10218), robot rights, autonomous weapons, job displacement. ROS 2 in production: real-time support (ROS 2 real-time), deterministic execution, certification.
   - Proyecto: Foundation model integration for open-world manipulation. Humanoid walking controller. Swarm robotics simulation with 100+ agents.
   - Lectura: arXiv robotics papers (CoRL, IROS, ICRA, RSS), "Modern Robotics" (Lynch, Park), robotics textbooks, ROS 2 source code.

## Relaciones con otros módulos

| Módulo | Relación |
|--------|----------|
| [000-Core](../000-Core/) | Search algorithms (A* for path planning), kinematics math |
| [001-Languages](../001-Languages/) | C++/Python para ROS 2, Julia para control, Rust para real-time |
| [003-Databases](../003-Databases/) | Robotics data management, time series sensor data |
| [004-OperatingSystems](../004-OperatingSystems/) | Linux con PREEMPT_RT, control de procesos, kernel modules |
| [008-Networking](../008-Networking/) | ROS 2 DDS (Discovery + Serialization), EtherCAT, CAN bus |
| [009-Security](../009-Security/) | Robotic system security, ROS 2 security (SROS2) |
| [028-Embedded](../028-Embedded/) | Embedded control (STM32), motor drivers, sensors |
| [029-IoT](../029-IoT/) | IoT sensors on robots, telemetry, remote robot control |
| [031-AI](../031-AI/) | Computer vision, foundation models, RL, planning |
| [032-MachineLearning](../032-MachineLearning/) | Deep learning for perception, RL, imitation learning |
| [033-DeepLearning](../033-DeepLearning/) | CNNs, Transformers para percepción y control |

## Recursos recomendados

- **Libros**: "Modern Robotics: Mechanics, Planning, and Control" (Lynch, Park) — referencia completa. "Introduction to Autonomous Robots" (Siegwart, Nourbakhsh). "Programming Robots with ROS" (Quigley). "Reinforcement Learning: An Introduction" (Sutton, Barto). "Planning Algorithms" (LaValle).
- **Cursos**: Coursera "Robotics" specialization (UPenn, UToronto), "MIT 6.832 Underactuated Robotics", "Stanford CS237A Robotics", "Robot Dynamics and Control" (ETH Zurich).
- **Simuladores**: Gazebo (ignitionrobotics.org), MuJoCo (mujoco.org), NVIDIA Isaac Sim, CoppeliaSim, Webots.
- **Hardware**: TurtleBot4, Franka Emika Panda, Universal Robots, Raspberry Pi + Arduino, Dynamixel servos, NVIDIA Jetson.
- **ROS 2**: docs.ros.org, ROS Discourse (discourse.ros.org), ROS 2 Design docs, index.ros.org.
- **Conferencias**: ICRA, IROS, CoRL, RSS, ROSCon, NeurIPS Robot Learning Workshop.

## Notas adicionales

ROS 2 es el estándar de facto para investigación y prototipado robótico. Para estudiantes, el turtlebot3 simulation + Gazebo es el mejor punto de entrada. MoveIt es el framework de manipulación más usado. La robótica con learning (RL, imitation learning) está convergiendo con foundation models para crear robots generalistas. El pipeline típico de robot learning: simulation training → domain randomization → sim-to-real transfer. La combinación de ROS 2 + NVIDIA Isaac sim + MuJoCo es el stack moderno recomendado. La seguridad en robótica es crítica: un error puede causar daño físico.
