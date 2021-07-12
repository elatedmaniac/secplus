FROM nginx
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get -y install sudo && apt-get install software-properties-common -y
COPY nginx.conf /etc/nginx/nginx.conf

