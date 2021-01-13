# heraOS
Personalised rice of Arch Linux

## Take a backup using rsync
```
sudo rsync -avzh --progress --stats / --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} --ignore-errors /mnt/worklinux-backup/
```

## Install arch linux using archfi
