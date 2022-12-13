FROM fedora:37

RUN yum -y install which git libmicrohttpd-devel jansson-devel \
      openssl-devel libsrtp-devel sofia-sip-devel glib2-devel \
      opus-devel libogg-devel libcurl-devel pkgconfig \
      libconfig-devel libtool autoconf automake libnice-devel \
      libwebsockets-devel

WORKDIR /opt/install

RUN git clone https://github.com/meetecho/janus-gateway.git

WORKDIR /opt/install/janus-gateway

RUN git checkout v1.1.0

RUN sh autogen.sh && \
      ./configure --prefix=/opt/janus  --disable-rabbitmq --disable-mqtt && \
      make && \
      make install && \
      make configs

WORKDIR /opt/janus
COPY janus.jcfg etc/janus/janus.jcfg

EXPOSE 10000-10010
EXPOSE 8188
EXPOSE 8088

CMD ["/opt/janus/bin/janus"]
