FROM openkbs/jdk-mvn-py3-x11

## -------------------------------------------------------------------------------
## ---- USER_NAME is defined in parent image: openkbs/jdk-mvn-py3-x11 already ----
## -------------------------------------------------------------------------------
ENV USER_NAME=${USER_NAME:-developer}
ENV HOME=/home/${USER_NAME}
ENV ECLIPSE_WORKSPACE=${HOME}/eclipse-workspace

## ----------------------------------------------------------------------------
## ---- To change to different Eclipse version: e.g., oxygen, change here! ----
## ----------------------------------------------------------------------------

## -- 1.) Eclipse version: oxygen, photon, etc.: -- ##
ARG ECLIPSE_VERSION=${ECLIPSE_VERSION:-2021-12}
ENV ECLIPSE_VERSION=${ECLIPSE_VERSION}

## -- 2.) Eclipse Type: -- ##
ARG ECLIPSE_TYPE=${ECLIPSE_TYPE:-committers}

## -- 3.) Eclipse Release: -- ##
ARG ECLIPSE_RELEASE=${ECLIPSE_RELEASE:-R}

## -- 4.) Eclipse Download Mirror site: -- ##
ARG ECLIPSE_OS_BUILD=${ECLIPSE_OS_BUILD:-linux-gtk-x86_64}

## -- 5.) Eclipse Download Mirror site: -- ##
ARG ECLIPSE_MIRROR_SITE_URL=${ECLIPSE_MIRROR_SITE_URL:-https://espejito.fder.edu.uy}

## ----------------------------------------------------------------------------------- ##
## ----------------------------------------------------------------------------------- ##
## ----------- Don't change below unless Eclipse download system change -------------- ##
## ----------------------------------------------------------------------------------- ##
## ----------------------------------------------------------------------------------- ##
## -- Eclipse TAR/GZ filename: -- ##
ARG ECLIPSE_TAR=${ECLIPSE_TAR:-eclipse-${ECLIPSE_TYPE}-${ECLIPSE_VERSION}-${ECLIPSE_RELEASE}-${ECLIPSE_OS_BUILD}.tar.gz}

## -- Eclipse Download route: -- ##
ARG ECLIPSE_DOWNLOAD_ROUTE=${ECLIPSE_DOWNLOAD_ROUTE:-/eclipse/technology/epp/downloads/release/${ECLIPSE_VERSION}/${ECLIPSE_RELEASE}}

## -- Eclipse Download full URL: -- ##
## e.g.: http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/
ARG ECLIPSE_DOWNLOAD_URL=${ECLIPSE_DOWNLOAD_URL:-${ECLIPSE_MIRROR_SITE_URL}/${ECLIPSE_DOWNLOAD_ROUTE}}

## http://mirror.math.princeton.edu/pub/eclipse/technology/epp/downloads/release/photon/R/eclipse-modeling-photon-R-linux-gtk-x86_64.tar.gz
WORKDIR /opt
RUN sudo wget -q -c --no-check-certificate ${ECLIPSE_DOWNLOAD_URL}/${ECLIPSE_TAR} && \
    sudo tar xvf ${ECLIPSE_TAR} && \
    sudo rm -f ${ECLIPSE_TAR} 

##################################
#### Set up user environments ####
##################################
VOLUME ${ECLIPSE_WORKSPACE}
VOLUME ${HOME}/.eclipse 

RUN mkdir -p ${HOME}/.eclipse ${ECLIPSE_WORKSPACE} &&\
    sudo chown -R ${USER_NAME}:${USER_NAME} ${ECLIPSE_WORKSPACE} ${HOME}/.eclipse

##################################
####### Photran preparation ######
##################################

# install java 6
COPY jdk-6u45-linux-x64.bin .
RUN sudo chmod +x jdk-6u45-linux-x64.bin && \
    sudo sh jdk-6u45-linux-x64.bin

# fix error on package updating nodejs no needed
RUN sudo apt-get -y remove nodejs
RUN sudo apt-get -y remove npm
RUN ls /etc/apt/sources.list.d
RUN sudo rm -f /etc/apt/sources.list.d/nodesource.list


# install packages needed
RUN sudo apt-get -qq update --fix-missing && sudo apt-get install -y \
    openjdk-11-jdk \
    libswt-gtk* \
    gcc \
    gfortran \
    build-essential \
    dbus-x11 \
    zip \
    git \
    nano \
    ant

ENV JAVA_HOME /usr/lib/jvm/java-1.11.0-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

RUN umask 000
COPY photran7split.z01 /opt/photran7split.z01
COPY photran7split.z02 /opt/photran7split.z02
COPY photran7split.z03 /opt/photran7split.z03
COPY photran7split.z04 /opt/photran7split.z04
COPY photran7split.z05 /opt/photran7split.z05
COPY photran7split.z06 /opt/photran7split.z06
COPY photran7split.zip /opt/photran7split.zip
RUN sudo zip -F -q photran7split.zip --out photran7.zip && \
    echo 'Extracting photran enviroment ...' && \
    sudo unzip -q photran7.zip && \
    sudo rm -f photran7.zip && \
    sudo rm -f photran7split.z01 && \
    sudo rm -f photran7split.z02 && \
    sudo rm -f photran7split.z03 && \
    sudo rm -f photran7split.z04 && \
    sudo rm -f photran7split.z05 && \
    sudo rm -f photran7split.z06 && \
    sudo rm -f photran7split.zip && \
    echo 'Done.'

COPY eclipse.ini /opt/eclipse-indigo-rcp-64/

COPY photran5 /opt/photran5
#COPY photran-clone /opt/photran-clone

RUN echo 'Updating permissions (this may take several minutes) ...' && \
    sudo chmod -R 777 /opt && \
    echo 'Done.'

# Maven installation
#RUN sudo wget https://apache.dattatec.com/maven/maven-3/3.8.3/binaries/apache-maven-3.8.3-bin.tar.gz && \
#    sudo tar xvf apache-maven-3.8.3-bin.tar.gz && \
#    sudo rm -f apache-maven-3.8.3-bin.tar.gz && \
#    sudo ln -s /opt/apache-maven-3.8.3 /opt/maven

#ENV MAVEN_HOME /opt/apache-maven-3.8.3
#ENV PATH $MAVEN_HOME/bin:$PATH

# Photran 9 compilation
#WORKDIR /opt/photran-clone
#RUN mvn clean install

# Cmdline Photran 5 compilation
#WORKDIR /opt/photran5/org.eclipse.photran.cmdline/build
#RUN ant

USER ${USER_NAME}
WORKDIR ${ECLIPSE_WORKSPACE}
CMD ["/opt/eclipse/eclipse"]

