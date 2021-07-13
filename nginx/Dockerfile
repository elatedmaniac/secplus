FROM nginx
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get -y install sudo && apt-get install software-properties-common php -y
COPY index.html /usr/share/nginx/html/index.html
