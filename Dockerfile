FROM sunside/ros-gazebo-gpu:kinetic-nvidia

USER root

# Install required ROS packages, as well as GDB for debugging.
RUN apt-get update && apt-get install -y \
    ros-kinetic-gazebo-ros-control \
    ros-kinetic-effort-controllers \
    ros-kinetic-joint-state-controller \
    gdb \
 && rm -rf /var/lib/apt/lists/*

# Install packages for Where Am I? project
RUN apt-get update && apt-get install -y \
    ros-kinetic-navigation \
    ros-kinetic-map-server \
    ros-kinetic-move-base \
    ros-kinetic-amcl \
    libignition-math2-dev \
    protobuf-compiler \
 && rm -rf /var/lib/apt/lists/*

# Install packages for Map My World project
RUN apt-get update && apt-get install -y \
    ros-kinetic-rtabmap \
    ros-kinetic-rtabmap-ros \
 && rm -rf /var/lib/apt/lists/*

# Allow SSH login into the container.
# See e.g. https://github.com/JetBrains/clion-remote/blob/master/Dockerfile.remote-cpp-env
RUN ( \
    echo 'LogLevel DEBUG2'; \
    echo 'PermitRootLogin yes'; \
    echo 'PasswordAuthentication yes'; \
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
  ) > /etc/ssh/sshd_config_test_clion \
  && mkdir /run/sshd

# Start SSH server and run bash as the ros user.
USER ros
ENTRYPOINT sudo service ssh restart && bash
