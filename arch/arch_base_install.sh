

# Checking whether installation is done in EFI mode
check_efi_or_bios() {
    EFI_FILE=/sys/firmware/efi/efivars
    if [ -f "$EFI_FILE" ]; then
        echo "EFI File exists: UEFI mode detected"
    else
        echo "EFI File not found: BIOS mode perhaps?"
    fi
}

check_ipv4_connectivity() {
    if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
        echo "IPv4 is up: machine is connected to the internet"
        ip route get 8.8.8.8 | head -1 | cut -d' ' -f8
    else
        echo "IPv4 is down: machine is not connected to the internet"
    fi
}

fdisk_partitioning() {
    sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
        o # clear the in memory partition table
        n # new partition
        p # primary partition
        1 # partition number 1
            # default - start at beginning of disk 
        +512M # 512 MB boot parttion
        n # new partition
        p # primary partition
        2 # partion number 2
            # default, start immediately after preceding partition
        +8G # 8 GB swap parttion
        n # new partition
        p # primary partition
        3 # partion number 3
            # default, start immediately after preceding partition
            # default, extend partition to end of disk
        a # make a partition bootable
        1 # bootable partition is partition 1 -- /dev/sda1
        p # print the in-memory partition table
        w # write the partition table
        q # and we're done
EOF

    mkfs.ext4 /dev/sda3
    mkfs.fat /dev/sda1
}

efifs_dev_sda1() {
    mount /dev/sda1 /mnt/efi
}

swapfs_dev_sda2() {
    mkswap /dev/sda2
    swapon /dev/sda2
}

rootmount_dev_sda3() {
    mount /dev/sda3 /mnt
}

timedatectl_setntp() {
    echo "Setting up timedatectl"
    timedatectl set-ntp true
}

pacstrap_basic() {
    pacstrap /mnt base linux linux-firmware vim grub os-prober intel-ucode efibootmgr iw wpa_supplicant
}

genfstab() {
    genfstab -U /mnt >> /mnt/etc/fstab
}

#
# Driver Code
#

echo "HeraOS base installation"

echo "---- Stage 1: Cheking system status"
read breakpoint
check_efi_or_bios
check_ipv4_connectivity
echo ""

echo "---- Stage 2: Partitioning system disk /dev/sda and mounting"
read breakpoint
fdisk_partitioning
efifs_dev_sda1
swapfs_dev_sda2
rootmount_dev_sda3
echo ""

echo "---- Stage 3: Setting up and installing"
read breakpoint
timedatectl_setntp
pacstrap_basic
genfstab
echo ""

echo "Note: Now chroot into the installation using arch-chroot /mnt and run sh arch_chroot_setup.sh"