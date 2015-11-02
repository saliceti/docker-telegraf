FROM ubuntu
RUN apt-get install -y wget
RUN wget http://get.influxdb.org/telegraf/telegraf_0.1.4_amd64.deb
RUN dpkg -i telegraf_0.1.4_amd64.deb
RUN mkdir -p /var/run/telegraf
RUN wget https://raw.githubusercontent.com/alphagov/ansible-playbook-telegraf/improve_config_template/templates/telegraf.conf.j2 -O /etc/opt/telegraf/telegraf.conf
#RUN wget https://raw.githubusercontent.com/alphagov/ansible-playbook-telegraf/master/templates/telegraf.conf.j2 -O /etc/opt/telegraf/telegraf.conf

# to delete
ADD user-data.yml user-data.yml
ADD run.sh run.sh

RUN mkdir /host
RUN cd /host && for dir in bin etc run lib lib64 opt usr var; do mkdir $dir; done

CMD ./run.sh
