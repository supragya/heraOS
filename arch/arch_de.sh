get_mate() {
    sudo pacman -S mate mate-session-manager dolphin atril engrampa rofi mate-media blueman network-manager-applet mate-power-manager mate-tweak
}

#
# Driver Code
#

echo "HeraOS Desktop Environment setup"

echo "---- Stage 1: Getting Mate"
read breakpoint
get_mate