# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in 

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];
 
 # Needed for store VSCode auth token 
 services.gnome.gnome-keyring.enable = true;

 nixpkgs.config.allowUnfree = true;
 fonts.fonts = with pkgs; [
    meslo-lg
    hack-font
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];
fonts.fontDir.enable = true;

i18n = {
      inputMethod = {
        enabled = "ibus";
        ibus.engines = with pkgs.ibus-engines; [ mozc bamboo anthy ];
      };
    };

environment.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
  };

users.users.kunny = {
    name = "kunny";
    home = "/home/kunny/";
  };

 home-manager.users.kunny = {
    home.packages = with pkgs; [
      # CLI Stuff
	    ranger
	    neofetch
	    htop
	    unzip
	    zip
      scrot
      dconf
      yt-dlp
      imagemagick
      duf
      psmisc

      # Programming Stuff
      alacritty 
      git
      python310
      vscode
      jetbrains.idea-community
      geany

      # SDK Stuff
      # dotnet-runtime
      openjdk

      # Video Stuff
      ffmpeg_5
      libsForQt5.kdenlive
      mpv
      vlc

      # Social 
      thunderbird
      tdesktop
      element-desktop

      # Sound 
      pavucontrol
      qpwgraph

      # torrent 
      qbittorrent

      # games 
      wine
      wine-wayland
      polymc

      # studying
      libreoffice-fresh
      anki
      zoom-us
      teams
      galculator
      pdftk
      
      # other 
      gimp
      bitwarden
      obs-studio
      libsForQt5.gwenview
      gImageReader
      nitrogen
      libsForQt5.okular
      tor-browser-bundle-bin
      rofi-wayland
      xfce.thunar
      xfce.thunar-volman
      xfce.tumbler
      

      # network 
      networkmanager-openvpn
      nm-tray
      networkmanager_dmenu
      mullvad-vpn
    ];

    # GTK theme 
    gtk = {
      enable = true; 
      cursorTheme = {
        package = pkgs.vanilla-dmz;
        name = "Vanilla-DMZ"; 
        size = 16; 
      };
      font = { 
        name = "Noto Sans";
        size = 14; 
      };
      theme = {
        name = "Nordic"; 
        };
      };
    };

environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    displayManager = {
        defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };


  # Use the systemd-boot EFI boot loader.
  #boot.loader.grub.device = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

   networking.hostName = "nixos"; # Define your hostname.
   #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
   networking.networkmanager = {
    enable = true; 
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
   };
   
   programs.nm-applet = {
    indicator = true;
    enable = true; 
   };

  # mullvad 
  services.mullvad-vpn.enable = true; 

  # Set your time zone.
   time.timeZone = "Europe/Moscow";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.enp2s0.useDHCP = true;
  # networking.interfaces.wlp1s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
   };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  
# Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;


  # Configure keymap in X11
   services.xserver.layout = "us";
   services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
    #hardware.pulseaudio.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      audio.enable = true; 
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true; 

    # If you want to use JACK applications, uncomment this
      jack.enable = true;
    };

  # Enable touchpad support (enabled default in most desktopManager).
   services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.kunny = {
     isNormalUser = true;
     extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
  	nordic
	  vim 
	  wget
	  firefox
    chromium
    w3m 
	  brightnessctl
    sysstat
    lm_sensors
    acpi
    alsa-utils
    xorg.xprop
    networkmanagerapplet
    libmtp
	 ];

  # Gtk/qt5 themes 
    qt5 = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita";
    };
  
  # VirtualBox 
  virtualisation.virtualbox.host.enable = true;
   users.extraGroups.vboxusers.members = [ "kunny" ];

  # enable MTP 
  services.gvfs.enable = true;

  # flatpak 
  services.flatpak.enable = true; 
  xdg.portal.enable = true; 
  xdg.portal.gtkUsePortal = false; 

  # Steam 
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };


  # Chromium 
  programs.chromium = {
    enable = true;
      extraOpts = {
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;
      "ImportAutofillFormData" = false;
      "SpellcheckLanguage" = ["en-US" "ru-RU" "jp-JP" "vn-VN"];
      };
    extensions = [
      "bgnkhhnnamicmpeenaelnjfhikgbkllg" # AdGuard
      "mnjggcdmjocbbbhaepdhchncahnbgone" # Sponsorblock
      "ohnjgmpcibpbafdlkimncjhflgedgpam" # 4ChudX
      "ejonaglbdpcfkgbcnidjlnjogfdgbofp" # Modern-Scroll
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   #services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

