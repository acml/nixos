{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) devices system;
  iceLib = config.icebox.static.lib;
  cfg = config.icebox.static.users.ahmetde;
in {
  config.home-manager.users = iceLib.functions.mkUserConfigs' (n: c: {
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
          trans = "#90b5b49c";
          border = "#b5b49c";
          xcolor6 = "#a87b42";
          xcolor7 = "#5e5d4a";
          xcolor8 = "#213b59";

          background = "#dbd8ba";
        };

        "bar/top" = {
          # monitor = "LVDS1";
          monitor = "\${env:MONITOR:eDP-1-1}";
          bottom = false;
          width = "100%";
          height = 24;
          offset-x = "0%";
          offset-y = "0%";
          fixed-center = false;
          background = "\${colors.trans}";
          foreground = "\${colors.trans}";

          # border-top-size = 3;
          # border-top-color= "\${colors.border}";
          # border-left-size = 3;
          # border-left-color= "\${colors.border}";
          # border-right-size = 3;
          # border-right-color= "\${colors.border}";
          border-size = 0;
          # border-color= "\${colors.trans}";

          font-0 = "Inconsolata Nerd Font:size=12;2";
          font-1 = "Inconsolata Nerd Font:size=16;2";
          font-2 = "Inconsolata Nerd Font:size=13;2";

          modules-left = "menu arrow powermenu arrow random-background arrow bspwm arrow1";
          # modules-right = "arrow2 music mpd arrow pulseaudio backlight battery arrow wlan pkg arrow date openweathermap-simple arrow1";
          modules-center = "title";
          modules-right = "arrow2 pulseaudio arrow backlight arrow temperature arrow cpu arrow memory arrow fs_root fs_home arrow xkeyboard arrow date";
        };

        "bar/top-tray" = {
          inherits = "bar/top";
          tray-position = "right";
        };

        "module/arrow1" = {
          type = "custom/text";
          content = "";
          content-foreground = "\${colors.background}";
          content-background = "\${colors.trans}";
          content-font = 3;
        };

        "module/arrow" = {
          type = "custom/text";
          content = "|";
          content-foreground = "\${colors.xcolor7}";
          content-background = "\${colors.background}";
          content-font = 2;
        };

        "module/arrow2" = {
          type = "custom/text";
          content = "";
          content-foreground = "\${colors.background}";
          content-background = "\${colors.trans}";
          content-font = 3;
        };

        "module/random-background" = {
          type = "custom/text";
          content = "   ";
          click-left = "${pkgs.systemd}/bin/systemctl --user restart random-background";
          content-foreground = "\${colors.xcolor8}";
          content-background = "\${colors.background}";
        };

        "module/bspwm" = {
          type = "internal/bspwm";
          format = "<label-state> <label-mode>";
          fuzzy-match = "false";
          # ws-icon-[0-9]+ = "label;icon";
          ws-icon-0 = "1;爵";
          ws-icon-1 = "2;";
          ws-icon-2 = "3;";
          ws-icon-3 = "4;";
          ws-icon-4 = "5;";
          ws-icon-5 = "6;ﱘ";
          ws-icon-6 = "7;";
          ws-icon-7 = "8;";
          ws-icon-8 = "9;";
          ws-icon-9 = "0;";
          # label-mode-background = "\${colors.background}";
          format-background = "\${colors.background}";
          pin-workspaces = true;
          enable-click = true;
          enable-scroll = true;
          reverse-scroll = false;

          label-focused = "%icon%";
          label-focused-foreground = "\${colors.xcolor6}";
          label-focused-padding = 1;

          label-occupied = "%icon%";
          label-occupied-foreground = "\${colors.xcolor8}";
          label-occupied-padding = 1;

          label-empty = "%icon%";
          label-empty-foreground = "\${colors.xcolor7}";
          label-empty-padding = 1;

          label-monocle = "";
          label-monocle-foreground = "\${colors.xcolor6}";
          label-monocle-padding = 1;
          label-tiled = "";
          label-tiled-foreground = "\${colors.xcolor6}";
          label-tiled-padding = 1;
          label-fullscreen = "";
          label-fullscreen-foreground = "\${colors.xcolor6}";
          label-fullscreen-padding = 1;
          label-floating = "";
          label-floating-foreground = "\${colors.xcolor6}";
          label-floating-padding = 1;
          label-pseudotiled = "P";
          label-pseudotiled-foreground = "\${colors.xcolor6}";
          label-pseudotiled-padding = 1;
          label-locked = "";
          label-locked-foreground = "#bd2c40";
          label-locked-padding = 1;
          label-sticky = "";
          label-sticky-foreground = "#fba922";
          label-sticky-padding = 1;
          label-private = "";
          label-private-foreground = "#bd2c40";
          label-private-padding = 1;
          label-marked = "M";
          label-marked-foreground = "\${colors.xcolor6}";
          label-marked-padding = 1;
        };

        "module/menu" = {
          type = "custom/text";
          content = "";
          # content = "";
          #alt-icon = "";
          content-padding = 2;
          content-foreground = "\${colors.xcolor8}";
          content-background = "\${colors.background}";
          click-left = ''${pkgs.writeScript "polybar-click-left" ''
                        #!${pkgs.runtimeShell}
                        ${pkgs.rofi}/bin/rofi -show drun -modi drun \
                        -xoffset 4 -yoffset 32 \
                        -columns 1 \
                        -location 1 \
                        -show-icons \
                        -theme theme/startmenu.rasi
                        ''}
                        '';
        };

        "module/powermenu" = {
          type = "custom/menu";

          label-open = "";
          label-open-foreground = "\${colors.xcolor8}";
          label-open-background = "\${colors.background}";
          label-open-padding = 1;
          label-close = "";
          label-close-foreground = "\${colors.xcolor8}";
          label-close-background = "\${colors.background}";
          label-close-padding = 1;

          # lock screen
          menu-0-0 = "";
          menu-0-0-exec = "${pkgs.systemd}/bin/loginctl lock-session $XDG_SESSION_ID &> /dev/null";
          menu-0-0-foreground = "\${colors.xcolor8}";
          menu-0-0-background = "\${colors.background}";
          menu-0-0-padding = 1;
          # logout
          menu-0-1 = "";
          menu-0-1-exec = "${pkgs.systemd}/bin/loginctl terminate-session $XDG_SESSION_ID &> /dev/null";
          menu-0-1-foreground = "\${colors.xcolor8}";
          menu-0-1-background = "\${colors.background}";
          menu-0-1-padding = 1;
          # reboot
          menu-0-2 = "ﰇ";
          menu-0-2-exec = "${pkgs.systemd}/bin/systemctl reboot &> /dev/null";
          menu-0-2-foreground = "\${colors.xcolor8}";
          menu-0-2-background = "\${colors.background}";
          menu-0-2-padding = 1;
          # shutdown
          menu-0-3 = "襤";
          menu-0-3-exec = "${pkgs.systemd}/bin/systemctl poweroff &> /dev/null";
          menu-0-3-foreground = "\${colors.xcolor8}";
          menu-0-3-background = "\${colors.background}";
          menu-0-3-padding = 1;
        };

        "module/fs_root" = {
          type = "internal/fs";
          format-mounted = " <ramp-capacity>";
          format-mounted-foreground = "\${colors.xcolor8}";
          format-mounted-background = "\${colors.background}";
          interval = 25;
          mount-0 = "/";
          ramp-capacity-7 = "▁";
          ramp-capacity-6 = "▂";
          ramp-capacity-5 = "▃";
          ramp-capacity-4 = "▄";
          ramp-capacity-3 = "▅";
          ramp-capacity-2 = "▆";
          ramp-capacity-1 = "▇";
          ramp-capacity-0 = "█";
        };

        "module/fs_home" = {
          inherits = "module/fs_root";
          format-mounted = " <ramp-capacity>";
          mount-0 = "/home";
        };

        "module/music" = {
          type = "custom/script";
          exec = "$HOME/.config/polybar/mediaplayer.py";
          exec-if = "pgrep -x spotify";
          interval = 5;
          label = " %output:0:30:% ";
          label-padding = 1;
          format-foreground = "\${colors.xcolor8}";
          format-background = "\${colors.background}";
        };

        "module/date" = {
          type = "internal/date";
          interval = 60;
          date = "%Y %b %d (%a)";
          # time = "%I:%M%p";
          time = "%H:%M";
          # If you're not living in a country where AM and PM is used you can add -alt to the time above this line and comment it using ;, then you can remove the -alt to the time under this line and uncomment it.
          # time = " at %H:%M";
          #time-alt = "%H:%M:%S";
          #time-alt = "%H:%M:%S";
          format-prefix = " ";
          # format-prefix-foreground = "\${colors.xcolor8}";
          format-foreground = "\${colors.xcolor8}";
          format-background = "\${colors.background}";
          label = "%date% %time%";
          label-padding = 1;
        };

        "module/title" = {
          type = "internal/xwindow";

          # Available tags:
          #   <label> (default)
          format = "<label>";
          format-foreground = "\${colors.xcolor8}";
          format-padding = "4";

          # Available tokens:
          #   %title%
          # Default: %title%
          label = "%title%";
          label-maxlen = "100";

          # Used instead of label when there is no window title
          # Available tokens:
          #   None
          label-empty = "";
          # label-empty-foreground = "#707880";
        };

        "module/pulseaudio" = {
          type = "internal/pulseaudio";

          interval = 10;

          format-volume = "<ramp-volume> <label-volume>";
          format-volume-padding = 1;
          format-volume-foreground = "\${colors.xcolor8}";
          format-volume-background = "\${colors.background}";

          label-volume = "%percentage%";
          label-muted = " 00";
          label-muted-padding = 1;
          label-muted-foreground = "\${colors.xcolor8}";
          label-muted-background = "\${colors.background}";

          ramp-volume-0 = "";
          ramp-volume-1 = "";
          ramp-volume-2 = "";
          ramp-volume-3 = "";
          ramp-volume-font = 1;
        };

        "module/xkeyboard" = {
          type = "internal/xkeyboard";

          # List of indicators to ignore
          # blacklist-0 = "num lock  尿";
          # blacklist-1 = "scroll lock";
          # blacklist-2 = "caps lock  了 בּ";

          # Available tags:
          #   <label-layout> (default)
          #   <label-indicator> (default)
          format = "<label-layout><label-indicator>";
          # format-spacing = 0;
          format-prefix = " ";

          format-background = "\${colors.background}";
          format-foreground = "\${colors.xcolor8}";

          # Available tokens:
          #   %layout%
          #   %name%
          #   %number%
          #   %icon%
          # Default: %layout%
          label-layout = "%layout%";
          label-layout-padding = 1;
          label-indicator-on-capslock = "בּ ";
          label-indicator-off-capslock = "";
          label-indicator-on-numlock = " ";
          label-indicator-off-numlock = "";
        };

        "module/backlight" = {
          type = "internal/backlight";
          card = "intel_backlight";
          enable-scroll = true;

          format = "<ramp> <label>";
          format-padding = 1;
          format-foreground = "\${colors.xcolor8}";
          format-background = "\${colors.background}";
          label = "%percentage%";

          ramp-0 = "";
          ramp-1 = "";
          ramp-2 = "";
          ramp-3 = "";
          ramp-4 = "";
          ramp-font = 1;
        };

        "module/temperature" = {
          type = "internal/temperature";
          thermal-zone = 0;
          warn-temperature = 60;

          format = "<ramp> <label>";
          format-warn = "<ramp> <label-warn>";
          format-foreground = "\${colors.xcolor8}";
          format-background = "\${colors.background}";

          label = "%temperature-c%";
          label-warn = "%temperature-c%";
          label-warn-foreground = "\${colors.xcolor8}";

          ramp-0 = "";
          ramp-1 = "";
          ramp-2 = "";
          ramp-3 = "";
          ramp-4 = "";
        };

        "module/battery" = {
          type = "internal/battery";
          battery = c.battery;
          adapter = c.power;
          full-at = "95";
          time-format = "%H:%M";

          format-charging = "<animation-charging> <label-charging>";
          format-charging-foreground = "\${colors.xcolor8}";
          format-charging-background = "\${colors.background}";
          format-charging-padding = 1;

          format-discharging = "<ramp-capacity> <label-discharging>";
          format-discharging-foreground = "\${colors.xcolor8}";
          format-discharging-background = "\${colors.background}";
          format-discharging-padding = 1;

          format-full = "<label-full>";
          format-full-foreground = "\${colors.xcolor8}";
          format-full-background = "\${colors.background}";
          format-full-padding = 1;

          label-charging = "%percentage% %time%";
          label-discharging = "%percentage% %time%";
          label-full = " %percentage%";

          ramp-capacity-0 = "";
          ramp-capacity-0-font = 1;
          ramp-capacity-0-foreground = "\${colors.xcolor6}";
          ramp-capacity-1 = "";
          ramp-capacity-1-font = 1;
          ramp-capacity-1-foreground = "\${colors.xcolor6}";
          ramp-capacity-2-font = 1;
          ramp-capacity-2 = "";
          ramp-capacity-3-font = 1;
          ramp-capacity-3 = "";
          ramp-capacity-4-font = 1;
          ramp-capacity-4 = "";
          animation-charging-0 = "";
          animation-charging-framerate = 750;
        };

        "module/cpu" =  {
          type = "internal/cpu";
          interval = "0.5";
          format = "<label>  <ramp-load>";
          format-background = "\${colors.background}";
          format-foreground = "\${colors.xcolor8}";
          format-prefix-foreground = "\${colors.xcolor8}";
          label = "";
          ramp-load-0 = "▁";
          ramp-load-1 = "▂";
          ramp-load-2 = "▃";
          ramp-load-3 = "▄";
          ramp-load-4 = "▅";
          ramp-load-5 = "▆";
          ramp-load-6 = "▇";
          ramp-load-7 = "█";
        };

        "module/memory" =  {
          type = "internal/memory";
          interval = "1";
          format = "<label> <ramp-used>";
          format-background = "\${colors.background}";
          format-foreground = "\${colors.xcolor8}";
          format-prefix-foreground = "\${colors.xcolor8}";
          label = "";
          ramp-used-0 = "▁";
          ramp-used-1 = "▂";
          ramp-used-2 = "▃";
          ramp-used-3 = "▄";
          ramp-used-4 = "▅";
          ramp-used-5 = "▆";
          ramp-used-6 = "▇";
          ramp-used-7 = "█";
        };

        "module/mpd" = {
          type = "internal/mpd";

          format-online="<label-song> <icon-stop> <icon-play> ";
          format-online-foreground = "\${colors.xcolor8}";
          format-online-background = "\${colors.background}";
          format-online-padding = 0;

          label-song-maxlen = 25;
          label-song-ellipsis = true;

          icon-prev = "ﭣ";
          icon-stop = "ﭦ";
          icon-play = "奈";
          icon-pause = "";
          icon-next = "ﭡ";
          icon-random = "";
          icon-repeat = "";
        };

        "module/openweathermap-simple" = {
          type = "custom/script";
          exec = "$HOME/.config/polybar/openweathermap-simple.sh";
          interval = 1200;

          format-foreground = "\${colors.xcolor8}";
          format-background = "\${colors.background}";
        };

        "module/pkg" = {
          type = "custom/script";
          exec = "~/.config/polybar/updates.sh";
          format-padding = 1;
          tail = true;
          format-foreground = "\${colors.xcolor8}";
          format-background = "\${colors.background}";
        };
      };

      # Start up script for polybar
      script = ''
        #polybar rome &
      '';
    };
  }) cfg;
}
