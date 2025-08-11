#!/bin/bash
set -e

# Update system
apt-get update
apt-get install -y openjdk-11-jdk

# Install Tomcat 9
cd /tmp
wget -q https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz
tar -xzf apache-tomcat-9.0.80.tar.gz -C /opt/
mv /opt/apache-tomcat-9.0.80 /opt/tomcat

# Create tomcat user
useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
chown -R tomcat:tomcat /opt/tomcat
chmod +x /opt/tomcat/bin/*.sh

# Create simple HTML page
mkdir -p /opt/tomcat/webapps/ROOT
cat > /opt/tomcat/webapps/ROOT/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head><title>Tomcat WAS Server</title></head>
<body>
    <h1>Tomcat WAS Server is Running!</h1>
    <p>Hostname: $(hostname)</p>
    <p>Timestamp: $(date)</p>
</body>
</html>
HTML

# Create systemd service
cat > /etc/systemd/system/tomcat.service << 'SERVICE'
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICE

# Start Tomcat service
systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat

echo "App server setup completed" > /tmp/app-setup.log