{ config, pkgs, lib, ... }:

let cfg = config.icebox.static.system.x-os;
in lib.mkIf cfg.enable {
  services.xserver = {
    # Start X11
    enable = true;

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
  };
}
