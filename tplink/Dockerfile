FROM centos:centos7.9.2009

RUN yum -y update

WORKDIR /tmp/install
# Install required stuff
RUN yum -y install unzip
RUN yum -y install python3
RUN yum -y install git
RUN git clone https://github.com/ReFirmLabs/binwalk.git
RUN cd binwalk && python3 setup.py install
RUN yum -y install vim
RUN yum -y install man

# Creating user
RUN useradd -rm -d /home/tplink -s /bin/bash -g root -G root -u 1001 tplink
USER tplink
WORKDIR /home/tplink

# Download firmware
RUN curl https://static.tp-link.com/upload/firmware/2023/202304/20230403/Archer%20C6\(EU\)_V4.0_230208.zip --output firmware.zip
RUN unzip firmware.zip
RUN rm -f firmware.zip
RUN rm -f *pdf

# Extract binary
# Read more on https://github.com/hacefresko/TP-Link-Archer-C6-EU-re
# RUN dd if=c6v4-up-noboot_2023-02-08_10.47.55.bin of=raw.lzma bs=1 skip=212
# RUN dd if=raw.lzma of=chunk2.bin bs=1 skip=1404736 count=1525829
5651349-5689208