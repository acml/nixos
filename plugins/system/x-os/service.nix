{ config, pkgs, lib, ... }:

with lib;

let
  inherit (config.icebox.static.lib.configs) system;
  cfg = config.icebox.static.system.x-os;
  baseconfig = { allowUnfree = true; };
  unstable = import (fetchTarball
        "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz") {
          config = baseconfig;
        };
in mkIf cfg.enable (mkMerge [
  ({
    # Enable usbmuxd for iOS devices.
    services.usbmuxd.enable = true;

    # Enable GVFS, implementing "trash" and so on.
    services.gvfs.enable = true;

    # Enable periodically updating the database of files used by the locate command.
    services.locate = {
      enable = true;
      # "findutils" is the default package (as per NixOS 17.03), but "mlocate"
      # has benefits:
      # 1. It (supposedly) updates its database faster.
      # 2. Its 'locate' command checks user permissions so that
      #    (a) users only see files they have access to on the filesystem and
      #    (b) indexing can run as root (without leaking file listings to
      #    unprivileged users).
      locate = pkgs.mlocate;
      localuser = null;  # needed so mlocate can run as root (TODO: improve NixOS module)
      # Locate will update its database everyday at lunch time
      interval = "12:00";
    };

    # imports = [ <nixos-unstable/nixos/modules/services/audio/mopidy.nix> ];
    # disabledModules = [ "services/audio/mopidy.nix" ];

    nixpkgs.config = baseconfig // {
      packageOverrides = pkgs: {
        mopidy = unstable.mopidy;
      };
    };

    services.mopidy = {
      enable = true;
      # extensionPackages = with pkgs.nixos-unstable; [ mopidy-iris mopidy-mpd mopidy-somafm mopidy-spotify mopidy-spotify-tunigo mopidy-tunein mopidy-youtube ];
      extensionPackages = with pkgs.nixos-unstable; [ mopidy-iris mopidy-mpd mopidy-somafm mopidy-spotify mopidy-tunein ];
      configuration = ''
      [audio]
      output = pulsesink server=127.0.0.1
      [mpd]
      hostname = ::
      [spotify]
      username = ozgezer
      password = <password>
      client_id = <client_id>
      client_secret = <client_secret>
      [iris]
      country = US
      locale = en_US
      '';
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable GNU Agent in order to make GnuPG works.
    programs.gnupg.agent.enable = true;
    programs.ssh.startAgent = true;

    # Enable sound.
    sound.enable = true;

    # Docker
    virtualisation.docker.enable = true;
    virtualisation.docker.enableNvidia = true;

    # Libvirtd
    virtualisation.libvirtd.enable = true;
    # FIXME: Should we let users add them to group or other way around.

    virtualisation.kvmgt.enable = true;

    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    # OpenGL 32 bit support for steam
    hardware.opengl.driSupport32Bit = true;

    # Configuration of pulseaudio to facilitate bluetooth headphones and Steam.
    hardware.pulseaudio = {
      enable = true;
      # 32 bit support for steam.
      support32Bit = true;
      # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
      # Only the full build has Bluetooth support, so it must be selected here.
      package = pkgs.pulseaudioFull;
      tcp = {
        enable = true;
        anonymousClients.allowedIpRanges = ["127.0.0.1"];
      };
    };

    # needs nixos-unstable
    # services.pipewire = {
    #   enable = true;
    #   alsa.enable = true;
    #   alsa.support32Bit = true;
    #   jack.enable = true;
    #   pulse.enable = true;
    #   socketActivation = true;
    # };

    # Enable fwupd service
    services.fwupd.enable = true;

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      forwardX11 = true;
    };

    services.atftpd = {
      enable = true;
    };

  })

  (mkIf (system.bluetooth.enable) {
    hardware.bluetooth.enable = true;
    # Whether enable blueman or not
    services.blueman.enable = mkIf (system.bluetooth.service == "blueman") true;
  })
])
