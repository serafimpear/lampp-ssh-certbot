# use ubuntu 20.04 as base image
FROM ubuntu:20.04

# set user and directory
USER root
WORKDIR /tmp

# EDIT USERNAME AND PASSWORD
ARG username=user
ARG userpaswd=1234

# install main tools
RUN apt-get -y update && \
	apt-get -y install nano\
		net-tools \
		openssh-server \
		sudo \
		wget \
		ufw \
		supervisor \
		sed \
		python3-certbot-apache

# open port 22 for docker
EXPOSE 22
RUN ufw allow ssh

# add user
RUN useradd -rm -u 1001 -G sudo -s /bin/bash $username
RUN echo "$username:$userpaswd" | chpasswd

#Set up SSH access
RUN mkdir /var/run/sshd
RUN sed -i.bak s/PermitRootLogin\ prohibit-password/PermitRootLogin\ yes/g  /etc/ssh/sshd_config

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

##############################################

# download lampp installer from apachefriends.org and install
RUN wget https://www.apachefriends.org/xampp-files/7.4.16/xampp-linux-x64-7.4.16-0-installer.run
RUN chmod +x xampp-linux-x64-7.4.16-0-installer.run
RUN ./xampp-linux-x64-7.4.16-0-installer.run

# config
RUN sed -i 's/\#Include etc\/extra\/httpd-vhosts\.conf/Include etc\/extra\/httpd-vhosts\.conf/g' /opt/lampp/etc/httpd.conf
RUN sed -i 's/User daemon/User $username/g' /opt/lampp/etc/httpd.conf
RUN sed -i 's/Group daemon/Group $username/g' /opt/lampp/etc/httpd.conf
COPY httpd-vhosts.conf /opt/lampp/etc/extra/httpd-vhosts.conf

# open ports 80 and 443 for http and https, 3306 for mysql
EXPOSE 80
EXPOSE 443
EXPOSE 3306
RUN ufw allow 'Apache Full'

# start webserver and ssh

# CMD ["/usr/bin/supervisord"]
CMD /opt/lampp/lampp start && service ssh start
