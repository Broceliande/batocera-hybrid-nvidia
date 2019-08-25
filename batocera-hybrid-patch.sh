#!/bin/bash
## implements poke-1,0 's patch for hybrid Intel/NVidia
## see poke topic about it @ https://batocera-linux.xorhub.com/forum/d/1851-batocera-linux-5-22-with-nvidia-legacy-drivers-390-xx/9
# tested on batocera 5.23 Acer Aspire vx15 with Nvidia GTX 1050TI gpu OPENGL String: 4.6.0 NVIDIA 430.40
echo "Stopping ES..."
/etc/init.d/S31emulationstation stop
mount -o remount,rw /boot
echo "Activating Nvidia driver"
batocera-settings /boot/batocera-boot.conf --command uncomment --key nvidia-driver
echo "Writing NVidia Xconf..."
cat > /etc/X11/xorg.conf.d/99-nvidia.conf <<_EOF_
Section "Module"
    Load "modesetting"
EndSection

Section "Device"
    Identifier "nvidia"
    Driver "nvidia"
    BusID "1:0:0"
    Option "AllowEmptyInitialConfiguration"
EndSection
_EOF_
echo "Configuring xinit overlay..."
cp /etc/X11/xinit/xinitrc /userdata/system/.xinitrc
sed -i -e "s/## CUSTOMISATIONS ###/## CUSTOMISATIONS ###\n## FORCE NVIDIA - HYBRID PATCH ###\nxrandr --setprovideroutputsource modesetting NVIDIA-0\nxrandr --auto/g" /userdata/system/.xinitrc
echo "Saving FS Overlay..."
batocera-save-overlay
mount -o remount,r /boot
echo "Reboot now" 
reboot
