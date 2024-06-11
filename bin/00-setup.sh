#/usr/bin/bash

set -euo pipefail

# base setup:
rpm-ostree override remove \
		firefox \
		firefox-langpacks \
		gnome-tour \
		yelp \
		gnome-shell-extension-background-logo \
			--install borgbackup \
			--install borgmatic \
			--install rclone \
			--install zstd \
            --install firewall-config \
			--install tailscale \
            --install wireguard-tools \
			--install code \
			--install distrobox \
			--install podman-compose \
			--install podmansh \
			--install edk2-ovmf \
			--install incus \
			--install libvirt \
			--install libvirt-dbus \
			--install qemu \
			--install qemu-kvm \
			--install swtpm-tools \
			--install virt-install \
			--install virt-manager \
			--install virt-viewer \
			--install htop \
			--install lm_sensors \
			--install ncdu \
			--install powertop \
			--install smartmontools \
			--install setroubleshoot-server \
			--install adw-gtk3-theme \
			--install intel-one-mono-fonts \
			--install jetbrains-mono-fonts-all \
			--install gnome-shell-extension-appindicator \
			--install gnome-shell-extension-caffeine \
			--install gnome-shell-extension-dash-to-dock \
			--install gnome-tweaks

# remove unnecessary repos after installation:
rm -rf /etc/yum.repos.d/{tailscale,vscode,ganto-lx4c,google-chrome}.repo

# enable automatic updates.
sed -i 's/^#AutomaticUpdatePolicy=none$/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf

systemctl enable firewalld.service
systemctl enable rpm-ostreed-automatic.timer
systemctl enable podman.socket

systemctl enable libvirtd.service
systemctl enable lxcfs.service
systemctl enable incus.service
systemctl enable tailscaled.service

# brew installation
# see: https://github.com/ublue-os/bluefin/blob/6d144f14817033a6ca5dd0a5edfb9f2371b001bb/build_files/base/brew.sh#L12
mkdir -p /var/home
mkdir -p /var/roothome
touch /.dockerenv
curl -Lo /tmp/brew-install https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
chmod +x /tmp/brew-install
/tmp/brew-install
tar --zstd -cvf /usr/share/homebrew.tar.zst /home/linuxbrew/.linuxbrew
rm -rf /var/home /home/linuxbrew .dockerenv