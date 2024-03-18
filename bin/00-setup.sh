#/usr/bin/env bash

set -euo pipefail

# Remove unnecessary packages before installation.
rm -rf /etc/yum.repos.d/google-chrome.repo

# base setup:
# - remove unnecessary packages.
# - gnome-extensions with external dependencies.
# - distrobox as alternative to toolbox.
# - replace power-profiles-daemon with tuned.
# - gnome tweaks and popos icons for desktop customization.
rpm-ostree override remove firefox firefox-langpacks gnome-tour power-profiles-daemon
rpm-ostree install distrobox gnome-shell-extension-appindicator gnome-shell-extension-gsconnect \
    gnome-tweaks pop-icon-theme tuned tuned-ppd tuned-utils tuned-profiles-atomic

# monitoring and system administration:
# - bottom, lm_sensors, iotop, nvtop, ncdu, powertop for system monitoring.
# - setroubleshoot-server enables SELinux troubleshooting in flatpacked Cockpit.
# - intel-undervolt as a desperate attempt to improve my shitty battery life.
rpm-ostree install bottom lm_sensors iotop ncdu nvtop powertop setroubleshoot-server intel-undervolt

# mostly used for development:
# - vscode as default editor.
# - virtualization via libvirt + qemu and virt-manager as a simple GUI.
# - podman-compose for docker-compose compatibility.
# - incus + distrobuilder for system containers and virtual machines.
# - podmansh for containerized loginshells.
# - vargant for easy vm setups -- may become obsolete with incus.
rpm-ostree install code incus incus-agent distrobuilder libvirt libvirt-dbus podman-compose podmansh virt-install virt-manager vagrant vagrant-libvirt qemu qemu-kvm

# some extra utilites:
# - rsync, rclone, restic & autorestic for backups & cloud syncing.
# - tailscale & wireguard for vpn support.
# - cryfs for encryption -- enables usage of vaults flatpak.
rpm-ostree install cryfs rclone rsync restic autorestic tailscale wireguard-tools

# remove unnecessary repos after installation,
# as updates will be handled by building the image.
rm -rf /etc/yum.repos.d/{tailscale,vscode,ganto-lx4c,atim-bottom}.repo

# enable automatic updates.
sed -i 's/^#AutomaticUpdatePolicy=none$/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf
systemctl enable rpm-ostreed-automatic.timer

# enable systemlevel services:
systemctl enable firewalld.service
systemctl enable libvirtd.service
systemctl enable podman.socket
systemctl enable tailscaled.service
# systemctl enable tuned.service
# systemctl enable swtpm-workaround.service
