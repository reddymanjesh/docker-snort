FROM ubuntu:16.04

ENV DAQ_VERSION 2.0.7
ENV SNORT_VERSION 2.9.17
ENV NETWORK_INTERFACE enp0s3

RUN apt-get update
RUN apt install -y apt-utils \
          gcc \
          libpcre3-dev \
          zlib1g-dev \
          libluajit-5.1-dev \
          libpcap-dev \
          openssl \
          libssl-dev \
          libnghttp2-dev \
          libdumbnet-dev \
          bison \
          flex \
          libdnet \
          autoconf \
          libtool \
          wget \
          nano \
          curl \
          unzip

# Define working directory.
WORKDIR /opt

RUN wget https://www.snort.org/downloads/snort/daq-${DAQ_VERSION}.tar.gz \
    && tar xvfz daq-${DAQ_VERSION}.tar.gz \
    && cd daq-${DAQ_VERSION} \
    && autoreconf -f -i \
    && ./configure \
    && make \
    && make install

RUN wget https://www.snort.org/downloads/snort/snort-${SNORT_VERSION}.tar.gz \
    && tar xvfz snort-${SNORT_VERSION}.tar.gz \
    && cd snort-${SNORT_VERSION} \
    && ./configure --enable-sourcefire \
    && make \
    && make install

RUN ldconfig

ADD mysnortrules /opt
RUN mkdir -p /var/log/snort && \
    mkdir -p /usr/local/lib/snort_dynamicrules && \
    mkdir -p /etc/snort && \
    cp -r /opt/rules /etc/snort/rules && \
    mkdir -p /etc/snort/preproc_rules && \
    mkdir -p /etc/snort/so_rules && \
    cp -r /opt/etc /etc/snort/etc && \
    touch /etc/snort/rules/white_list.rules /etc/snort/rules/black_list.rules

# Clean up APT when done.

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    /opt/snort-${SNORT_VERSION}.tar.gz /opt/daq-${DAQ_VERSION}.tar.gz
CMD ["snort", "-T", "-i", "echo ${NETWORK_INTERFACE}", "-c", "/etc/snort/etc/snort.conf"]
