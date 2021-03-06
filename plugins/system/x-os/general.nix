{ config, pkgs, lib, ... }:

with lib;

let
  inherit (config.icebox.static.lib.configs) system devices;
  cfg = config.icebox.static.system.x-os;
in {
  options.icebox.static.system.x-os.enable = mkOption {
    type = types.bool;
    default = false;
  };
  config = mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_zen;

    # Add swap file
    #swapDevices = [{
    #  device = "/var/swapFile";
    #  size = devices.ramSize;
    #}];

    # Support NTFS
    boot.supportedFilesystems = [ "ntfs" ];

    # Auto upgrade
    system.autoUpgrade.enable = true;

    # Auto gc and optimise
    nix.optimise.automatic = true;
    nix.gc.automatic = true;
    nix.gc.options = "--delete-older-than 7d";
  };
}
