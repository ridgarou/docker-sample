# FROM ayufan/rock64-dockerfiles:arm32
# FROM arm64v8/debian:stretch
FROM arm64v8/alpine:latest

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CALIBRE_RELEASE
LABEL build_version="Ridgarou version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="ridgarou"

SHELL ["/bin/bash", "-c"]

# RUN echo "**** Update image ****"
RUN apt-get update -y 
RUN apt-get upgrade -y 
RUN apt-get dist-upgrade -y
    
RUN echo "**** Install runtime packages ****"
RUN apt-get install -y xvfb ImageMagick rsyslog
    
RUN echo "**** Install calibre from debian repositories ****"
RUN apt-get install -y calibre

RUN echo "**** Clean innecesary packages ****"
RUN apt-get clean
    
EXPOSE 8080

# Create directory for library
RUN mkdir -p /opt/calibre/library
VOLUME ["/opt/calibre/library“]

# Create directory to import files
RUN mkdir -p /opt/calibre/import
VOLUME ["/opt/calibre/import“]

# Add crontab job to import books in the library
ADD crontab /etc/cron.d/calibre-update
RUN chmod 0644 /etc/cron.d/calibre-update

RUN touch /var/log/cron.log

# Run cron job and start calibre server
#CMD cron && /usr/bin/calibre-server --with-library=/opt/calibre/library

CMD ["/bin/echo" , "Hi Docker !!!!"]
