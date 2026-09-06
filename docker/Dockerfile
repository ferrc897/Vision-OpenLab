FROM ros:humble-ros-base-jammy

ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Delete existing user with same UID if present (e.g. 'ubuntu' on Noble/Jammy base)
RUN if id -u $USER_UID >/dev/null 2>&1; then userdel -r `id -un $USER_UID`; fi

# Create non-root user with sudo permissions
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install ROS 2 packages and C++ / system dependencies for OpenCV and PyTorch
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    python3-colcon-common-extensions \
    ros-humble-cv-bridge \
    ros-humble-image-transport \
    ros-humble-sensor-msgs \
    ros-humble-vision-msgs \
    ros-humble-rviz2 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install ML dependencies (PyTorch CPU, OpenVINO, Ultralytics, Depth Anything requirements)
RUN pip3 install --no-cache-dir --break-system-packages \
    torch torchvision --index-url https://download.pytorch.org/whl/cpu && \
    pip3 install --no-cache-dir --break-system-packages \
    ultralytics \
    openvino \
    transformers \
    huggingface_hub \
    onnxruntime \
    opencv-python

ENV SHELL=/bin/bash

# Set workspace directory and permissions for non-root user
WORKDIR /ros2_ws
RUN chown -R $USERNAME:$USERNAME /ros2_ws

USER $USERNAME
CMD ["/bin/bash"]
