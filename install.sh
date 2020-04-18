#!/usr/bin/env bash

set -e

ESP="/boot/efi"
MOUNTPOINT="/mnt"

root_device=/dev/nvme0n1
home_device=/dev/sda
ROOT_PARTITION="${root_device}p2"
ESP_PARTITION="${root_device}p1"
HOME_PARTITION="${home_device}1"

#CREATE_PARTITION
create_partition() {
	wipefs -a "${root_device}"
	# Set GPT scheme
	parted "${root_device}" mklabel gpt &>/dev/null
	# Create ESP for /efi
	parted "${root_device}" mkpart primary fat32 1MiB 512MiB &>/dev/null
	parted "${root_device}" set 1 esp on &>/dev/null
	# Create /
	parted "${root_device}" mkpart primary 512MiB 100% &>/dev/null

	wipefs -a "${home_device}"
	# Set GPT scheme
	parted "${home_device}" mklabel gpt &>/dev/null
	# Create /home
	parted "${home_device}" mkpart primary 0% 100% &>/dev/null
}

#FORMAT_PARTITION
format_partition() {
	mkfs.fat -F32 "${ESP_PARTITION}" >/dev/null
	echo "LUKS Setup for '/' partition"
	cryptsetup luksFormat --type luks1 -s 512 -h sha512 -i 3000 "${ROOT_PARTITION}"
	echo "Open '/' partition"
	cryptsetup open "${ROOT_PARTITION}" cryptroot
	mkfs.ext4 /dev/mapper/cryptroot >/dev/null

	echo "LUKS Setup for '/home' partition"
	cryptsetup luksFormat --type luks1 -s 512 -h sha512 -i 3000 "${HOME_PARTITION}"
	echo "Open '/home' partition"
	cryptsetup open "${HOME_PARTITION}" crypthome
	mkfs.ext4 /dev/mapper/crypthome >/dev/null
}

#MOUNT_PARTITION
mount_partition() {
	mount /dev/mapper/cryptroot "${MOUNTPOINT}"
	mkdir -p "${MOUNTPOINT}/home"
	mount /dev/mapper/crypthome "${MOUNTPOINT}/home"
	mkdir -p "${MOUNTPOINT}"${ESP}
	mount "${ESP_PARTITION}" "${MOUNTPOINT}"${ESP}
}

#CREATE_KEYFILE
create_keyfile() {
	dd bs=512 count=4 if=/dev/random of=${MOUNTPOINT}/etc/nixos/secrets/keyfile.bin iflag=fullblock
	echo "Add key to root partition"
	cryptsetup luksAddKey "${ROOT_PARTITION}" ${MOUNTPOINT}/etc/nixos/secrets/keyfile.bin
	echo "Add key to home partition"
	cryptsetup luksAddKey "${HOME_PARTITION}" ${MOUNTPOINT}/etc/nixos/secrets/keyfile.bin
	chmod 600 ${MOUNTPOINT}/etc/nixos/secrets/keyfile.bin
}

# NIXOS_INSTALL
nixos_install() {
	nix-channel --add https://nixos.org/channels/nixos-unstable nixos
	nix-channel --update

	# Install git
	nix-env -iA nixos.gitMinimal
	git clone https://github.com/acml/nixos ${MOUNTPOINT}/etc/nixos/
	# rm -rf ${MOUNTPOINT}/etc/nixos/.git/

	create_keyfile

	# Create new options.nix and open it to let user customize.
	echo "Generate and open build options for configuration..."
	read -n 1 -s -r -p "Press any key to continue"
	cp ${MOUNTPOINT}/etc/nixos/secrets/clash.yaml.example ${MOUNTPOINT}/etc/nixos/secrets/clash.yaml
	nano ${MOUNTPOINT}/etc/nixos/configuration.nix
	nano ${MOUNTPOINT}/etc/nixos/secrets/clash.yaml

	# Install NixOS using TUNA binary cache with fallback
	nixos-generate-config --root /mnt
	nixos-install

	reboot
}

# INSTALLATION
create_partition
format_partition
mount_partition
nixos_install
