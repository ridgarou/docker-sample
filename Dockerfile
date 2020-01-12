FROM ayufan/rock64-dockerfiles:arm64
# FROM ayufan/rock64-dockerfiles:arm32
# FROM arm64v8/debian:stretch
# FROM arm64v8/debian:stable-slim
# FROM arm64v8/alpine:latest

# set version label
# ARG BUILD_DATE
# ARG VERSION
# ARG CALIBRE_RELEASE
# LABEL build_version="Ridgarou version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="ridgarou"
MAINTAINER ridgarou@gmail.com

# SHELL ["/bin/bash", "-c"]

# ADD ./files/install_tzdata.sh /install_tzdata.sh
# RUN chmod +x /install_tzdata.sh

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo "**** Update image ****" && \
apt-get update -y && \
echo "**** Install runtime packages ****" && \
apt-get -y install --no-install-recommends -y xvfb imagemagick rsyslog cron && \
echo "**** Install calibre from debian repositories ****" && \
apt-get -y install --no-install-recommends calibre && \
echo "**** Clean innecesary packages ****" && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*
    
EXPOSE 8080

# Create directory for library and directory to import files
RUN mkdir -p /opt/calibre/library && \
    mkdir -p /opt/calibre/import && \
    mkdir -p /etc/cron.d
    
VOLUME ["/opt/calibre/library"]
VOLUME ["/opt/calibre/import"]

# Add crontab job to import books in the library
ADD ./files/crontab /etc/cron.d/calibre-update
RUN chmod 0644 /etc/cron.d/calibre-update

RUN touch /var/log/cron.log

# Run cron job and start calibre server
#CMD cron && /usr/bin/calibre-server --with-library=/opt/calibre/library

CMD ["/bin/echo" , "Hi Docker !!!!"]
