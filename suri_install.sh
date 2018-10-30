#!/bin/bash
add-apt-repository ppa:oisf/suricata-rust-experimental
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
apt update
apt -y install libpcre3 libpcre3-dev build-essential autoconf automake libtool libpcap-dev libnet1-dev nmap vim libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libmagic-dev libcap-ng-dev libjansson-dev pkg-config libnetfilter-queue-dev geoip-bin geoip-database geoipupdate apt-transport-https python-pip suricata openjdk-8-jdk
apt auto-remove
apt -y install logstash
pip install pyyaml
pip install https://github.com/OISF/suricata-update/archive/master.zip
mkdir /var/lib/suricata
mkdir /var/lib/suricata/rules
$HOME/.local/bin/suricata-update enable-source ptresearch/attackdetection
$HOME/.local/bin/suricata-update enable-source oisf/trafficid
$HOME/.local/bin/suricata-update enable-source sslbl/ssl-fp-blacklist
$HOME/.local/bin/suricata-update
usermod -a -G adm logstash
/bin/systemctl enable logstash.service
/bin/systemctl daemon-reload
/bin/systemctl enable suricata
wget -P /etc/logstash/conf.d/ https://raw.githubusercontent.com/malstor/tools/master/logstash_suricata.conf
systemctl start logstash.service
systemctl start suricata
