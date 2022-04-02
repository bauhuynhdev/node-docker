#Get from docker hub
FROM centos:7

ENV WORKSPACE=/app

USER root

SHELL ["/bin/bash", "-c"]

#Run base common
RUN yum update -y && \
    yum install -y \
    epel-release \
    yum-utils \
    python2 \
    python3 \
    zip \
    gcc-c++ \
    make \
    unzip \
    nano \
    openssl

#Install nginx 1.20.2
RUN echo $'\n\
[nginx-stable] \n\
name=nginx stable repo \n\
baseurl=https://nginx.org/packages/centos/$releasever/$basearch/ \n\
gpgcheck=1 \n\
enabled=1 \n\
gpgkey=https://nginx.org/keys/nginx_signing.key \n\
module_hotfixes=true' > /etc/yum.repos.d/nginx.repo
RUN yum install -y nginx-1.20.2

#Install nodejs 14.x and yarn
RUN curl -fsSL https://rpm.nodesource.com/setup_14.x | bash - && \
    yum install -y nodejs && \
    npm install -g yarn

#Install supervisor 4.2.4
RUN pip3 install supervisor==4.2.4
RUN mkdir /var/run/supervisor && \
    mkdir /var/log/supervisor && \
    mkdir /etc/supervisord.d

#Install new config
ADD config/supervisord.conf /etc/supervisord.conf
ADD config/supervisord/ /etc/supervisord.d/

ADD config/nginx.conf /etc/nginx/nginx.conf
ADD config/default.conf /etc/nginx/conf.d/default.conf

RUN mkdir $WORKSPACE

ADD src $WORKSPACE

WORKDIR $WORKSPACE

EXPOSE 80 443

CMD ["supervisord"]