#!/bin/bash

echo "Install neccessary framework"
sudo apt install openjdk-11-jre-headless
cd /opt
wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
tar -xvzf apache-tomcat-9.0.65.tar.gz
tar -xvzf apache-maven-3.8.6-bin.tar.gz
mv apache-maven-3.8.6 maven
mv apache-tomcat-9.0.65 tomcat
cd ~/

echo "Set up environment variables"
echo "JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))" >> ~/.profile
echo "M2_HOME=/opt/maven" >> ~/.profile
echo "M2=/opt/maven/bin" >> ~/.profile
echo 'export PATH="${HOME}/bin:${JAVA_HOME}:${M2}:${M2_HOME}:/bin:/usr/bin:/usr/local/bin"' >> ~/.profile

echo "Make tomcat accessible from outside"
grep -v "RemoteAddrValve\|allow" /opt/tomcat/webapps/host-manager/META-INF/context.xml > filename2; mv filename2 /opt/tomcat/webapps/host-manager/META-INF/context.xml
grep -v "RemoteAddrValve\|allow" /opt/tomcat/webapps/manager/META-INF/context.xml > filename2; mv filename2 /opt/tomcat/webapps/manager/META-INF/context.xml

echo "Set up the default setting for user and password"
echo '  <role rolename="admin-gui"/>
        <role rolename="manager-gui"/>
        <role rolename="manager-script"/>
        <role rolename="manager-jmx"/>
        <role rolename="manager-status"/>
        <user username="s3836322" password="s3836322" roles="admin-gui,manager-gui, manager-script,
        manager-jmx, manager-status"/>' >> /opt/tomcat/conf/tomcat-users.xml
grep -v "</tomcat-users>" /opt/tomcat/conf/tomcat-users.xml > filename2; mv filename2 /opt/tomcat/conf/tomcat-users.xml
echo "</tomcat-users>" >> /opt/tomcat/conf/tomcat-users.xml

ln -s /opt/tomcat/bin/startup.sh /usr/local/bin/tomcatup
ln -s /opt/tomcat/bin/shutdown.sh /usr/local/bin/tomcatdown
source ~/.profile

# echo "Package the project"
# cp /usr/src/app/target/assignment-2.war /usr/local/tomcat/webapps/

echo "Start the server"
tomcatup
echo "If you want to stop the server, tomcatdown"