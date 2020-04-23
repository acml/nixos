{ config, pkgs, lib, ... }:

with lib;

let cfg = config.icebox.static.system.x-os;
in {
  options.icebox.static.system.x-os = {
    hostname = mkOption {
      type = types.str;
      description = "The hostname of the system";
    };
    binaryCaches = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Binary caches to use.";
    };
  };
  config = mkIf cfg.enable {
    networking.hostName = cfg.hostname; # Define hostname

    # Allow Spotify Local discovery
    networking.firewall.allowedTCPPorts = [ 57621 ];

    # 1714-1764 is KDE Connect.
    networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];

    networking.networkmanager = {
      # Enable networkmanager. REMEMBER to add yourself to group in order to use nm related stuff.
      enable = true;
      # Don't use DNS advertised by connected network. Use local configuration
      # dns = "none";
    };

    # Customized binary caches list (with fallback to official binary cache)
    nix.binaryCaches = cfg.binaryCaches;

    # Use local DNS server all the time
    # networking.resolvconf.useLocalResolver = true;
  };
}
