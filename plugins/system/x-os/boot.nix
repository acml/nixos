{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) devices system;
  cfg = config.icebox.static.system.x-os;
in with lib;
mkIf cfg.enable (mkMerge [({
  boot.cleanTmpDir = true;

  # Enable plymouth for better experience of booting
  boot.plymouth.enable = true;

  # Use simple bootloader; I prefer the on-demand BIOs boot menu
  boot.loader = {
    timeout = 1;
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      # Fix a security hole in place for backwards compatibility. See desc in
      # nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
      editor = false;
      # Limit number of generations to display in boot menu
      configurationLimit = 10;
    };
  };
})

# Resume kernel parameter
# If there is no swapResumeOffset defined, then we simply skip it.
# (mkIf (devices.swapResumeOffset != null) {
#   boot.resumeDevice = "/dev/mapper/cryptroot";
#   boot.kernelParams =
#     [ "resume_offset=${toString devices.swapResumeOffset}" ];
# })
  ])
