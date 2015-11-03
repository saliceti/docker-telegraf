FROM ubuntu
RUN apt-get update && \
    apt-get install -y wget proot && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget http://get.influxdb.org/telegraf/telegraf_0.1.4_amd64.deb
RUN dpkg -i telegraf_0.1.4_amd64.deb
RUN mkdir -p /var/run/telegraf
RUN wget https://raw.githubusercontent.com/alphagov/ansible-playbook-telegraf/improve_config_template/templates/telegraf.conf.j2 -O /etc/opt/telegraf/telegraf.conf
#RUN wget https://raw.githubusercontent.com/alphagov/ansible-playbook-telegraf/master/templates/telegraf.conf.j2 -O /etc/opt/telegraf/telegraf.conf

# to delete
ADD user-data.yml user-data.yml
ADD run.sh run.sh


CMD ./run.sh
