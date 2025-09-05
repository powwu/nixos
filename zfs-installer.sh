#!/usr/bin/env sh

set -e

[ $(whoami) = "root" ] || { echo "You need to be root."; exit 1; }

DISK="$1"
[ "$DISK" = "" ] && {
    echo -e "Usage: $0 /dev/yourdiskname\n\nAvailable disks:"; lsblk; read -p "Disk to install on (/dev/asdf): " DISK < /dev/tty
}

if [[ $DISK == *"nvme"* ]] || [[ $DISK == *"mmcblk"* ]]; then
    PART_PREFIX="p"
else
    PART_PREFIX=""
fi
DISK="$DISK$PART_PREFIX"

[ ! -e "$DISK" ] && { echo "Disk $DISK does not exist!"; exit 1; }

echo -e "Waiting 60 seconds before beginning install process on $DISK. THIS WILL ERASE ALL DATA. If this is incorrect, Ctrl+C NOW\n\nYour disks:"; lsblk;

i=60
while [ $i -ne 0 ]; do
    echo -ne "\r$i  "

    sleep 1
    i=$((i-1))
done

echo -e "\nIgnore the fdisk prompt when it appears, it will go away on its own."
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
zpool create -O compression=zstd -O mountpoint=none -O xattr=sa -O acltype=posixacl -o ashift=12 zpool "${DISK}1"
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
sed -i 's/Hyprland/zsh/' /mnt/etc/nixos/nixos/configuration.nix
rm /mnt/etc/nixos/nixos/sudo.nix
echo '
{...}: {
    security.sudo = {
        enable = true;
        extraRules = [
            {
                commands = [
                    {
                        command = "/etc/nixos/update-nix.sh";
                        options = ["NOPASSWD"];
                    }
                    {
                        command = "/run/current-system/sw/bin/nixos-rebuild";
                        options = ["NOPASSWD"];
                    }
                    {
                        command = "/run/current-system/sw/bin/nmtui";
                        options = ["NOPASSWD"];
                    }
                ];
                groups = ["wheel"];
            }
        ];
    };
}
' > /mnt/etc/nixos/nixos/sudo.nix

echo "Installing nixos..."
nixos-install --no-root-passwd --flake '/mnt/etc/nixos#powwuinator' || true


echo 'ping -c 1 powwu.sh || sudo /run/current-system/sw/bin/nmtui; nix-shell -p home-manager --run "home-manager switch -b backup --flake /etc/nixos#james@powwuinator"; sudo /etc/nixos/update-nix.sh; sudo nixos-rebuild switch --flake /etc/nixos#powwuinator; zsh -c "nix-shell -p home-manager --run \"home-manager switch -b backup --flake /etc/nixos#james@powwuinator\""; echo "Installation complete. Rebooting in 5s."; echo "Run ~/spotify/bin/spotify and login, then run spicetify backup apply. After this, the spotify command and desktop entry will work as intended" > ~/SPOTIFY-SETUP-README; sleep 5; reboot' > /mnt/home/james/.zshrc
echo "Initialization complete. Rebooting in 120 seconds to continue the install. You'll be asked to connect to wifi if you're not plugged in. Ctrl+C now to reboot on your own terms."
i=120
while [ $i -ne 0 ]; do
    echo -ne "\r$i  "

    sleep 1
    i=$((i-1))
done
reboot
