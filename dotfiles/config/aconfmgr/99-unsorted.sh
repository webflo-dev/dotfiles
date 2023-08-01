

# Thu Jul 27 12:11:55 PM CEST 2023 - Unknown packages


AddPackage alacritty # A cross-platform, GPU-accelerated terminal emulator
AddPackage bat # Cat clone with syntax highlighting and git integration
AddPackage btop # A monitor of system resources, bpytop ported to C++
AddPackage busybox # Utilities for rescue and embedded systems
AddPackage cameractrls # Camera controls for Linux
AddPackage choose # A human-friendly and fast alternative to cut and (sometimes) awk
AddPackage cmus # Feature-rich ncurses-based music player
AddPackage croc # Easily and securely send things from one computer to another.
AddPackage dua-cli # A tool to conveniently learn about the disk usage of directories, fast!
AddPackage duf # Disk Usage/Free Utility
AddPackage exa # ls replacement
AddPackage fd # Simple, fast and user-friendly alternative to find
AddPackage feh # Fast and light imlib2-based image viewer
AddPackage file-roller # Create and modify archives
AddPackage font-manager # A simple font management application for GTK+ Desktop Environments
AddPackage fzf # Command-line fuzzy finder
AddPackage gdu # Fast disk usage analyzer
AddPackage git-delta # Syntax-highlighting pager for git and diff output
AddPackage go # Core compiler tools for the Go programming language
AddPackage grex # A command-line tool for generating regular expressions from user-provided input strings
AddPackage handlr # Powerful alternative to xdg-utils written in Rust
AddPackage imagemagick # An image viewing/manipulation program
AddPackage inxi # Full featured CLI system information tool
AddPackage jq # Command-line JSON processor
AddPackage kitty # A modern, hackable, featureful, OpenGL-based terminal emulator
AddPackage kubectl # A command line tool for communicating with a Kubernetes API server
AddPackage lnav # A curses-based tool for viewing and analyzing log files
AddPackage mpv # a free, open source, and cross-platform media player
AddPackage navi # An interactive cheatsheet tool for the command-line
AddPackage neofetch # A CLI system information tool written in BASH that supports displaying images.
AddPackage nnn # The fastest terminal file manager ever written.
AddPackage papirus-icon-theme # Papirus icon theme
AddPackage paru # Feature packed AUR helper
AddPackage perl # A highly capable, feature-rich programming language
AddPackage playerctl # mpris media player controller and lib for spotify, vlc, audacious, bmp, xmms2, and others.
AddPackage podman # Tool and library for running OCI-based containers in pods
AddPackage podman-compose # A script to run docker-compose.yml using podman
AddPackage podman-docker # Emulate Docker CLI using podman
AddPackage postgresql # Sophisticated object-relational DBMS
AddPackage pulsemixer # CLI and curses mixer for pulseaudio
AddPackage python # Next generation of the python high-level scripting language
AddPackage python-pillow # Python Imaging Library (PIL) fork
AddPackage ranger # Simple, vim-like file manager
AddPackage ripgrep # A search tool that combines the usability of ag with the raw speed of grep
AddPackage rofi # A window switcher, application launcher and dmenu replacement
AddPackage sniffnet # Application to comfortably monitor your network traffic
AddPackage sshfs # FUSE client based on the SSH File Transfer Protocol
AddPackage starship # The cross-shell prompt for astronauts
AddPackage the_silver_searcher # Code searching tool similar to Ack, but faster
AddPackage thunar # Modern, fast and easy-to-use file manager for Xfce
AddPackage thunar-archive-plugin # Adds archive operations to the Thunar file context menus
AddPackage thunar-media-tags-plugin # Adds special features for media files to the Thunar File Manager
AddPackage thunar-volman # Automatic management of removable drives and media for Thunar
AddPackage tldr # Command line client for tldr, a collection of simplified and community-driven man pages.
AddPackage unzip # For extracting and viewing files in .zip archives
AddPackage upower # Abstraction for enumerating power devices, listening to device events and querying history and statistics
AddPackage which # A utility to show the full path of commands
AddPackage wmctrl # Control your EWMH compliant window manager from command line
AddPackage xdotool # Command-line X11 automation tool
AddPackage xh # Friendly and fast tool for sending HTTP requests
AddPackage xterm # X Terminal Emulator
AddPackage zellij # A terminal multiplexer
AddPackage zoxide # A smarter cd command for your terminal


