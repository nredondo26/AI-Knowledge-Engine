# ROS — Robot Operating System

## Visión General

ROS (Robot Operating System) es un framework de middleware para desarrollo de software robótico. No es un sistema operativo real, sino un conjunto de herramientas, bibliotecas y convenciones que simplifican la creación de comportamientos robóticos complejos. ROS 2 (basado en DDS) es la versión actual.

## Arquitectura

```
┌─────────────────────────────────────────┐
│              ROS 2 Graph                │
│                                         │
│  ┌──────┐   /topic   ┌──────┐          │
│  │Node A│ ────────▶  │Node B│          │
│  │pub:  │            │sub:  │          │
│  │scan  │            │scan  │          │
│  └──┬───┘            └──────┘          │
│     │ service                            │
│     ▼ /srv                              │
│  ┌──────┐                              │
│  │Node C│                              │
│  │srv:  │                              │
│  │nav   │                              │
│  └──────┘                              │
└─────────────────────────────────────────┘
```

## Conceptos Fundamentales

| Concepto | Descripción | Analogía |
|----------|-------------|----------|
| **Node** | Unidad ejecutable que realiza cómputo | Proceso |
| **Topic** | Canal de comunicación pub/sub asíncrono | Bus |
| **Message** | Estructura de datos tipada | Struct/Protobuf |
| **Service** | Comunicación síncrona request/response | RPC |
| **Action** | Tarea de larga duración con feedback | Job |
| **Parameter** | Configuración dinámica | Key-value store |
| **Bag** | Grabación de mensajes para playback | Log |

## Instalación (ROS 2 Humble)

```bash
# Ubuntu 22.04
sudo apt install software-properties-common
sudo add-apt-repository universe
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
  -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
  http://packages.ros.org/ros2/ubuntu jammy main" | \
  sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update
sudo apt install ros-humble-desktop python3-colcon-common-extensions

# Setup
source /opt/ros/humble/setup.bash
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
```

## Estructura de un Workspace

```
mi_robot_ws/
├── src/
│   ├── mi_robot_bringup/
│   │   ├── package.xml
│   │   ├── launch/
│   │   └── CMakeLists.txt
│   ├── mi_robot_description/
│   │   ├── urdf/
│   │   ├── meshes/
│   │   ├── package.xml
│   │   └── CMakeLists.txt
│   ├── mi_robot_navigation/
│   │   ├── package.xml
│   │   ├── config/
│   │   └── CMakeLists.txt
│   └── mi_robot_sensors/
│       ├── src/
│       ├── include/
│       ├── package.xml
│       └── CMakeLists.txt
├── install/
├── build/
└── log/
```

## Nodo Simple en Python

```python
#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from std_msgs.msg import String
from geometry_msgs.msg import Twist

class TeleopNode(Node):
    def __init__(self):
        super().__init__('teleop_node')
        self.publisher_ = self.create_publisher(Twist, '/cmd_vel', 10)
        self.subscription = self.create_subscription(
            String, '/keyboard_input', self.keyboard_callback, 10)

    def keyboard_callback(self, msg):
        cmd = Twist()
        if msg.data == 'w':
            cmd.linear.x = 0.5
        elif msg.data == 's':
            cmd.linear.x = -0.5
        elif msg.data == 'a':
            cmd.angular.z = 0.5
        elif msg.data == 'd':
            cmd.angular.z = -0.5
        self.publisher_.publish(cmd)

def main(args=None):
    rclpy.init(args=args)
    node = TeleopNode()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()
```

## Nodo en C++

```cpp
#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"

class MinimalSubscriber : public rclcpp::Node {
public:
    MinimalSubscriber() : Node("minimal_subscriber") {
        subscription_ = this->create_subscription<std_msgs::msg::String>(
            "topic", 10,
            [this](const std_msgs::msg::String &msg) {
                RCLCPP_INFO(this->get_logger(), "Received: %s", msg.data.c_str());
            });
    }

private:
    rclcpp::Subscription<std_msgs::msg::String>::SharedPtr subscription_;
};

int main(int argc, char *argv[]) {
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<MinimalSubscriber>());
    rclcpp::shutdown();
    return 0;
}
```

## Servicio (Srv)

```bash
# Crear definición de servicio
mkdir -p srv
cat > srv/DetectObject.srv << EOF
bool enable_detection
---
string[] detected_objects
float64[] confidences
EOF
```

## Actions (Larga Duración)

```python
# action/NavigateToGoal.action
# Goal
geometry_msgs/PoseStamped target_pose
---
# Result
bool success
float64 travel_time
---
# Feedback
float64 distance_remaining
float64 progress_percentage
```

```python
from rclpy.action import ActionServer
from mi_robot_interfaces.action import NavigateToGoal

class NavigationActionServer(Node):
    def __init__(self):
        super().__init__('navigation_server')
        self.action_server = ActionServer(
            self,
            NavigateToGoal,
            'navigate_to_goal',
            self.execute_callback
        )

    async def execute_callback(self, goal_handle):
        feedback = NavigateToGoal.Feedback()
        feedback.distance_remaining = 10.0
        feedback.progress_percentage = 0.0

        while feedback.distance_remaining > 0.1:
            feedback.distance_remaining -= 0.5
            feedback.progress_percentage = 100.0 * (1.0 - feedback.distance_remaining / 10.0)
            goal_handle.publish_feedback(feedback)

        goal_handle.succeed()
        result = NavigateToGoal.Result()
        result.success = True
        result.travel_time = 5.0
        return result
```

## TF (Transform Frames)

