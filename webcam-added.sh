#!/bin/bash
echo "USB device removed  at $(date)" >>/tmp/scripts.log
printenv >>/tmp/printenv
notify-send "Camera available"
v4l2ctrl -d /dev/video1 -l /home/sandro/camera-settings-140.txt