# Thu Jul 27 12:11:56 PM CEST 2023 - Unknown foreign packages


AddPackage --foreign 1password # Password manager and secure wallet
AddPackage --foreign aconfmgr-git # A configuration manager for Arch Linux
AddPackage --foreign awesome-git # Highly configurable framework window manager
AddPackage --foreign dbgate-bin # Database manager for MySQL, PostgreSQL, SQL Server, MongoDB, SQLite and others. Runs under Windows, Linux, Mac or as web application
AddPackage --foreign dotdrop # Save your dotfiles once, deploy them everywhere
AddPackage --foreign fnm # Fast and simple Node.js version manager, built with Rust
AddPackage --foreign gitlab-cli # Perform GitLab actions on the CLI
AddPackage --foreign kalc # a complex numbers, 2d/3d graphing, arbitrary precision, vector, cli calculator with real-time output
AddPackage --foreign languagetool-rust # LanguageTool API in Rust
AddPackage --foreign microsoft-edge-stable-bin # A browser that combines a minimal design with sophisticated technology to make the web faster, safer, and easier
AddPackage --foreign mprocs-bin # Run multiple commands in parallel
AddPackage --foreign neovim-git # Fork of Vim aiming to improve user experience, plugins, and GUIs.
AddPackage --foreign overmind # Process manager for Procfile-based applications and tmux
AddPackage --foreign pacdef # multi-backend declarative package manager for Linux
AddPackage --foreign picom-simpleanims-next-git # The "next" branch of picom-simpleanims-git
AddPackage --foreign pipr-git # A commandline-utility to interactively build complex shell pipelines
AddPackage --foreign podman-desktop # Manage Podman and other container engines from a single UI and tray.
AddPackage --foreign rargs # A kind of xargs + awk with pattern-matching support
AddPackage --foreign rm-improved # Rm ImProved (rip) is a command-line deletion tool focused on safety, ergonomics, and performance. Use it as a safer alternative to rm.
AddPackage --foreign slack-desktop # Slack Desktop (Beta) for Linux
AddPackage --foreign spotify # A proprietary music streaming service
AddPackage --foreign topgrade-bin # Invoke the upgrade procedure of multiple package managers
AddPackage --foreign vanta-agent # Vanta agent
AddPackage --foreign visual-studio-code-bin # Visual Studio Code (vscode): Editor for building and debugging modern web and cloud applications (official binary version)
AddPackage --foreign xdg-utils-handlr # A shim for xdg-utils to use handlr under the hood


# Thu Jul 27 12:11:56 PM CEST 2023 - New / changed files


