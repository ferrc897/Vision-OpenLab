import rclpy
from rclpy.node import Node

class RosHandler(Node):
    def __init__(self):
        super().__init__('open_lab_vision_node')

        self.declare_parameter('weights', 'yolo26n.pt')
        self.declare_parameter('camera_index', 0)
        self.get_logger().info("Creating node")

        self.current_obstacles = {}
