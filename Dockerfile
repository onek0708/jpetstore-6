FROM ubuntu:16.04
 
LABEL maintainer="Steven Cheon <onek0708@gmail.com>"
 
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update -y \
  && apt-get install -y nginx \
                        openssh-server \
                        git \
			curl \
			language-pack-ko \
                        openjdk-11-jdk

# set locale ko_KR
RUN locale-gen ko_KR.UTF-8
 
ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

RUN rm -rf /var/lib/apt/lists/*

# SSH
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# Nginx.
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]
WORKDIR /etc/nginx
#CMD ["nginx"]

EXPOSE 80
EXPOSE 443

# Tomcat
RUN  groupadd tomcat
RUN  useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
RUN cd /tmp \
     && curl -O http://mirror.navercorp.com/apache/tomcat/tomcat-9/v9.0.29/bin/apache-tomcat-9.0.29.tar.gz \
     && mkdir /opt/tomcat &&  tar xzvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1 \
     && cd /opt/tomcat \
     && chgrp -R tomcat /opt/tomcat \
     && chmod -R g+r conf \
     && chmod g+x conf \
     && chown -R tomcat webapps/ work/ temp/ logs/    
#RUN update-java-alternatives -l 
RUN cd /etc/systemd/system/ && wget https://raw.githubusercontent.com/onek0708/jpetstore-6/master/tomcat.service
#CMD ["/etc/systemd/system/systemctl start tomcat"]
#CMD ["/etc/systemd/system/systemctl enable tomcat"]
#RUN ufw allow 8080
EXPOSE 8080

