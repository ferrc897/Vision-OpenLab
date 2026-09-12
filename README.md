
* **ROS 2 Humble Integration:** Multi-threaded node execution with standard parameter handling (`rclpy`).
* **YOLO Real-Time Detection:** Fast object detection using PyTorch and Ultralytics models.
* **Containerized Environment:** Pre-configured Dockerfile.
* **Dynamic GUI Forwarding:** Displays live OpenCV detection.
* **Flexibility & Portability:** Environment configuration through shell execution scripts (`run_dev.sh`) and Docker Compose.

---

## 📁 System Architecture & File Structure

```text
.
├── docker/
│   ├── Dockerfile             # ROS 2 Humble base image + PyTorch & OpenCV dependencies
│   └── docker-compose.yaml    # Service definitions, device passthrough, and volume mounts
├── run_dev.sh                 # Entry script handling X11, UIDs, GIDs, and container spin-up
├── README.md                  # Project documentation
└── src/
    └── yolo_obstacle_detection/
        ├── package.xml        # ROS 2 package metadata
        ├── setup.py           # Python package setup and node entry point declarations
        └── open_lab_vision/
            ├── __init__.py
            ├── main.py        # Main execution loop and OpenCV display pipeline
            └── ros_handler.py # ROS 2 node class handling parameters and loggers
```

---

## 🛠️ Prerequisites

Before running the container, ensure your host operating system has the following installed:

* **Operating System:** Linux (Ubuntu 22.04 LTS recommended)
* **Docker Engine:** `>= 20.10`
* **Docker Compose:** `>= 2.0`
* **Video Device:** USB or integrated camera mounted at `/dev/video0` (or configured index)
* **X11 Server:** Native X11 environment for GUI rendering (`xhost` utility available)

---

## 🚀 Installation & Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/ferrc897/Vision-OpenLab.git
cd Vision-OpenLab
```

### 2. Make the Helper Script Executable

```bash
chmod +x run_dev.sh
```

### 3. Build and Run the Docker Container

To build the image and launch the interactive development shell:

```bash
# First-time setup or rebuild image:
./run_dev.sh --build

# Subsequent launches:
./run_dev.sh
```

*The `run_dev.sh` script automatically detects your host user ID (`UID`), group ID (`GID`), and camera device group (`VIDEO_GID`) to eliminate file ownership conflicts inside shared workspace volumes.*

### 4. Run the ROS 2 Obstacle Detector Node

Inside the container terminal:

```bash
# Build the workspace
colcon build --symlink-install
source install/setup.bash

# Launch the node
ros2 run yolo_obstacle_detection yolo_detector_node
```

*To terminate the camera display, press `q` on the OpenCV window or send `Ctrl+C` in the terminal.*

---

## ⚙️ ROS 2 Interface & Parameters

### Configurable Node Parameters

| Parameter Name | Data Type | Default Value | Description |
| :--- | :--- | :--- | :--- |
| `camera_index` | `int` | `0` | Linux video device index mapped to `/dev/videoX`. |
| `weights` | `string` | `"yolov8n.pt"` | Name or file path of the pretrained YOLO model weights. |

### Overriding Parameters at Runtime

You can pass parameter values directly via `ros2 run`:

```bash
ros2 run open_lab_vision vision_node --ros-args -p camera_index:=1 -p weights:="yolov8s.pt"
```

---

## 💡 Future Improvements

1. **Custom ROS 2 Message Publishers:** Publish detected obstacle coordinates and bounding boxes to `/perception/obstacles` using standard `vision_msgs/msg/Detection2DArray`.
2. **3D Depth Estimation:** Integrate RGB-D cameras (Intel RealSense or ZED) to compute spatial distance ($X, Y, Z$) to obstacles.
3. **Hardware Acceleration:** Export YOLO models to TensorRT (`.engine`) for real-time edge processing on NVIDIA Jetson architectures.
4. **Launch Integration:** Add ROS 2 launch files (`yolo_detector.launch.py`) to launch RViz2 visualization, parameters, and sensor nodes simultaneously.


