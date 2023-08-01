IgnorePath '/efi/*'

IgnorePath '/etc/ca-certificates/*'
IgnorePath '/etc/fonts/*'
IgnorePath '/etc/ssl/*'
IgnorePath '/etc/systemd/*'

IgnorePath '/usr/lib/*'
IgnorePath '/usr/share/*'

IgnorePath '/var/lib/*'
IgnorePath '/var/log/*'
IgnorePath '/var/tmp/*'
IgnorePath '/var/vanta/*'


IgnorePackage aardvark-dns # Authoritative dns server for A/AAAA container records
IgnorePackage amd-ucode # Microcode update image for AMD CPUs
IgnorePackage b43-fwcutter # firmware extractor for the b43 kernel module
IgnorePackage base # Minimal package set to define a basic Arch Linux installation
IgnorePackage base-devel # Basic tools to build Arch Linux packages
IgnorePackage bash-completion # Programmable completion for the bash shell
IgnorePackage bind # A complete, highly portable implementation of the DNS protocol
IgnorePackage cryptsetup # Userspace setup tool for transparent encryption of block devices using dm-crypt
IgnorePackage device-mapper # Device mapper userspace library and tools
IgnorePackage dhclient # A standalone DHCP client from the dhcp package
IgnorePackage diffutils # Utility programs used for creating patch files
IgnorePackage dnsmasq # Lightweight, easy to configure DNS forwarder and DHCP server
IgnorePackage dosfstools # DOS filesystem utilities
IgnorePackage dracut # An event driven initramfs infrastructure
IgnorePackage d-spy # D-Bus debugger for GNOME
IgnorePackage e2fsprogs # Ext2/3/4 filesystem utilities
IgnorePackage efibootmgr # Linux user-space application to modify the EFI Boot Manager
IgnorePackage endeavouros-keyring # EndeavourOS keyring
IgnorePackage endeavouros-mirrorlist # EndeavourOS mirrorlist
IgnorePackage eos-apps-info # Documentation about apps in the EndeavourOS repository.
IgnorePackage eos-hooks # EndeavourOS pacman hooks
IgnorePackage eos-log-tool # Gathers selected system logs and sends them to the internet.
IgnorePackage eos-packagelist # An application to gather and optionally install package lists from the EndeavourOS installer
IgnorePackage eos-quickstart # An application for getting a quick start with installing packages
IgnorePackage eos-rankmirrors # EndeavourOS mirror ranking tool
IgnorePackage eos-update-notifier # Software update notifier and 'news for you' for EndeavourOS users.
IgnorePackage ethtool # Utility for controlling network drivers and hardware
IgnorePackage exfatprogs # exFAT filesystem userspace utilities for the Linux Kernel exfat driver
IgnorePackage f2fs-tools # Tools for Flash-Friendly File System (F2FS)
IgnorePackage gnome-keyring # Stores passwords and encryption keys
IgnorePackage gtk4 # GObject-based multi-platform GUI toolkit
IgnorePackage gvfs # Virtual filesystem implementation for GIO
IgnorePackage inetutils # A collection of common network programs
IgnorePackage inotify-tools # inotify-tools is a C library and a set of command-line programs for Linux providing a simple interface to inotify.
IgnorePackage iptables-nft # Linux kernel packet control tool (using nft interface)
IgnorePackage iwd # Internet Wireless Daemon
IgnorePackage jfsutils # JFS filesystem utilities
IgnorePackage kernel-install-for-dracut # Enables systemd-boot automation using kernel-install with dracut
IgnorePackage less # A terminal based program for viewing text files
IgnorePackage linux # The Linux kernel and modules
IgnorePackage linux-firmware # Firmware files for Linux
IgnorePackage linux-headers # Headers and scripts for building modules for the Linux kernel
IgnorePackage logrotate # Rotates system logs automatically
IgnorePackage lsb-release # LSB version query program
IgnorePackage lvm2 # Logical Volume Manager 2 utilities
IgnorePackage maim # Utility to take a screenshot using imlib2
IgnorePackage man-db # A utility for reading man pages
IgnorePackage man-pages # Linux man pages
IgnorePackage mdadm # A tool for managing/monitoring Linux md device arrays, also known as Software RAID
IgnorePackage modemmanager # Mobile broadband modem management service
IgnorePackage netctl # Profile based systemd network management
IgnorePackage networkmanager # Network connection manager and user applications
IgnorePackage network-manager-applet # Applet for managing network connections
IgnorePackage networkmanager-openconnect # NetworkManager VPN plugin for OpenConnect
IgnorePackage networkmanager-openvpn # NetworkManager VPN plugin for OpenVPN
IgnorePackage noise-suppression-for-voice # A real-time noise suppression plugin for voice
IgnorePackage noto-fonts-emoji # Google Noto emoji fonts
IgnorePackage nss-mdns # glibc plugin providing host name resolution via mDNS
IgnorePackage ntfs-3g # NTFS filesystem driver and utilities
IgnorePackage ntp # Network Time Protocol reference implementation
IgnorePackage nvidia-dkms # NVIDIA drivers - module sources
IgnorePackage nvidia-hook # pacman hook for nvidia
IgnorePackage nvidia-inst # Script to setup nvidia drivers (dkms version) in EndeavourOS
IgnorePackage nvidia-settings # Tool for configuring the NVIDIA graphics driver
IgnorePackage openssh # SSH protocol implementation for remote login, command execution and file transfer
IgnorePackage pipewire-jack # Low-latency audio/video router and processor - JACK support
IgnorePackage pipewire-pulse # Low-latency audio/video router and processor - PulseAudio replacement
IgnorePackage polkit-gnome # Legacy polkit authentication agent for GNOME
IgnorePackage power-profiles-daemon # Makes power profiles handling available over D-Bus
IgnorePackage reiserfsprogs # Reiserfs utilities
IgnorePackage rtkit # Realtime Policy and Watchdog Daemon
IgnorePackage s-nail # Environment for sending and receiving mail
IgnorePackage sudo # Give certain users the ability to run some commands as root
IgnorePackage sysfsutils # System Utilities Based on Sysfs
IgnorePackage systemd-sysvcompat # sysvinit compat for systemd
IgnorePackage texinfo # GNU documentation system for on-line information and printed output
IgnorePackage ttf-nerd-fonts-symbols # High number of extra glyphs from popular 'iconic fonts'
IgnorePackage ttf-nerd-fonts-symbols-mono # High number of extra glyphs from popular 'iconic fonts' (monospace)
IgnorePackage usb_modeswitch # Activating switchable USB devices on Linux.
IgnorePackage usbutils # A collection of USB tools to query connected USB devices
IgnorePackage welcome # Welcome greeter for new EndeavourOS users.
IgnorePackage wireplumber # Session / policy manager implementation for PipeWire
IgnorePackage wpa_supplicant # A utility providing key negotiation for WPA wireless networks
IgnorePackage xclip # Command line interface to the X11 clipboard
IgnorePackage xf86-input-libinput # Generic input driver for the X.Org server based on libinput
IgnorePackage xfsprogs # XFS filesystem utilities
IgnorePackage xl2tpd # an open source implementation of the L2TP maintained by Xelerance Corporation
IgnorePackage xorg-server # Xorg X server
IgnorePackage xorg-xdpyinfo # Display information utility for X
IgnorePackage xorg-xinit # X.Org initialisation program
IgnorePackage xorg-xrandr # Primitive command line interface to RandR extension
IgnorePackage xorg-xwininfo # Command-line utility to print information about windows on an X server
IgnorePackage zsh # A very advanced and programmable command interpreter (shell) for UNIX
