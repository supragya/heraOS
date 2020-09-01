setup_timezone() {
    ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
    hwclock --systohc
}

locale() {
    cat > /etc/locale.gen <<EOF
en_US.UTF-8 UTF-8
en_US ISO-8859-1
EOF

    cat > /etc/locale.conf <<EOF
LANG=en_US.UTF-8
EOF

    locale-gen
}

network_config() {
    echo "heraos" >> /etc/hostname
    echo "127.0.1.1 heraos.localdomain  heraos" >> /etc/hosts
}

mkinitcpio() {
    mkinitcpio -P
}

setup_root_password() {
    passwd
}

grub_setup() {
    grub-install --target=i386-pc /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
}

setup_user() {
    useradd -m -G wheel,power,input,storage,uucp,network -s /usr/bin/zsh supragya
    passwd supragya
}

#
# Driver Code
#

echo "HeraOS chroot setup"

echo "---- Stage 1: Getting System ready"
read breakpoint
setup_timezone
locale
network_config
mkinitcpio
setup_root_password

echo "---- Stage 2: Setting up bootloader"
read breakpoint
grub_setup
setup_user

echo "All done. Now exit and reboot. Post which, login with root as user and the root password"