FROM osrf/ros:noetic-desktop-full
ENV CATKIN_WS=/root/catkin_ws

    # setup processors number used to compile library
RUN apt-get update && DEBIAN_FRONTEND=noninteractive\
    apt-get install -y \
        cmake gcc g++ git wayland-protocols \
        libglew-dev libeigen3-dev

RUN git config --global http.sslVerify false
RUN git clone https://github.com/Dismac/Sophus_fixed.git && \
    cd Sophus_fixed/Sophus && \
    mkdir build && cd build && \
    cmake .. && \
    make -j${USE_PROC} install && \
    cd ../../.. && \
    git clone https://github.com/Livox-SDK/Livox-SDK.git && \
    cd Livox-SDK && \
    cd build && cmake .. && \
    make -j${USE_PROC} install && \
    mkdir -p /root/catkin_ws/src/ && \
    cd ../.. && \
    git clone https://github.com/Livox-SDK/livox_ros_driver.git ws_livox/src && \
    cd ws_livox
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /ws_livox; catkin_make'
    
RUN cd /root/catkin_ws/src/ && \
    git clone https://github.com/Dismac/rpg_vikit.git && \
    git clone https://github.com/Dismac/FAST-LIVO.git && \
    cd ../
RUN /bin/bash -c '. /ws_livox/devel/setup.bash; cd /root/catkin_ws; catkin_make'
CMD ["bash"]



