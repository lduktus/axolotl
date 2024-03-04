#/usr/bin/env bash

set -euo pipefail

sed -i 's/^#AutomaticUpdatePolicy=none$/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf
systemctl enable rpm-ostreed-automatic.timer

# remove unncessary google-chrome.
rm -rf /etc/yum.repos.d/google-chrome.repo

# ensure firewalld is enabled
systemctl enable firewalld.service

# enable podman system socket
systemctl enable podman.socket

# remove unnecessary packages
rpm-ostree override remove firefox firefox-langpacks gnome-tour

# install packages
rpm-ostree install \
    alacritty \
    adw-gtk3-theme \
    cryfs \
    distrobox \
    gnome-shell-extension-appindicator \
    gnome-shell-extension-gsconnect \
    gnome-tweaks \
    libvirt \
    libvirt-dbus \
    virt-install \
    virt-manager \
    vagrant \
    vagrant-libvirt \
    qemu \
    qemu-kvm \
    ncdu \
    pop-icon-theme \
    rsync \
    rclone \
    setroubleshoot-server \
    tailscale \
    wireguard-tools

# remove uncessary tailscale repo
rm -rf /etc/yum.repos.d/tailscale.repo

# Enable virzualization
systemctl enable libvirtd.service
systemctl enable tailscaled.service
