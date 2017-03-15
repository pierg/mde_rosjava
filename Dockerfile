FROM ros:indigo-ros-base

#update apt-get source list
RUN apt-get update

#install necessary packages
RUN apt-get install -q -y g++ wget

#install image processing related packages
RUN apt-get install -q -y ros-indigo-rosjava \
    ros-indigo-rosjava \
    ros-indigo-rqt-* \
    ros-indigo-rqt \
    ros-indigo-turtlebot \
    ros-indigo-turtlebot-apps \
    ros-indigo-turtlebot-interactions \
    ros-indigo-turtlebot-simulator

# #install gazebo 7
# RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
# RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
# RUN apt-get update
# RUN apt-get install -q -y gazebo7 libgazebo7-dev ros-indigo-gazebo7-ros 


# Add oracle-jdk7 to repositories
RUN add-apt-repository ppa:webupd8team/java -y

# Update apt
RUN apt-get update

# Install oracle-jdk7
RUN apt-get -y install oracle-java7-installer

# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-2.0-bin.zip
RUN unzip gradle-2.0-bin.zip
RUN mv gradle-2.0 /opt/
RUN rm gradle-2.0-bin.zip


#create and init catkin_ws
RUN mkdir -p ~/catkin_ws/src
RUN bash -c "source /opt/ros/indigo/setup.bash;catkin_init_workspace ~/catkin_ws/src"
RUN bash -c "source /opt/ros/indigo/setup.bash;catkin_make -C ~/catkin_ws"

# Environment variables
ENV GRADLE_HOME /opt/gradle-2.0

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Clean up
RUN apt-get clean

# setup entrypoint
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]