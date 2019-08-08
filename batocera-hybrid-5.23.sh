#!/bin/bash
## implements poke-1,0 's patch for hybrid Intel/NVidia
## see poke topic about it @ https://batocera-linux.xorhub.com/forum/d/1851-batocera-linux-5-22-with-nvidia-legacy-drivers-390-xx/9
# tested on batocera 5.22 Acer Aspire vx15 with Nvidia GTX 1050TI gpu OPENGL String: 4.6.0 NVIDIA 418.74/4.6.0 NVIDIA 430.40
# tested on batocera 5.22 Acer NC-VN7-791G-70M4 (Acer V Nitro Series) OPENGL String: 4.6.0 NVIDIA 418.74
echo "Stopping ES..."
/etc/init.d/S31emulationstation stop
echo "Activating Nvidia driver"
batocera-settings /boot/batocera-boot.conf --command uncomment --key nvidia-driver
echo "Writing NVidia Xconf..."
echo "Section \"Module\"
	Load \"modesetting\"
EndSection
Section \"Device\"
	Identifier \"nvidia\"
	Driver \"nvidia\"
	BusID \"1:0:0\"
	Option \"AllowEmptyInitialConfiguration\"
EndSection" > /etc/X11/xorg.conf.d/99-nvidia.conf
echo "Configuring xinit overlay..."
cp /etc/X11/xinit/xinitrc /userdata/system/.xinitrc
sed -i -e "s/## CUSTOMISATIONS ###/## CUSTOMISATIONS ###\n## FORCE NVIDIA - HYBRID PATCH ###\nxrandr --setprovideroutputsource modesetting NVIDIA-0\nxrandr --auto/g" /userdata/system/.xinitrc
echo "Saving FS Overlay..."
batocera-save-overlay
echo "Reboot now" 
reboot
