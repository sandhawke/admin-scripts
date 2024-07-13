#!/bin/bash
##sudo chown sandro.sandro /tmp/scripts.log /tmp/printenv
##echo "USB device removed  at $(date)" >>/tmp/scripts.log
##printenv >>/tmp/printenv
notify-send "Camera available"
# BORKEN! No longer exists.
# v4l2ctrl -d /dev/video1 -l /home/sandro/camera-settings-140.txt
v4l2-ctl -d 2 --set-ctrl=zoom_absolute=140 --set-ctrl=saturation=70
v4l2-ctl -d 3 --set-ctrl=zoom_absolute=140 --set-ctrl=saturation=70
