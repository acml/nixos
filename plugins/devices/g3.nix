# Device specific configuration for ThinkPad X1 Carbon 7th Gen (20R1)
{ config, pkgs, lib, ... }:

let cfg = config.icebox.static.devices.g3;
in {
  options.icebox.static.devices.g3 = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description =
        "Whether to enable ThinkPad X1 Carbon 7th Gen device profile.";
    };

    bio-auth = mkOption {
      type = with types; nullOr (enum [ "howdy" "fprintd" ]);
      default = null;
      example = "howdy";
      description = "Biometric authentication method.";
    };
  };

  config = with lib;
    mkIf cfg.enable (mkMerge [
      ({
        # Activate acpi_call module for TLP ThinkPad features
        boot.extraModulePackages = with config.boot.kernelPackages; [
          acpi_call
          nvidia_x11
        ];

        boot.blacklistedKernelModules = ["nouveau" "bbswitch"];

        ##### disable intel, run nvidia only and as default
        hardware.opengl.enable = true;
        hardware.opengl.driSupport32Bit = true;

        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.nvidia.modesetting.enable = true;
        hardware.nvidia.prime = {
          sync.enable = true;
          sync.allowExternalGpu = true;

          # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
          nvidiaBusId = "PCI:1:0:0";

          # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
          intelBusId = "PCI:0:2:0";
        };

        # Set hardware related attributes
        icebox.static.lib.configs = {
          devices = {
            power = [ "AC" ];
            battery = [ "BAT0" ];
            ramSize = 32768;
            network-interface = [ "wlo1" ];
          };
          system = {
            # Set DPi to 200% scale
            scale = 1;
            # Enable Bluetuooth by default
            bluetooth.enable = mkDefault true;
          };
        };

        # Update Intel CPU Microcode
        hardware.cpu.intel.updateMicrocode = true;

        # Enable TLP Power Management
        services.tlp = {
          enable = true;
          extraConfig = ''
            START_CHARGE_THRESH_BAT0=85
            STOP_CHARGE_THRESH_BAT0=90
          '';
        };
      })

      (mkIf (cfg.bio-auth == "howdy") {
        # Howdy service configuration
        icebox.static.devices = {
          howdy = {
            enable = true;
            device = "/dev/video2";
            certainty = 5;
            dark-threshold = 100;
          };
          ir-toggle.enable = true;
        };
      })

      (mkIf (cfg.bio-auth == "fprintd") {
        # Enable fprintd
        icebox.static.devices.fprintd-1-90-1.enable = true;
        services.fprintd.enable = true;
      })

      (mkIf
        (config.icebox.static.lib.configs.devices.swapResumeOffset != null) {
          # Enable UPower to take action under critical situations. Only when hibernation is possible.
          services.upower = {
            enable = true;
            percentageCritical = 5;
            percentageAction = 3;
          };
        })
    ]);
}
