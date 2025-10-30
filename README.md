# Monocular SLAM Project (ORB-SLAM3)
### V1.0, October 30th, 2025

**Author:** Gouransh Bhatnagar

# Related Publications:

* [ORB-SLAM3] Carlos Campos, Richard Elvira, Juan J. Gómez Rodríguez, José M. M. Montiel and Juan D. Tardós, **ORB-SLAM3: An Accurate Open-Source Library for Visual, Visual-Inertial and Multi-Map SLAM**, *IEEE Transactions on Robotics 37(6):1874-1890, Dec. 2021*. **[PDF](https://arxiv.org/abs/2007.11898)**.

* [IMU-Initialization] Carlos Campos, J. M. M. Montiel and Juan D. Tardós, **Inertial-Only Optimization for Visual-Inertial Initialization**, *ICRA 2020*. **[PDF](https://arxiv.org/pdf/2003.05766.pdf)**

* [ORBSLAM-Atlas] Richard Elvira, J. M. M. Montiel and Juan D. Tardós, **ORBSLAM-Atlas: a robust and accurate multi-map system**, *IROS 2019*. **[PDF](https://arxiv.org/pdf/1908.11585.pdf)**.

* [ORBSLAM-VI] Raúl Mur-Artal, and Juan D. Tardós, **Visual-inertial monocular SLAM with map reuse**, IEEE Robotics and Automation Letters, vol. 2 no. 2, pp. 796-803, 2017. **[PDF](https://arxiv.org/pdf/1610.05949.pdf)**. 

* [Stereo and RGB-D] Raúl Mur-Artal and Juan D. Tardós. **ORB-SLAM2: an Open-Source SLAM System for Monocular, Stereo and RGB-D Cameras**. *IEEE Transactions on Robotics,* vol. 33, no. 5, pp. 1255-1262, 2017. **[PDF](https://arxiv.org/pdf/1610.06475.pdf)**.

* [Monocular] Raúl Mur-Artal, José M. M. Montiel and Juan D. Tardós. **ORB-SLAM: A Versatile and Accurate Monocular SLAM System**. *IEEE Transactions on Robotics,* vol. 31, no. 5, pp. 1147-1163, 2015. (**2015 IEEE Transactions on Robotics Best Paper Award**). **[PDF](https://arxiv.org/pdf/1502.00956.pdf)**.

* [DBoW2 Place Recognition] Dorian Gálvez-López and Juan D. Tardós. **Bags of Binary Words for Fast Place Recognition in Image Sequences**. *IEEE Transactions on Robotics,* vol. 28, no. 5, pp. 1188-1197, 2012. **[PDF](http://doriangalvez.com/php/dl.php?dlp=GalvezTRO12.pdf)**

# 1. About the Project

This project is based on **ORB-SLAM3** developed by Carlos Campos, Richard Elvira, Juan J. Gómez Rodríguez, José M. M. Montiel, Juan D. Tardos.

**ORB-SLAM:** It is a state-of-the-art, open-source library for Simultaneous Localization and Mapping (SLAM). It is the first system capable of performing Visual, Visual-Inertial, and Multi-Map SLAM with a single library.

Key Features relevant to this project include:

* **Sensor Support:** It works with monocular (single camera), stereo (two cameras), RGB-D (color + depth), and visual-inertial (camera + IMU) setups.

* **Monocular Mode:** As used in this project, it can build a full 3D map and track camera motion from a single video feed.

* **High Accuracy:** It uses advanced optimization techniques (like Bundle Adjustment and g2o) to minimize errors and create precise maps.

* **Robust Relocalization:** Using a "bag of words" (DBoW2) place recognition system, it can figure out where it is even after tracking fails or it gets "lost."

* **Atlas Multi-Map System:** It can create and merge multiple sub-maps, allowing it to handle large-scale environments and long-term operation.

# 2. Dataset Used

This project uses standard benchmark datasets to test and demonstrate the SLAM system. The datasets are mounted into the Docker container at '/root/Datasets/' .

* **KITTI Odometry (Sequence 00):**
    * **Type:** Monocular video from a car driving through a city.
    * **Use:** This is the primary long-sequence demonstration for the `mono_kitti` executable.

* **TUM RGB-D (freiburg1_xyz):**
    * **Type:** Monocular video from a handheld camera in an office.
    * **Use:** A short, standard sequence for testing the `mono_tum` executable, which provides a good visualization.

* **EuRoC MAV (MH_01_easy):**
    * **Type:** Monocular video from a drone in a large industrial hall.
    * **Use:** A fast, non-visual benchmark run using the `mono_euroc` executable.

# 3. Prerequisites (Managed by Docker)

This project uses **Docker** to provide a consistent and reproducible build environment, solving all complex dependency issues.

The `Dockerfile` provided in this repository builds a custom image based on **Ubuntu 20.04** with the following critical libraries compiled and installed:

* **C++11 Compiler** (g++)
* **OpenCV 4.5.5** (Built from source, as the default Ubuntu version is too old)
* **Pangolin v0.6** (Built from source; this specific version is required for C++11 compatibility with ORB-SLAM3)
* **Eigen3** (v3.3.7)
* **Boost** (v1.71, specifically `libboost-all-dev` and `libboost-serialization-dev`)
* **OpenSSL** (`libssl-dev`)
* **g2o** and **DBoW2** (Included in the `Thirdparty` folder of ORB-SLAM3)
* **Python 3** (with `numpy` and `wheel` for evaluation scripts)

# 4. How to Run the Project

This project uses a pre-compiled Docker image named `my_orb_slam_project` to save time.

### Step 1: Start the Container:

From the project's root directory (where `run.sh` is), simply run the script:
```
./run.sh
```
This script automatically handles GUI permissions and mounts the necessary folders (Datasets and the project directory) into the container.

### Step 2: Run an Example:

You will be placed inside the container's terminal ( 'root@...' ). All code is pre-compiled and located in '~/ORB_SLAM3' .
1. Navigate to the code directory:
```
cd ~/ORB_SLAM3
```
Then, run any of the example commands below.

* Example 1: **KITTI** (Long Sequence with Viewer):

This is the best example for a full demonstration. It runs on a long sequence of a car driving through a city.
```
Examples/Monocular/mono_kitti \
Vocabulary/ORBvoc.txt \
Examples/Monocular/KITTI00-02.yaml \
/root/Datasets/KITTI_odometry/dataset/sequences/00
```

* Example 2: **TUM** (Short Sequence with Viewer):

This is a short (~26 second) sequence from the TUM dataset. It's a great, quick test to see the 3D viewer working.
```
Examples/Monocular/mono_tum \
Vocabulary/ORBvoc.txt \
Examples/Monocular/TUM1.yaml \
/root/Datasets/TUM/rgbd_dataset_freiburg1_xyz
```

* Example 3: **EuRoC** (Fast Execution, No Viewer):

This executable does not have a viewer. It will just process the data and save the trajectory file, which is good for fast experiments.
```
Examples/Monocular/mono_euroc \
Vocabulary/ORBvoc.txt \
Examples/Monocular/EuRoC.yaml \
/root/Datasets/EuRoC/ \
Examples/Monocular/EuRoC_TimeStamps/MH01.txt
```
