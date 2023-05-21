#!/bin/bash
TOMURL="https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz"
sudo yum install wget awscli -y
sudo yum install java-11-openjdk -y
cd /tmp/
sudo wget $TOMURL -O tomcatbin.tar.gz
mkdir /usr/local/tomcat8
sudo tar xzvf tomcatbin.tar.gz --strip-components=1 -C /usr/local/tomcat8
sudo useradd --shell /sbin/nologin tomcat
sudo chown -R tomcat.tomcat /usr/local/tomcat8
sudo chmod -R +rwx /usr/local/tomcat8
sudo rm -rf /etc/systemd/system/tomcat.service

cat <<EOT>> /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target
[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat8
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat8
Environment=CATALINE_BASE=/usr/local/tomcat8
ExecStart=/usr/local/tomcat8/bin/catalina.sh run
ExecStop=/usr/local/tomcat8/bin/shutdown.sh
SyslogIdentifier=tomcat-%i
[Install]
WantedBy=multi-user.target
EOT

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat
sudo systemctl restart tomcat



#systemctl stop tomcat
#cp target/vprofile-v2.war /usr/local/tomcat8/webapps/ROOT.war
#cp target/classes/application.properties /usr/local/tomcat8/webapps/ROOT/WEB-INF/classes/application.properties
#systemctl start tomcat
