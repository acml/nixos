{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) devices system;
  iceLib = config.icebox.static.lib;
in {
  config.home-manager.users = iceLib.functions.mkUserConfigs' (name: cfg: {
    services.polybar = {
      # Polybar
      enable = true;

      package = pkgs.polybar.override {
        githubSupport = true;
        mpdSupport = true;
        nlSupport = true;
        i3GapsSupport = true;
        pulseSupport = true;
      };

      config = let interval = 5;
      in {
        "colors" = {
          black = "#222";
          grey = "#444";
          green = "#2ff923";
          azure = "#1febfd";
          red = "#ff0000";
        };

        "bar/base" = {
          dpi = system.scale * system.dpi;
          width = "100%";
          height = "2.7%";

          # Number of spaces between modules
          module-margin = 2;

          font-0 = "Fira Code:style=regular:size=10:antialias=true;1";
          font-1 = "FontAwesome:size=11;1";
          font-2 = "Material Icons:size=10;4";
          font-3 = "Symbola:size=11;1";

          line-size = 3;

          background = "\${colors.black}";
          locale = "tr_TR.UTF-8";
          wm-restack = "bspwm";
        };

        "bar/top" = {
          "inherit" = "bar/base";

          modules-left = "bspwm i3";
          modules-center = "date";
          modules-right = "memory wlan battery";
        };

        "bar/bottom" = {
          "inherit" = "bar/base";

          bottom = true;

          modules-left = "cpu filesystem-root filesystem-home pulseaudio";
          tray-position = "right";
        };

        "module/date" = {
          type = "internal/date";
          interval = interval;
          date = "%m/%d/%y";
          time = "%H:%M";
          label = "%time%  %date%";
        };

        "module/memory" = {
          type = "internal/memory";
          format-underline = "\${colors.green}";
          label = "RAM:%percentage_used%%";
          interval = interval;
        };

        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          label-volume = "VOL %percentage%%";
          label-volume-underline = "\${colors.green}";
          label-muted = "Muted";
        };

        "module/bspwm" = {
          type = "internal/bspwm";

          # Only show workspaces defined on the same output as the bar
          # NOTE: The bspwm and XRandR monitor names must match, which they do by default.
          # But if you rename your bspwm monitors with bspc -n this option will no longer
          # behave correctly.
          # Default: true
          pin-workspaces = true;

          # Output mode flags after focused state label
          # Default: false
          inline-mode = false;

          # Create click handler used to focus workspace
          # Default: true
          enable-click = false;

          # Create scroll handlers used to cycle workspaces
          # Default: true
          enable-scroll = false;

          # Set the scroll cycle direction
          # Default: true
          reverse-scroll = false;

          # Use fuzzy (partial) matching on labels when assigning
          # icons to workspaces
          # Example: code;♚ will apply the icon to all workspaces
          # containing 'code' in the label
          # Default: false
          fuzzy-match = false;

          # ws-icon-[0-9]+ = <label>;<icon>
          # Note that the <label> needs to correspond with the bspwm workspace name
          # Neither <label> nor <icon> can contain a semicolon (;)
          ws-icon-0 = "1;";
          ws-icon-1 = "2;";
          ws-icon-2 = "3;";
          ws-icon-3 = "4;4";
          ws-icon-4 = "5;♞";
          ws-icon-5 = "6;";
          ws-icon-6 = "7;";
          ws-icon-7 = "8;";
          ws-icon-8 = "9;";
          ws-icon-9 = "10;";
          ws-icon-default = "";

          # Available tags:
          #   <label-monitor>
          #   <label-state> - gets replaced with <label-(focused|urgent|occupied|empty)>
          #   <label-mode> - gets replaced with <label-(monocle|tiled|fullscreen|floating|locked|sticky|private)>
          # Default: <label-state>
          format = "<label-state> <label-mode>";

          # Available tokens:
          #   %name%
          # Default: %name%
          label-monitor = "%name%";

          # If any values for label-dimmed-N are defined, the workspace/mode
          # colors will get overridden with those values if the monitor is out of focus
          # To only override workspaces in a specific state, use:
          #   label-dimmed-focused
          #   label-dimmed-occupied
          #   label-dimmed-urgent
          #   label-dimmed-empty
          label-dimmed-foreground = "#555";
          # label-dimmed-underline = "${bar/top.background}";
          label-dimmed-focused-background = "#f00";

          # Available tokens:
          #   %name%
          #   %icon%
          #   %index%
          # Default: %icon%  %name%
          label-focused = "%icon% %name%";
          label-focused-background = "\${colors.grey}";
          label-focused-underline = "\${colors.azure}";

          # Available tokens:
          #   %name%
          #   %icon%
          #   %index%
          # Default: %icon%  %name%
          label-occupied = "%icon% %name%";

          # Available tokens:
          #   %name%
          #   %icon%
          #   %index%
          # Default: %icon%  %name%
          label-urgent = "%icon% %name%";
          label-urgent-background = "\${colors.red}";

          # label-monocle = "M";
          # label-floating = "S";

          # The following labels will be used to indicate the layout/mode
          # for the focused workspace. Requires <label-mode>
          #
          # Available tokens:
          #   None
          label-monocle = "";
          label-tiled = "";
          label-fullscreen = "";
          label-floating = "";
          label-pseudotiled = "P";
          label-locked = "";
          label-locked-foreground = "#bd2c40";
          label-sticky = "";
          label-sticky-foreground = "#fba922";
          label-private = "";
          label-private-foreground = "#bd2c40";
          label-marked = "M";
        };

        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          index-sort = "true";
          wrapping-scroll = "false";

          # Only show workspaces on the same output as the bar
          # pin-workspaces = true

          # focused = Active workspace on focused monitor
          label-focused = "%name%";
          label-focused-background = "\${colors.grey}";
          label-focused-underline = "\${colors.azure}";
          label-focused-padding = 2;

          # unfocused = Inactive workspace on any monitor
          label-unfocused = "%index%";
          label-unfocused-padding = 2;

          # visible = Active workspace on unfocused monitor
          label-visible = "%index%";
          label-visible-background = "\${self.label-focused-background}";
          label-visible-underline = "\${self.label-focused-underline}";
          label-visible-padding = "\${self.label-focused-padding}";

          # urgent = Workspace with urgency hint set
          label-urgent = "%index%";
          label-urgent-background = "\${colors.red}";
          label-urgent-padding = 2;
        };

        "module/cpu" = {
          type = "internal/cpu";
          format-underline = "\${colors.green}";
          label = "CPU:%percentage%%";
        };

        "module/filesystem-root" = {
          type = "internal/fs";
          mount-0 = "/";
          label-mounted = "%mountpoint%:%free%";
          format-mounted-underline = "\${colors.green}";
        };

        "module/filesystem-home" = {
          type = "internal/fs";
          mount-0 = "/home";
          label-mounted = "%mountpoint%:%free%";
          format-mounted-underline = "\${colors.green}";
        };

        "module/wlan" = {
          type = "internal/network";
          interface = cfg.network-interface;

          # Contents to show when network is connected
          label-connected = "%essid%+%downspeed%-%upspeed%";
          format-connected-underline = "\${colors.green}";
          # Contents to show when network is disconnected
          label-disconnected = "Disconnected";
          format-disconnected-background = "\${colors.red}";

          interval = interval;
        };

        "module/battery" = {
          type = "internal/battery";
          full-at = 99;
          time-format = "%H:%M";
          battery = cfg.battery;
          adapter = cfg.power;
          label-charging = "%percentage%% (%time%)";
          label-discharging = "%percentage%% (%time%)";
        };
      };

      # Start up script for polybar
      script = ''
        polybar top &
        polybar bottom &
      '';
    };
  }) config.icebox.static.users.ahmetde;
}
