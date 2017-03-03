# Getting Base Image
FROM ubuntu:latest

# Author Info
MAINTAINER tetuya

# build
RUN apt-get update
RUN apt-get install -y vim
RUN apt-get install -y curl
RUN touch /etc/apt/sources.list.d/nginx.list
RUN echo "deb http://nginx.org/packages/ubuntu/ precise nginx" >> /etc/apt/sources.list.d/nginx.list
RUN echo "deb-src http://nginx.org/packages/ubuntu/ precise nginx" >> /etc/apt/sources.list.d/nginx.list
RUN curl http://nginx.org/keys/nginx_signing.key | apt-key add -
RUN apt-get update
RUN apt-get install -y nginx
RUN sed -i -e "1i daemon off;" /etc/nginx/nginx.conf
RUN sed -i -e 's/80/8080/' /etc/nginx/conf.d/default.conf

# Support Arbitrary User IDs
RUN chgrp -R 0 /var/log/nginx
RUN chmod -R g+rw /var/log/nginx
RUN find /var/log/nginx -type d -exec chmod g+x {} +
RUN chgrp -R 0 /var/cache/nginx
RUN chmod -R go+rw /var/cache/nginx
RUN find /var/cache/nginx -type d -exec chmod g+x {} +
RUN chgrp -R 0 /run
RUN chmod -R go+rw /run

# change index.html
RUN mv /var/www/html/index.html /var/www/html/index.html.save
RUM echo "openshift-test" >> /var/www/html/index.html

USER nginx

# Port
EXPOSE 22 8080

# start command
CMD ["/usr/sbin/nginx","-c","/etc/nginx/nginx.conf"]
