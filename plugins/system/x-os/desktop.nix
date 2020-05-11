{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs.system) dpi scale cursorSize;
  cfg = config.icebox.static.system.x-os;
in lib.mkIf cfg.enable {
  services.xserver = {
    # Start X11
    enable = true;
    dpi = dpi * scale;

    # Keyboard settings
    layout = "us";
    xkbVariant = "colemak";
    # Capslock as Control
    xkbOptions = "ctrl:nocaps";

    # Configure touchpad
    libinput = {
      enable = true;
      naturalScrolling = true;
    };

    desktopManager.session = [{
      name = "home-manager";
      bgSupport = true;
      start = ''
              ${pkgs.stdenv.shell} $HOME/.xsession-hm &
              waitPID=$!
              '';
    }];

    displayManager = {
      # LightDM display manager
      lightdm = {
        enable = true;
        greeters.gtk = {
          # Set cursor size
          cursorTheme.size = cursorSize * scale;
          # Use dark them
          theme.name = "Adwaita-dark";
        };
      };
      # Startup commands
      # sessionCommands = ''
      #   ibus-daemon -drx
      # '';
    };
  };

  # Enable `light` brightness controller
  programs.light.enable = true;

  programs.dconf.enable = true;
}