CopyFile /crypto_keyfile.bin 600
CopyFile /etc/adjtime
CopyFile /etc/containers/containers.conf
CopyFile /etc/containers/containers.conf.pacnew
CopyFile /etc/containers/networks/traefik.json
CopyFile /etc/containers/registries.conf
CreateDir /etc/credstore 0
CreateDir /etc/credstore.encrypted 0
CopyFile /etc/crypttab
CopyFile /etc/default/keyboard
CopyFile /etc/default/locale
CopyFile /etc/dracut.conf.d/calamares-luks.conf
CopyFile /etc/dracut.conf.d/eos-defaults.conf
CopyFile /etc/environment
CopyFile /etc/fstab
CopyFile /etc/group
CopyFile /etc/group-
CopyFile /etc/gshadow
CopyFile /etc/gshadow- 600
CopyFile /etc/hostname
CopyFile /etc/hosts
CopyFile /etc/issue
CopyFile /etc/kernel/cmdline
CopyFile /etc/ld.so.cache
CopyFile /etc/locale.conf
CopyFile /etc/locale.gen
CreateLink /etc/localtime /usr/share/zoneinfo/Europe/Paris
CopyFile /etc/lsb-release
CopyFile /etc/machine-id 444
CreateDir /etc/openvpn/client 750 openvpn network
CreateDir /etc/openvpn/server 750 openvpn network
CreateLink /etc/os-release ../usr/lib/os-release
CopyFile /etc/pacman.conf
CopyFile /etc/pacman.d/endeavouros-mirrorlist
CopyFile /etc/pacman.d/endeavouros-mirrorlist.pacnew
CopyFile /etc/pacman.d/gnupg/crls.d/DIR.txt
CopyFile /etc/pacman.d/gnupg/gpg-agent.conf
CopyFile /etc/pacman.d/gnupg/gpg.conf
CreateFile /etc/pacman.d/gnupg/.gpg-v21-migrated > /dev/null
CopyFile /etc/pacman.d/gnupg/openpgp-revocs.d/79C1F5B6B116255CF4306DD22621AEB48B6C5BC2.rev 600
CopyFile /etc/pacman.d/gnupg/private-keys-v1.d/2D279C6899D5E005459B89A1F4D506386B66EDF0.key 600
CopyFile /etc/pacman.d/gnupg/pubring.gpg
CopyFile /etc/pacman.d/gnupg/pubring.gpg~
CreateFile /etc/pacman.d/gnupg/secring.gpg 600 > /dev/null
CopyFile /etc/pacman.d/gnupg/tofu.db
CopyFile /etc/pacman.d/gnupg/trustdb.gpg
CopyFile /etc/pacman.d/mirrorlist
CopyFile /etc/pacman.d/mirrorlist.pacnew
CopyFile /etc/passwd
CopyFile /etc/passwd-
CopyFile /etc/passwd.OLD
CreateFile /etc/.pwd.lock 600 > /dev/null
CopyFile /etc/resolv.conf
CopyFile /etc/shadow
CopyFile /etc/shadow- 600
CopyFile /etc/shells
CopyFile /etc/skel/.bashrc 755
CopyFile /etc/subgid
CreateFile /etc/subgid- > /dev/null
CopyFile /etc/subuid
CreateFile /etc/subuid- > /dev/null
CopyFile /etc/sudoers.d/10-installer 440
CopyFile /etc/timezone
CopyFile /etc/.updated
CopyFile /etc/vanta.conf 640
CopyFile /etc/vconsole.conf
CopyFile /etc/X11/xorg.conf.d/00-keyboard.conf
CopyFile /etc/X11/xorg.conf.d/10-monitor.conf
CopyFile /etc/X11/xorg.conf.d/20-nvidia.conf
CopyFile /etc/xml/catalog
CopyFile /etc/zsh/zshenv
CreateDir /lost+found 700
CreateFile /var/db/sudo/lectured/florent 600 '' florent > /dev/null
CopyFile /var/.updated


# Thu Jul 27 12:11:56 PM CEST 2023 - New file properties


SetFileProperty /etc/pacman.d/gnupg/crls.d mode 700
SetFileProperty /etc/pacman.d/gnupg/openpgp-revocs.d mode 700
SetFileProperty /etc/pacman.d/gnupg/private-keys-v1.d mode 700
SetFileProperty /opt/1Password/1Password-BrowserSupport group onepassword
SetFileProperty /opt/1Password/1Password-BrowserSupport mode 2755
SetFileProperty /opt/1Password/1Password-KeyringHelper group onepassword
SetFileProperty /opt/1Password/1Password-KeyringHelper mode 6755
