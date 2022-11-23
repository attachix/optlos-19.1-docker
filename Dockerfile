    # Build environment for LineageOS

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

ARG CONTAINER_USER=build

RUN useradd ${CONTAINER_USER} && cp -r /etc/skel/ /home/${CONTAINER_USER}/ && \
    mkdir /home/${CONTAINER_USER}/bin && \
    chown -R ${CONTAINER_USER}:${CONTAINER_USER} /home/${CONTAINER_USER}

RUN apt-get update && \
    apt-get install -y \
        wget \
        bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick \
        lib32ncurses5-dev lib32readline-dev lib32z1-dev libelf-dev liblz4-tool libncurses5 libncurses5-dev \
        libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync \
        schedtool squashfs-tools xsltproc \
        zip zlib1g-dev python sudo && \
        rm -rf /var/cache/apt/*

RUN wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip && \
    unzip platform-tools-latest-linux.zip -d /home/${CONTAINER_USER}/bin && \
    rm platform-tools-latest-linux.zip && \
    wget https://storage.googleapis.com/git-repo-downloads/repo -O /home/${CONTAINER_USER}/bin/repo && \
    chmod a+x /home/${CONTAINER_USER}/bin/repo

RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER ${CONTAINER_USER}

ENV PATH=${PATH}:/home/build/bin/platform-tools:/home/build/bin/
RUN git config --global user.email "${GIT_USER_EMAIL}" && \
    git config --global user.name "${GIT_USER_NAME}"

ENV USE_CCACHE=1
ENV CCACHE_EXEC=/usr/bin/ccache
ENV CCACHE_SIZE=${CCACHE_SIZE}
ENV CCACHE_DIR=/home/${CONTAINER_USER}/ccache

WORKDIR /home/${CONTAINER_USER}/android
RUN sudo chown ${CONTAINER_USER}:${CONTAINER_USER} -R /home/${CONTAINER_USER}/android && \
    sudo chown ${CONTAINER_USER}:${CONTAINER_USER} -R /home/build/bin && \
    if [ -e "/home/${CONTAINER_USER}/android/.repo/repo/repo" ]; then \
        cp /home/${CONTAINER_USER}/android/.repo/repo/repo /home/${CONTAINER_USER}/bin/repo; \
    fi
# RUN repo init -u ${LINEAGEOS_REPO} -b ${LINEAGEOS_BRANCH} && \
#     repo sync



