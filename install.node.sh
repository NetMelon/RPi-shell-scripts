#!/bin/bash

#Warning, only for Raspberry Pi 2 Model B!!!!!! (else, change the node version that is downloaded to your processor architecture)
#source of /etc/init.d/-BOOTUP-script: http://elinux.org/RPi_VNC_Server
#source of node installation script: http://blog.wia.io/installing-node-js-v4-0-0-on-a-raspberry-pi/
#source of server piping error: http://stackoverflow.com/questions/12701259/how-to-make-a-node-js-application-run-permanently
#source of first project: https://github.com/Hironate/PeerChat

echo STARTING OUT IN USERS DIRECTORY:
cd

echo DOWNLOADING AND UNZIPPING NODE
wget https://nodejs.org/dist/v4.2.3/node-v4.2.3-linux-armv7l.tar.gz
tar -xvf node-v4.2.3-linux-armv7l.tar.gz
rm node-v4.2.3-linux-armv7l.tar.gz
mv node-v4.2.3-linux-armv7l node

echo SETTING AN ENVIRONMENTAL VARIABLE TO LET RASPBERRY KNOW WHERE TO FIND NODE
PATH=$PATH:/home/pi/node/bin
#when loged in as pi, run:
#echo "export PATH=$PATH:/home/pi/node/bin" >> ~/.bashrc
#this will set the environmental variable for node permanantly


echo DOWNLOADING AND UNZIPPING FIRST PROJECT
wget https://github.com/Hironate/PeerChat/archive/master.zip
unzip master.zip
rm master.zip

echo RELOCATING FIRST PROJECT INSIDE NODE PROJECTS
mv PeerChat-master peerchat
cd node
mkdir projects
cd
mv peerchat node/projects/

echo "RUN AT BOOT PREPARATION"
cat > nodeboot <<- EOM
#!/bin/sh
### BEGIN INIT INFO
# Provides: nodeboot
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start node Server at boot time
# Description: Start node Server at boot time.
### END INIT INFO

case "$1" in
 start)
   echo "Starting node Server"
   PATH=/home/pi/node/bin
   cd /home/pi/node/projects/peerchat/
   node server.js > stdout.txt 2> stderr.txt &
   ;;

 stop)
   echo "Stopping node Server"
   killall node
   ;;

 *)
   echo "Usage: /etc/init.d/nodeboot {start|stop}"
   exit 1
   ;;
esac

exit 0
EOM

echo "PUSH FILE TO /etc/init.d/"
sudo mv nodeboot /etc/init.d/nodeboot
chmod +x /etc/init.d/nodeboot

echo "ENABLE DEPENDENCY BASED BOOT SEQUENCING"
sudo update-rc.d nodeboot defaults

echo CURRENT VERSION
node -v

echo INSTALL IMPORTANT GLOBAL PACKAGES
npm install -g node-gyp
npm install -g express
npm install -g socket.io

echo INSTALL IMPORTANT LOCAL FIRST PROJECT PACKAGES
cd /home/pi/node/projects/peerchat
npm install
