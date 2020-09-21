{ config, pkgs, lib, ... }:

let
  moz_overlay = import (builtins.fetchTarball
    "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz");
  home-manager = builtins.fetchTarball
    "https://github.com/rycee/home-manager/archive/release-20.03.tar.gz";
  icebox = builtins.fetchTarball
    "https://github.com/LEXUGE/icebox/archive/master.tar.gz";
in {
  imports = [
    ./hardware-configuration.nix
    "${icebox}"
    ./plugins
    "${home-manager}/nixos"
  ];

  nixpkgs.overlays = import ./packages;

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  security.pam.services.login.enableGnomeKeyring = true;

  systemd.user.services."setup-keyboard" = {
    enable = true;
    description = "Load my keyboard modifications";
    wantedBy = [ "hm-graphical-session.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.bash}/bin/bash ${pkgs.writeScript "setup-keyboard.sh" ''

        #!${pkgs.stdenv.shell}

        sleep 1;

        # Stop previous xcape processes, otherwise xcape is launched multiple times
        # And buttons get implemented multiple times
        ${pkgs.killall}/bin/killall xcape

        # Load keyboard layout
        ${pkgs.xorg.xkbcomp}/bin/xkbcomp /etc/X11/keymap.xkb $DISPLAY

        # Capslock to control
        ${pkgs.xcape}/bin/xcape -e 'Control_L=Escape'

        # Make space Control L whenn pressed.
        spare_modifier="Hyper_L"
        ${pkgs.xorg.xmodmap}/bin/xmodmap -e "keycode 65 = $spare_modifier"
        ${pkgs.xorg.xmodmap}/bin/xmodmap -e "remove mod4 = $spare_modifier"
        ${pkgs.xorg.xmodmap}/bin/xmodmap -e "add Control = $spare_modifier"

        # Map space to an unused keycode (to keep it around for xcape to
        # use).
        ${pkgs.xorg.xmodmap}/bin/xmodmap -e "keycode any = space"

        # Finally use xcape to cause the space bar to generate a space when tapped.
        ${pkgs.xcape}/bin/xcape -e "$spare_modifier=space"

        echo "Keyboard setup done!"
      ''}";
    };
  };

  # SUBSYSTEM=="usb", ACTION=="add", RUN+="${pkgs.systemd}/bin/systemctl --user restart setup-keyboard"
  services.udev.extraRules = ''
        SUBSYSTEM=="usb", ACTION=="add", \
        ENV{ID_VENDOR}=="Ultimate_Gadget_Laboratories",\
        TAG+="systemd",\
        ENV{SYSTEMD_USER_WANTS}+="setup-keyboard.service"
        KERNEL=="ttyUSB[0-9]*",MODE="0666"
  '';

  icebox = {
    users = {
      plugins = [ "ahmetde" "hm-fix" "ahmet-profile" ];
      users = {
        ahmet = {
          regular = {
            hashedPassword =
              "$6$.6NbHKr23r$uD0zVajkT5IWBDeexyn6ZkYmzCCkgpInOrsSGtUsygs6nqTP7Kny2U5zzQSEBnrniYsZoBj35p4PMjaCpzj7l0";
            shell = pkgs.zsh;
            isNormalUser = true;
            # wheel - sudo
            # networkmanager - manage network
            # video - light control
            # libvirtd - virtual manager controls.
            # dialout - tty
            extraGroups = [ "wheel" "networkmanager" "video" "libvirtd" "docker" "dialout" "wireshark" ];
          };
          configs = {
            ahmet-profile = {
              enable = true;
              extraPackages = with pkgs; [
                htop
                # deluge
                zoom-us
                thunderbird
                spotify
                # tdesktop
                # minecraft
                virtmanager
                # texlive.combined.scheme-full
                # steam
                # etcher
                # vlc
                pavucontrol
                # calibre
                # tor-browser-bundle-bin
                # latest.rustChannels.stable.rust
                ifuse
                libimobiledevice
              ];
            };
            ahmetde = {
              enable = true;
              # Adapt followings to what your device profile supplied
              battery = "BAT0";
              power = "AC";
              network-interface = "wlo1";
            };
          };
        };
      };
    };

    devices = {
      # plugins = [ "g3" "howdy" ];
      plugins = [ "g3" ];
      configs = {
        g3 = {
          # Choose "howdy", "fprintd", or null.
          bio-auth = null;
        };
        # g3 would automatically enable howdy and set necessary configuratons.
        howdy.pamServices = [ "sudo" "login" "polkit-1" "i3lock" ];
      };
    };

    lib = {
      modules = [ (import ./plugins/lib/modules/std.nix { lib = lib; }) ];
      configs = {
        system = {
          # Path to directories (use relative paths to avoid trouble in nixos-install.)
          # If you don't understand, just keep it as it is.
          dirs = {
            secrets = ./secrets; # Did you read the comments above?
            dotfiles = ./dotfiles;
          };
          bluetooth = {
            # Force enable/disable bluetooth
            # enable = true;
            # Choose default bluetooth service
            service = "blueman";
          };
        };
        devices = {
          # resume_offset value. Obtained by <literal>filefrag -v /swapfile | awk '{ if($1=="0:"){print $4} }'</literal>
          # If you want to hibernate, you MUST set it properly.
          swapResumeOffset = 36864;
        };
      };
    };

    system = {
      #plugins = [ "x-os" "gnome" "clash" "onlyoffice-desktop" ];
      plugins = [ "x-os" ];
      stateVersion = "20.03";
      configs = {
        x-os = {
          enable = true;
          hostname = "darkstar";
          # Set the list to `[ ]` to use official cache only.
          binaryCaches =
            [  ];
          # Choose ibus engines to apply
          # ibus-engines = with pkgs.ibus-engines; [ libpinyin ];
        };
        # clash = {
        #   enable = true;
        #   redirPort =
        #     7892; # This must be the same with the one in your clash.yaml
        # };
      };
    };

    overlays = [ moz_overlay ];
  };
}
