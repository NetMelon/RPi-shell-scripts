#!/bin/bash
echo "STARTING OUT IN USERS DIRECTORY:"
cd

echo "INSTALLING VNC-SERVER"
sudo apt-get install tightvncserver

echo "SET PASSWORD FOR REMOTE ACCESS"
tightvncserver

echo "START VNC_SERVER"
vncserver -geometry 1280x720
echo "TO STOP THE VNC_SERVER"
echo "TYPE THE FOLLOWING: vncserver -kill :1"

echo "RUN AT BOOT - PREPARATION"
cat > vncboot <<- EOM
#!/bin/sh
### BEGIN INIT INFO
# Provides: vncboot
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start VNC Server at boot time
# Description: Start VNC Server at boot time.
### END INIT INFO

case "$1" in
 start)
   echo "Starting VNC Server"
   #Insert your favoured settings for a VNC session
   /usr/bin/vncserver :1 -geometry 1280x720
   ;;

 stop)
   echo "Stopping VNC Server"
   /usr/bin/vncserver -kill :1
   ;;

 *)
   echo "Usage: /etc/init.d/vncboot {start|stop}"
   exit 1
   ;;
esac

exit 0
EOM

echo "MAKING SCRIPT EXECUTABLE FOR ROOT"
sudo mv vncboot /etc/init.d/vncboot
chmod 755 /etc/init.d/vncboot

echo "ENABLE SCRIPT IN BOOT SEQUENCING"
sudo update-rc.d vncboot defaults

#If you ever want to remove the script from start-up, run the following command:
# sudo update-rc.d -f NameOfYourScript remove

#source of script: http://elinux.org/RPi_VNC_Server
#get tightvncclient from http://www.tightvnc.com/download.php
#when installed set IP:0 where IP is a network resource with port 0 as default
