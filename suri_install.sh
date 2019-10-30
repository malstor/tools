#!/bin/bash
apt-add-repository universe
apt-add-repository multiverse
apt install python
add-apt-repository ppa:oisf/suricata-stable
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
apt update
apt -y install ifupdown libpcre3 libpcre3-dev build-essential autoconf automake libtool libpcap-dev libnet1-dev nmap vim libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libmagic-dev libcap-ng-dev libjansson-dev pkg-config libnetfilter-queue-dev geoip-bin geoip-database geoipupdate apt-transport-https python-pip suricata openjdk-8-jdk
apt -y auto-remove
apt -y install logstash
#apt -y purge netplan.io
pip install pyyaml
pip install https://github.com/OISF/suricata-update/archive/master.zip
mkdir /var/lib/suricata
mkdir /var/lib/suricata/rules
suricata-update enable-source ptresearch/attackdetection
suricata-update enable-source oisf/trafficid
suricata-update enable-source sslbl/ssl-fp-blacklist
suricata-update
usermod -a -G adm logstash
/bin/systemctl enable logstash.service
/bin/systemctl daemon-reload
/bin/systemctl enable suricata
wget -P /etc/logstash/conf.d/ https://raw.githubusercontent.com/malstor/tools/master/logstash_suricata.conf
wget -P /etc/logstash/templates/ https://raw.githubusercontent.com/malstor/tools/master/suricata_template.json
chown logstash /etc/logstash/templates/suricata_template.json
rm /etc/suricata/suricata.yaml
wget -P /etc/suricata/ https://raw.githubusercontent.com/malstor/tools/master/suricata.yaml
#rm /etc/network/interfaces
#wget -P /etc/network/ https://raw.githubusercontent.com/malstor/tools/master/interfaces
#rm /etc/sysctl.conf
#wget -P /etc/ https://raw.githubusercontent.com/malstor/tools/master/sysctl.conf
#cat /proc/sys/net/ipv6/conf/all/disable_ipv6
systemctl start logstash.service
systemctl start suricata
