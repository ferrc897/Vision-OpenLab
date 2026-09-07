import rclpy
import threading

import cv2
from ultralytics import YOLO

from .ros_handler import RosHandler

def main():
    rclpy.init()
    ros_handler = RosHandler()

    ros_thread = threading.Thread(target=rclpy.spin, args=(ros_handler,), daemon=True)
    ros_thread.start()

    camera = ros_handler.get_parameter('camera_index').value
    cap = cv2.VideoCapture(camera)

    weights = ros_handler.get_parameter('weights').value
    model = YOLO(weights)

    try:
        if not cap.isOpened():
            raise RuntimeError(f"Could not open camera with index {camera}")
        while rclpy.ok():
            ret, frame = cap.read()

            if not ret:
                raise RuntimeError('Could not read from camera')

            result = model(frame,verbose=False)
            img_result = result[0].plot()

            cv2.imshow('my window', img_result)
            cv2.moveWindow('my window', 200, 200)

            if cv2.waitKey(1) == ord('q'):
                break
    except KeyboardInterrupt:
        pass
    except RuntimeError as e :
        ros_handler.get_logger().error(str(e))
    finally: 
        cap.release()
        cv2.destroyAllWindows()

        ros_handler.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
