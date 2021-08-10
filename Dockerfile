FROM debian:stable-slim

# Add polaric-server apt repo
RUN apt-get update && apt-get -y install gnupg2 dirmngr
COPY la7eca.gpg /usr/share/keyrings/
RUN echo 'deb [signed-by=/usr/share/keyrings/la7eca.gpg] http://aprs.no/debian-rep binary-dev/' >> /etc/apt/sources.list && apt-get update

# Install Java (with hack for slim image)
RUN mkdir -p /usr/share/man/man1
RUN apt-get -y install default-jdk-headless

# Install polaric components
RUN apt-get -y install polaric-aprsd polaric-webapp2 polaric-ais-plugin

# Work-around for hard-coded file logging
RUN sed -e 's/>> $LOGFILE 2>&1//g' -i /usr/bin/polaric-aprsd-start

# Enable required apache modules
RUN a2enmod proxy proxy_http proxy_wstunnel rewrite