```python
import tf2_ros
from geometry_msgs.msg import TransformStamped

class TFBroadcaster(Node):
    def __init__(self):
        super().__init__('tf_broadcaster')
        self.tf_broadcaster = tf2_ros.TransformBroadcaster(self)
        self.timer = self.create_timer(0.1, self.broadcast_tf)

    def broadcast_tf(self):
        t = TransformStamped()
        t.header.stamp = self.get_clock().now().to_msg()
        t.header.frame_id = 'odom'
        t.child_frame_id = 'base_link'
        t.transform.translation.x = 0.5
        t.transform.translation.y = 0.0
        t.transform.translation.z = 0.0
        t.transform.rotation.w = 1.0
        self.tf_broadcaster.sendTransform(t)
```

## URDF (Descripción del Robot)

```xml
<?xml version="1.0"?>
<robot name="mi_robot">
  <link name="base_link">
    <visual>
      <geometry>
        <box size="0.4 0.3 0.1"/>
      </geometry>
      <origin xyz="0 0 0.05"/>
    </visual>
  </link>

  <joint name="left_wheel_joint" type="continuous">
    <parent link="base_link"/>
    <child link="left_wheel"/>
    <origin xyz="-0.1 0.2 -0.05"/>
    <axis xyz="0 1 0"/>
  </joint>

  <link name="left_wheel">
    <visual>
      <geometry>
        <cylinder radius="0.05" length="0.04"/>
      </geometry>
    </visual>
  </link>

  <transmission name="left_wheel_trans">
    <type>transmission_interface/SimpleTransmission</type>
    <joint name="left_wheel_joint">
      <hardwareInterface>hardware_interface/VelocityJointInterface</hardwareInterface>
    </joint>
    <actuator name="left_motor">
      <mechanicalReduction>1</mechanicalReduction>
    </actuator>
  </transmission>
</robot>
```

## SLAM con Nav2

```bash
# TurtleBot3 simulación
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
ros2 launch turtlebot3_cartographer cartographer.launch.py use_sim_time:=True
ros2 run turtlebot3_teleop teleop_keyboard
```

### Configuración de Navigation2

```yaml
# nav2_config.yaml
bt_navigator:
  ros__parameters:
    plugin_sequences: ['navigate_to_pose', 'navigate_through_poses']
    navigate_to_pose:
      plugins: ['compute_path_to_pose', 'follow_path']
    default_nav_to_pose_bt_xml: '/opt/ros/humble/share/nav2_bt_navigator/behavior_trees/navigate_to_pose_w_replanning.xml'

local_costmap:
  local_costmap:
    ros__parameters:
      resolution: 0.05
      width: 3.0
      height: 3.0
      plugins: ['voxel_layer', 'inflation_layer']
      inflation_layer:
        plugin: 'nav2_costmap_2d::InflationLayer'
        inflation_radius: 0.55
```

## Herramientas CLI

```bash
# Ver grafos de nodos
ros2 node list
ros2 node info /teleop_node

# Manipular topics
ros2 topic list
ros2 topic echo /scan
ros2 topic pub /cmd_vel geometry_msgs/Twist "{linear: {x: 0.5}}"

# Servicios
ros2 service list
ros2 service call /spawn turtlesim/srv/Spawn "{x: 2, y: 2}"

# Parámetros
ros2 param list
ros2 param set /navigation_server use_sim_time True

# Acciones
ros2 action list
ros2 action send_goal /navigate_to_pose nav2_msgs/action/NavigateToPose "{pose: {header: {frame_id: 'map'}, pose: {position: {x: 1.0, y: 2.0}}}}"

# Launch files
ros2 launch mi_robot_bringup robot.launch.py

# Bags
ros2 bag record /scan /odom /tf
ros2 bag play recorded_bag
```

## Simulación con Gazebo

```xml
<!-- sdf/model.sdf -->
<model name="robot">
  <link name="chassis">
    <pose>0 0 0.1 0 0 0</pose>
    <collision name="collision">
      <geometry>
        <box><size>0.4 0.3 0.2</size></box>
      </geometry>
    </collision>
  </link>

  <!-- Sensores -->
  <plugin name="lidar" filename="libgazebo_ros_ray_sensor.so">
    <ros>
      <namespace>/</namespace>
      <argument>~/out:=scan</argument>
    </ros>
    <ray>
      <scan>
        <horizontal>
          <samples>360</samples>
          <resolution>1</resolution>
          <min_angle>-3.14159</min_angle>
          <max_angle>3.14159</max_angle>
        </horizontal>
      </scan>
      <range>
        <min>0.1</min>
        <max>30.0</max>
        <resolution>0.01</resolution>
      </range>
    </ray>
  </plugin>
</model>
```

## ROS 1 vs ROS 2

| Característica | ROS 1 (Noetic) | ROS 2 (Humble/Iron) |
|---------------|----------------|---------------------|
| Middleware | TCPROS/UDPROS | DDS (FastDDS, CycloneDDS) |
| Transporte | XML-RPC + TCP | DDS (omni-presente) |
| QoS | No | Sí (reliability, durability, history) |
| Multi-robot | Complejo | Nativo (DDS discovery) |
| Tiempo real | No | Sí (parches PREEMPT_RT) |
| Seguridad | SROS (limitado) | SROS2 + DDS Security |
| Python 2/3 | Python 2 | Python 3 |
| Systems | Linux | Linux, Windows, macOS, RTOS |

## Referencias

- [ROS 2 Documentation](https://docs.ros.org/en/humble/)
- [ROS 2 Design](https://design.ros2.org/)
- [Nav2](https://navigation.ros.org/)
- [Gazebo Simulator](https://gazebosim.org/)
- [MoveIt 2](https://moveit.ros.org/)
- [ROS Index](https://index.ros.org/)
