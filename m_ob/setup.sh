echo "Removing conky2 from system"
sudo pkill conky2


echo "Setting up XRandR - screen resolutions"

xrandr --newmode "heraOS_1920x1080_60.00"  172.80  1920 2040 2248 2576  1080 1081 1084 1118  -HSync +Vsync
xrandr --addmode Virtual1 "1920x1080_60.00"
xrandr --output Virtual1 --mode "1920x1080_60.00" 

echo "Setting up wallpaper"


echo "Setting up Orchis Theme"

sudo pacman -S gtk-engine-murrine
cd /tmp
git clone https://github.com/vinceliuice/Orchis-theme.git
cd Orchis-theme
./install.sh