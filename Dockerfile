FROM ubuntu
RUN apt-get update && \
    apt-get install -y wget proot && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget http://get.influxdb.org/telegraf/telegraf_0.2.0_amd64.deb
RUN dpkg -i telegraf_0.2.0_amd64.deb
RUN mkdir -p /var/run/telegraf

ADD run.sh run.sh
ADD telegraf.conf.sh telegraf.conf.sh

CMD ./run.sh
