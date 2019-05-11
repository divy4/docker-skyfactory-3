# syntax=docker/dockerfile:1.0
# escape=\

# divy/docker-skyfactory-3
# Based off of jaysonsantos/docker-minecraft-ftb-skyfactory3 and audiohacked/docker-ftb_skyfactory3

FROM openjdk:8u191-jre-alpine3.9

ENV BIN_DIR="/usr/local/bin/" \
    DATA_DIR="/data/" \ 
    WORK_DIR="/minecraft/"

ENV GROUP="minecraft" \
    GROUP_ID=1234 \
    USER="minecraft" \
    USER_ID=1234

ENV SKYFACTORY_VERSION="3.0.15" \
    SKYFACTORY_PACKAGE_PROJECT="ftb-presents-skyfactory-3" \
    SKYFACTORY_PACKAGE_REPO="www.feed-the-beast.com" \
    SKYFACTORY_PACKAGE_VERSION="2481284"

# Create user
RUN addgroup --gid ${GROUP_ID} ${GROUP}
RUN adduser -u ${USER_ID} -G ${GROUP} -h ${WORK_DIR} -D ${USER}

# Add build tools
ADD build_tools/* ${BIN_DIR}
RUN apk --no-cache --virtual build-dependencies add wget

# Download and install packages
RUN su ${USER} -c 'install_package ${SKYFACTORY_PACKAGE_REPO} ${SKYFACTORY_PACKAGE_PROJECT} ${SKYFACTORY_PACKAGE_VERSION} ${WORK_DIR}'
RUN su ${USER} -c 'cd ${WORK_DIR} && ./FTBInstall.sh'

# cleanup
RUN apk del build-dependencies
RUN rm ${BIN_DIR}/* ${WORK_DIR}/FTBInstall.sh

# Descalate to user
USER ${USER}

# Add runtime tools
ADD runtime_tools/* ${BIN_DIR}

# Data that should be saved
VOLUME ${DATA_DIR}

# Entrypoint
WORKDIR ${WORK_DIR}
ENTRYPOINT start

# Extra environment variables
ENV EULA="false" \
    JVM_ARGS="-Xms3g -Xmx3g" \
    PRY="false"

