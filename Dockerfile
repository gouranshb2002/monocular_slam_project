# --- Base Image ---
FROM ubuntu:20.04

# --- Set Environment Variables ---
ENV DEBIAN_FRONTEND=noninteractive

# --- Install Base Dependencies ---
# Includes all deps: OpenCV, Pangolin, Boost, and OpenSSL
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    pkg-config \
    wget \
    unzip \
    tar \
    # Eigen3
    libeigen3-dev \
    # Pangolin Dependencies
    libglew-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libepoxy-dev \
    libpython3-dev \
    python3-setuptools \
    python3-pip \
    # OpenCV Build Dependencies
    libgtk2.0-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libdc1394-22-dev \
    # ORB-SLAM3 Dependencies
    libboost-all-dev \
    libssl-dev \
    libboost-serialization-dev \
    # Cleanup
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Install Python packages ---
RUN pip3 install wheel numpy

# --- Build Pangolin v0.6 (C++11 Compatible) ---
WORKDIR /root
RUN git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
WORKDIR /root/Pangolin
# Checkout older C++11 compatible version
RUN git checkout v0.6
RUN mkdir build
WORKDIR /root/Pangolin/build
# Apply flags to disable OpenEXR and suppress warnings
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_PANGO_IMAGE_OPENEXR=OFF -DCMAKE_CXX_FLAGS="-Wno-error -Wno-deprecated-copy"
# Compile and install Pangolin
RUN make -j$(nproc) && make install
# Clean up Pangolin source
WORKDIR /root
RUN rm -rf /root/Pangolin

# --- Build OpenCV 4.5.5 from Source ---
ENV OPENCV_VERSION="4.5.5"
WORKDIR /root
# Download source code
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
    && wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip \
    && unzip opencv.zip \
    && unzip opencv_contrib.zip \
    && mv opencv-${OPENCV_VERSION} opencv \
    && mv opencv_contrib-${OPENCV_VERSION} opencv_contrib

# Configure OpenCV build with CMake
WORKDIR /root/opencv
RUN mkdir build && cd build \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE \
             -D CMAKE_INSTALL_PREFIX=/usr/local \
             -D OPENCV_EXTRA_MODULES_PATH=/root/opencv_contrib/modules \
             -D BUILD_SHARED_LIBS=ON \
             -D BUILD_EXAMPLES=OFF \
             -D BUILD_DOCS=OFF \
             -D BUILD_TESTS=OFF \
             -D BUILD_PERF_TESTS=OFF \
             -D BUILD_opencv_python2=OFF \
             -D BUILD_opencv_python3=ON \
             -D PYTHON3_EXECUTABLE=$(which python3) \
             -D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
             -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
             ..

# Compile and Install OpenCV (This will take a very long time!)
WORKDIR /root/opencv/build
RUN make -j$(nproc) \
    && make install \
    && ldconfig \
    # Clean up OpenCV source and archives
    && cd / \
    && rm -rf /root/opencv /root/opencv.zip /root/opencv_contrib /root/opencv_contrib.zip

# --- Set Final Working Directory ---
WORKDIR /root
