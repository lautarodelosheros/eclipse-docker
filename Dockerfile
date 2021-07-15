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
ARG ECLIPSE_VERSION=${ECLIPSE_VERSION:-2021-06}
ENV ECLIPSE_VERSION=${ECLIPSE_VERSION}

## -- 2.) Eclipse Type: -- ##
ARG ECLIPSE_TYPE=${ECLIPSE_TYPE:-parallel}

## -- 3.) Eclipse Release: -- ##
ARG ECLIPSE_RELEASE=${ECLIPSE_RELEASE:-R}

## -- 4.) Eclipse Download Mirror site: -- ##
ARG ECLIPSE_OS_BUILD=${ECLIPSE_OS_BUILD:-linux-gtk-x86_64}

## -- 5.) Eclipse Download Mirror site: -- ##
ARG ECLIPSE_MIRROR_SITE_URL=${ECLIPSE_MIRROR_SITE_URL:-http://mirror.math.princeton.edu}

## ----------------------------------------------------------------------------------- ##
## ----------------------------------------------------------------------------------- ##
## ----------- Don't change below unless Eclipse download system change -------------- ##
## ----------------------------------------------------------------------------------- ##
## ----------------------------------------------------------------------------------- ##
## -- Eclipse TAR/GZ filename: -- ##
ARG ECLIPSE_TAR=${ECLIPSE_TAR:-eclipse-${ECLIPSE_TYPE}-${ECLIPSE_VERSION}-${ECLIPSE_RELEASE}-${ECLIPSE_OS_BUILD}.tar.gz}

## -- Eclipse Download route: -- ##
ARG ECLIPSE_DOWNLOAD_ROUTE=${ECLIPSE_DOWNLOAD_ROUTE:-pub/eclipse/technology/epp/downloads/release/${ECLIPSE_VERSION}/${ECLIPSE_RELEASE}}

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
RUN sudo apt-get install -y \
    openjdk-11-jdk \
    libswt-gtk* \
    gcc \
    gfortran \
    build-essential

ENV JAVA_HOME /usr/lib/jvm/java-1.11.0-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH
    
USER ${USER_NAME}
WORKDIR ${ECLIPSE_WORKSPACE}
CMD ["/opt/eclipse/eclipse"]

