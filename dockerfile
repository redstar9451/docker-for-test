FROM centos:centos7

RUN yum install -y cmake
RUN yum install -y cyrus-sasl-devel
RUN yum install -y ethtool
RUN yum install -y gcc
RUN yum install -y gcc-c++
RUN yum install -y libcurl-devel
RUN yum install -y librdkafka-devel
RUN yum install -y lrzsz quagga vim tcpdump gcc make
RUN yum install -y make
RUN yum install -y nc
RUN yum install -y net-tools
RUN yum install -y netsniff-ng
RUN yum install -y openssh-clients
RUN yum install -y telnet
RUN yum install -y wget
RUN yum install -y wget
RUN yum install -y which

RUN yum install -y python3
RUN pip3 install pipenv

# enable ssh server
RUN yum install openssh-server -y
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN ssh-keygen -A
RUN echo "root:abc123" | chpasswd
RUN /usr/sbin/sshd -D &


# install gobgp
ADD https://github.com/osrg/gobgp/releases/download/v2.20.0/gobgp_2.20.0_linux_amd64.tar.gz /usr/local/bin
RUN cd /usr/local/bin && tar xf gobgp_2.20.0_linux_amd64.tar.gz

# install iperf3
ADD https://src.fedoraproject.org/repo/pkgs/iperf3/3.9.tar.gz/sha512/3da0939bed576a7c14baa03c996e6f407f20bfe58c4b3a36a66e74f41bd5442c0b23ab18c8eb1f2f37fd47449af533b61b658d810c68707b2b06d28894ac2035/3.9.tar.gz /root
RUN cd /root && tar xf 3.9.tar.gz
RUN cd /root/iperf-3.9 && ./configure
RUN cd /root/iperf-3.9 && make install
RUN rm -rf /root/iperf-3.9

# install faketime
ADD https://github.com/wolfcw/libfaketime/archive/refs/tags/v0.9.10.tar.gz /root
RUN cd /root && tar xf v0.9.10.tar.gz && cd /root/libfaketime-0.9.10 && make install

# install kcat
ADD https://github.com/edenhill/kcat/archive/refs/tags/1.7.1.tar.gz /root
RUN cd /root && tar xf 1.7.1.tar.gz && cd /root/kcat-1.7.1 && ./configure && make && make install

ADD ./test_init.sh /usr/local/bin
CMD /usr/local/bin/test_init.sh
