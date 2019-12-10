FROM ubuntu:18.04
 
LABEL maintainer="Steven Cheon <onek0708@gmail.com>"
 
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update -y \
  && apt-get install -y nginx \
                        openssh-server \
                        supervisor \
                        git \
			curl \
                        openjdk-11-jdk

RUN rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/onek0708/jpetstore-6.git
RUN cd jpetstore-6 && ./mvnw clean package 

ARG ssh_prv_key
ARG ssh_pub_key

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

RUN chown -R www-data:www-data /var/www/html
ADD supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 22 80 8080 443

# Volume configuration
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

#CMD ["/usr/bin/supervisord"]
 

# Tomcat
RUN  groupadd tomcat
RUN  useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
RUN cd /tmp \
     && curl -O http://mirror.cc.columbia.edu/pub/software/apache/tomcat/tomcat-9/v9.0.10/bin/apache-tomcat-9.0.10.tar.gz \
     &&  mkdir /opt/tomcat &&  tar xzvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1 \
     && cd /opt/tomcat \
     &&  chgrp -R tomcat /opt/tomcat \
 &&  chmod -R g+r conf \
 &&  chmod g+x conf \
 &&  chown -R tomcat webapps/ work/ temp/ logs/    \ 
 &&  update-java-alternatives -l \
 &&  ufw allow 8080
