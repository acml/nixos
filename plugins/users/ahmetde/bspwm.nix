{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) system;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) flatten;

  iceLib = config.icebox.static.lib;
  lock = "${pkgs.i3lock}/bin/i3lock -c 000000";
in {
  config.home-manager.users = iceLib.functions.mkUserConfigs' (name: cfg: {
    # Blueman
    services.blueman-applet.enable = (lib.mkIf
      (system.bluetooth.enable && (system.bluetooth.service == "blueman"))
      true);

    services.network-manager-applet.enable = true;

    # Picom (Compton) compositor
    services.picom = {
      enable = true;
      # vertical sync to avoid screen tearing
      vSync = true;
    };

    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + alt + Escape" = "bspc quit";
        "super + {_,shift + }q" = "bspc node -{c,k}";
        "super + t" = "bspc desktop -l next";
        "super + apostrophe" = "bspc window -s last";
        "super + Return" = "${pkgs.alacritty}/bin/alacritty";
        "super + grave" = "scratch";
        "super + shift + grave" = "emacsclient -e '(open-scratch-frame)'";
        # "super + space" = "~/.dotfiles/bin/rofi/appmenu";
        "super + space" = "rofi -show drun -modi drun,run -show-icons -theme theme/appmenu.rasi";
        "super + Tab" = "~/.dotfiles/bin/rofi/windowmenu";
        "super + backslash" = "~/.dotfiles/bin/rofi/passmenu";
        "super + slash" = "~/.dotfiles/bin/rofi/filemenu -x";
        "super + Escape" = "pkill -USR1 -x sxhkd";
        "{Prior,Next}" = ":";

        ## Toggle floating/fullscreen
        "super + {_,ctrl + }f" = "bspc node -t ~{floating,fullscreen}";

        "super + {_,ctrl +}{h,j,k,l}" = "~/.dotfiles/bin/bspwm/focus {_,-m }{west,south,north,east}";
        "super + shift + {_,ctrl +}{h,j,k,l}" = "~/.dotfiles/bin/bspwm/swap {_,-m }{west,south,north,east}";

        ## Resize by preselection
        "super + alt + {1-9}" = "~/.dotfiles/bin/bspwm/presel 0.{1-9}";

        "super + alt + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
        "super + alt + Return" = "~/.dotfiles/bin/bspwm/subtract-presel";
        "super + alt + Delete" = "bspc node -p cancel";
        "super + {_,shift +}{1-9,0}" = "bspc {desktop -f,node -d} {1-9,10};";

        # expand a window by moving one of its side outward
        "super + {Left,Down,Up,Right}" = "bspc node -z {left -40 0,bottom 0 40,top 0 -40,right 40 0}";

        # contract a window by moving one of its side inward
        "super + ctrl + {Left,Down,Up,Right}" = "bspc node -z {right -40 0,top 0 40,bottom 0 -40,left 40 0}";

        # move a floating window
        "super + shift + {Left,Down,Up,Right}" = "bspc node -v {-40 0,0 40,0 -40,40 0}";

        #
        ## Media keys

        # screenshot region
        "Print" = "scrcap";
        # screencast region to mp4
        "super + Print" = "scrrec -s ~/recordings/$(date +%F-%T).mp4";
        # screencast region to gif
        "super + ctrl + Print" = "scrrec -s ~/recordings/$(date +%F-%T).gif";

        "XF86MonBrightnessUp" = "light -A 5";
        "XF86MonBrightnessDown" = "light -U 5";

        "XF86AudioMute" = "amixer -q set Master toggle";
        "XF86AudioLowerVolume" = "amixer -q set Master 10%- unmute";
        "XF86AudioRaiseVolume" = "amixer -q set Master 10%+ unmute";

        "XF86Audio{Play,Pause}" = "spt-send toggle";
        "XF86AudioNext" = "spt-send next";
        "XF86AudioPrev" = "spt-send prev";
      };
    };

    # Rofi
    programs.rofi = {
      enable = true;
      # font = "Fira Code 10";
      # theme = "glue_pro_blue";
      theme = (system.dirs.dotfiles + "/${name}/gtk-settings.ini");
      # extraConfig = ''
      #   rofi.show-icons: true
      #   rofi.dpi: ${toString (system.scale * system.dpi)}
      # '';
    };

    xdg.configFile = {
      "rofi/theme" = { source = (system.dirs.dotfiles + "/${name}/rofi"); recursive = true; };
    };

    services.dunst = {
      enable = true;
      iconTheme = {
        package = pkgs.gnome3.adwaita-icon-theme;
        name = "Adwaita";
        size = "32x32";
      };

      settings = {
        global = {
          font = "Fira Code 10";
          follow = "mouse";
          frame_width = 3; # Frame around the notification window
          frame_color = "#aaaaaa";
          geometry = "${toString (300 * system.scale)}x5-${
              toString (30 * system.scale)
            }-${toString (50 * system.scale)}";
          format = "<b>%s</b>\\n%b";
          icon_position = "left";
          separator_height = (5 * system.scale);
          mouse_left_click = "do_action";
          mouse_middle_click = "close_all";
          mouse_right_click = "close_current";
          browser = "${pkgs.firefox}/bin/firefox -new-tab";
          dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst:";
        };

        shortcuts = {
          close = "mod1+grave"; # mod1 is alt
          close_all = "mod4+grave"; # mod4 is super
          history = "ctrl+grave"; # ` is grave
          context = "ctrl+mod4+period"; # . is period
        };

        urgency_low = { # Dark
          timeout = 3;
          background = "#222222";
          foreground = "#888888";
        };

        urgency_normal = { # Blue
          timeout = 5;
          background = "#285577";
          foreground = "#ffffff";
        };

        urgency_critical = { # Red
          background = "#900000";
          foreground = "#ffffff";
          frame_color = "#ff0000";
          timeout = 0;
        };
      };
    };

    services.redshift = {
      enable = true;
      brightness.day = "1.0";
      brightness.night = "0.9";
      latitude = "41.015137";
      longitude = "28.979530";
      temperature.day = 5800;
      temperature.night = 3800;
      tray = true;
    };

    services.screen-locker = {
      enable = true;
      lockCmd = lock;
    };

    # Xsession
    xsession = {
      enable = true;

      # Enable bspwm
      windowManager.bspwm = let
        ws-names = {
          web = "number 1"; # Workspace 1 dedicated for web browsing
          chat = "number 2"; # Workspace 2 dedicated for chat
          editing =
            "number 3"; # Workspace 3 dedicated for editing and programming
          gaming = "number 9";
          zoom = "number 10";
        };
      in {
        enable = true;
        extraConfig = ''
                        systemctl --user restart polybar
                      '';
        monitors = { eDP-1 = [ "1" "2" "3" "4" "5"] ; };
        settings = {
          normal_border_color = "#F9F9F9";
          active_border_color = "#CCFF00";
          focused_border_color = "#00CCFF";
          presel_feedback_color = "#FFCC33";

          initial_polarity = "first_child";

          remove_unplugged_monitors = true;
          remove_disabled_monitors = true;
          border_width = 3;
          window_gap = 10;
          top_padding = 32;

          split_ratio = 0.5;
          borderless_monocle = true;
          gapless_monocle = true;

          focus_follows_pointer = true;
          pointer_follows_monitor = true;
        };
      };

      # Setup cursor
      pointerCursor = {
        package = pkgs.gnome3.adwaita-icon-theme;
        name = "Adwaita";
        size = system.cursorSize * system.scale;
      };
    };

  }) config.icebox.static.users.ahmetde;
}
