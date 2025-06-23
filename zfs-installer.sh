#!/usr/bin/env sh

set -e

[ $(whoami) = "root" ] || { echo "You need to be root."; exit 1; }

[ "$1" = "" ] && { echo -e "Usage: $0 /dev/yourdiskname\n\nAvailable disks:"; lsblk; exit 1; }

if [[ $1 == *"nvme"* ]] || [[ $1 == *"mmcblk"* ]]; then
    PART_PREFIX="p"
else
    PART_PREFIX=""
fi
DISK="$1${PART_PREFIX}"

[ ! -e "$DISK" ] && { echo "Disk $DISK does not exist!"; exit 1; }

echo -e "Waiting 60 seconds before beginning install process on $1. THIS WILL ERASE ALL DATA. If this is incorrect, Ctrl+C NOW\n\nYour disks:"; lsblk; sleep 60

echo "Wiping $DISK..."
dd if=/dev/zero of=$DISK bs=1M status=progress || true

echo "Partitioning $DISK..."
fdisk "$DISK" << EOF
g
n
1

-10G
t
20
n
2

+8G
t
2
19
n
3

+1G
t
3
1
p
w
EOF

echo "Formatting partitions..."
zpool create -O compression=lz4 -O mountpoint=none -O xattr=sa -O acltype=posixacl -o ashift=12 zpool "${DISK}1"
mkswap -L swap "${DISK}2"
swapon "${DISK}2"
mkfs.fat -F 32 -n boot "${DISK}3"

zfs create -o mountpoint=legacy zpool/root
zfs create -o mountpoint=legacy zpool/nix
zfs create -o mountpoint=legacy zpool/var
zfs create -o mountpoint=legacy zpool/home

echo "Mounting partitions..."
mkdir /mnt/root
mount -t zfs zpool/root /mnt
mkdir /mnt/nix /mnt/var /mnt/home

mount -t zfs zpool/nix /mnt/nix
mount -t zfs zpool/var /mnt/var
mount -t zfs zpool/home /mnt/home

mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot


echo "Cloning nixos config..."
mkdir -p /mnt/etc/nixos
nix-shell -p git --run 'git clone https://github.com/powwu/nixos /mnt/etc/nixos'
rm -rf /mnt/etc/nixos/.git

nixos-generate-config --root /mnt
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/nixos/
rm /mnt/etc/nixos/configuration.nix
sed -i 's/Hyprland/zsh/g' /mnt/etc/nixos/nixos/configuration.nix

echo "Installing nixos..."
nixos-install --flake '/mnt/etc/nixos#powwuinator' || true


echo 'sudo /run/current-system/sw/bin/nmtui; nix-shell -p home-manager --run "home-manager switch -b backup --flake /etc/nixos#james@powwuinator"; cd ~/Wallpapers; 7z x wallpapers.7z.001' > /mnt/home/james/.zshrc
echo "Installation complete. Reboot when you're ready."
