{ config, pkgs, lib, ... }:
let
  moz_overlay = import (builtins.fetchTarball
    "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz");
  home-manager = builtins.fetchTarball
    "https://github.com/rycee/home-manager/archive/master.tar.gz";
  icebox = builtins.fetchTarball
    "https://github.com/LEXUGE/icebox/archive/master.tar.gz";
in {
  imports = [
    ./hardware-configuration.nix
    "${icebox}"
    ./plugins
    "${home-manager}/nixos"
  ];

  home-manager.useUserPackages = true;

  icebox = {
    users = {
      plugins = [ "ahmetde" "hm-fix" ];
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
            extraGroups = [ "wheel" "networkmanager" "video" "libvirtd" ];
          };
          configs = {
            ahmetde = {
              enable = true;
              # Adapt followings to what your device profile supplied
              battery = "BAT0";
              power = "AC";
              network-interface = "wlo1";
              extraPackages = with pkgs; [
                htop
                # deluge
                zoom-us
                thunderbird
                spotify
                firefox
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
              ];
            };
          };
        };
      };
    };

    devices = {
      plugins = [ "g3" "howdy" ];
      configs = {
        g3 = {
          enable = true;
          # Choose "howdy", "fprintd", or null.
          bio-auth = "fprintd";
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
      # plugins = [ "x-os" "clash" ];
      plugins = [ "x-os" ];
      stateVersion = "19.09";
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
