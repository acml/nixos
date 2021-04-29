{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) system;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) flatten;

  iceLib = config.icebox.static.lib;
  lock = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -p -t ''";
  cfg = config.icebox.static.users.ahmetde;

  rofi-power-menu = pkgs.stdenv.mkDerivation rec {
    pname = "rofi-power-menu";
    version = "368ba43f9b9c367288fb2dfc090902434b1de1ee";

    src = pkgs.fetchFromGitHub {
      owner = "jluttine";
      repo = pname;
      rev = version;
      sha256 = "0yrnjihjs8cl331rmipr3xih503yh0ir60mwsxwh976j2pn3qiq6";
    };

    # doCheck = false;

    installPhase = ''
      mkdir -p $out/bin
      install -Dm755 ./rofi-power-menu $out/bin/rofi-power-menu
    '';

    meta = with lib; {
      description = "Power-menu mode for Rofi";
      homepage = "https://github.com/jluttine/rofi-power-menu";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ jluttine ];
    };
  };

in {

  config.nixpkgs = {
    config.packageOverrides = oldPkgs: {
      wallpapers = import ./wallpapers.nix;
    };
  };

  config.home-manager.users = iceLib.functions.mkUserConfigs' (n: c: {
    # Blueman
    services.blueman-applet.enable = (lib.mkIf
      (system.bluetooth.enable && (system.bluetooth.service == "blueman"))
      true);

    services.cbatticon.enable = true;
    services.gnome-keyring.enable = true;
    services.pasystray.enable = true;
    services.random-background = {
      enable = true;
      enableXinerama = false;
      display = "tile";
      imageDirectory = ''${pkgs.wallpapers}/share/wallpapers'';
    };
    services.udiskie = {
      enable = true;
      automount = true;
      tray = "always";
    };
    services.unclutter = {
      enable = true;
      package = pkgs.unclutter-xfixes;
      timeout = 5;
    };

    services.network-manager-applet.enable = true;

    # Picom (Compton) compositor
    services.picom.enable = true;
    services.picom.package = pkgs.nur.repos.reedrw.picom-next-ibhagwan;
    services.picom.backend = "glx";
    services.picom.experimentalBackends = true;
    services.picom.opacityRule = [
      "80:class_g  = 'Zathura'"
      "80:class_g  = 'TelegramDesktop'"
      "80:class_g  = 'Discord'"
      "80:class_g  = 'Emacs'"
      "100:class_g = 'keynav'"
    ];
    services.picom.extraOptions = ''
    detect-client-opacity = true;
    detect-rounded-corners = true;
    blur:
    {
        method = "kawase";
        strength = 8;
        background = false;
        background-frame = false;
        background-fixed = false;
    };
    blur-background-exclude = [
        "class_g = 'keynav'",
        "class_g = 'Firefox' && window_type *= 'utility'",
    ];
    corner-radius = 9;
    rounded-corners-exclude = [
        "_NET_WM_STATE@:32a *= '_NET_WM_STATE_FULLSCREEN'",
        "class_g = 'keynav'",
    ];
    round-borders = 1;
    round-borders-exclude = [
        "class_g = 'keynav'"
    ];
  '';

    home.packages = with pkgs; [
      sxhkd
      (writeScriptBin "bspwm_resize" ''
                        #!${stdenv.shell}
                        size=''${2:-'10'}
                        direction=$1

                        bspc query -N -n focused.floating
                        floating=$?

                        case "$direction" in
                             west)  [ $floating = 0 ] && bspc node -z right -"$size" 0 || bspc node @west  -r -"$size" || bspc node @east  -r -"$size" ;;
                             east)  [ $floating = 0 ] && bspc node -z right +"$size" 0 || bspc node @west  -r +"$size" || bspc node @east  -r +"$size" ;;
                             north) [ $floating = 0 ] && bspc node -z bottom 0 -"$size" || bspc node @south -r -"$size" || bspc node @north -r -"$size" ;;
                             south) [ $floating = 0 ] && bspc node -z bottom 0 +"$size" || bspc node @south -r +"$size" || bspc node @north -r +"$size" ;;
                        esac
                        '')
      (writeScriptBin "bspwm_smart_move" ''
                        #!${stdenv.shell}
                        [ "$#" -eq 1 ] || { echo "Pass only one argument: north,east,south,west"; exit 1; }

                        # Check if argument is a valid direction.
                        case "$1" in
                             north)
                              dir="$1"
                              dx=0
                              dy=-90
                              ;;
                             east)
                              dir="$1"
                              dx=90
                              dy=0
                              ;;
                             south)
                              dir="$1"
                              dx=0
                              dy=90
                              ;;
                             west)
                              dir="$1"
                              dx=-90
                              dy=0
                              ;;
                             *)
                              echo "Not a valid argument."
                              echo "Use one of: north,east,south,west"
                              exit 1
                              ;;
                        esac

                        _query_nodes() {
                          bspc query -N -n "$@"
                        }

                        [ -z "$(_query_nodes focused.floating)" ] || { bspc node --move "$dx" "$dy"; exit 0; }

                        receptacle="$(_query_nodes 'any.leaf.!window')"

                        # This regulates the behaviour documented in the description.
                        if [ -n "$(_query_nodes "''${dir}.!floating")" ]; then
                           bspc node -s "$dir"
                        elif [ -n "$receptacle" ]; then
                           bspc node focused -n "$receptacle" --follow
                        else
                          bspc node @/ -p "$dir" -i && bspc node -n "$receptacle" --follow
                        fi
                        '')
    ];
    # Rofi
    programs.rofi = {
      enable = true;
      # font = "Fira Code 10";
      # theme = "glue_pro_blue";
      # theme = (system.dirs.dotfiles + "/${name}/rofi/appmenu.rasi");
      # extraConfig = ''
      #   rofi.show-icons: true
      #   rofi.dpi: ${toString (system.scale * system.dpi)}
      # '';
    };

    xdg.configFile = {
      "rofi/theme" = { source = (system.dirs.dotfiles + "/${n}/rofi"); recursive = true; };
      "sxhkd/sxhkdrc" = {
        text = ''
          super + alt + Escape
            bspc quit

          super + {_,shift + }q
            bspc node -{c,k}

          # Toggle monocle layout (maximise focused node).
          super + m
            bspc desktop -l next

          # Toggle floating, tiled, fullscreen view.
          super + {t,shift + f,f}
            bspc node -t "~{tiled,floating,fullscreen}"

          super + {_,alt + }Return
            {alacritty,e}

          super + space
            rofi -show drun -modi drun,run -show-icons -theme theme/appmenu.rasi

          super + Tab
            rofi -show window -show-icons -theme theme/windowmenu.rasi

          ctrl + alt + Delete
            rofi -show p -modi p:${rofi-power-menu}/bin/rofi-power-menu -matching fuzzy -show-icons -icon-theme Papirus-Dark -theme theme/appmenu.rasi

          super + Escape
            pkill -USR1 -x sxhkd

          # {Prior,Next}
          #   :

          # focus or send to the given desktop
          super + {1-9,0}
            target='^{1-9,10}'; \
            [ "$(bspc query -D -d "$target")" != "$(bspc query -D -d)" ] \
            && bspc desktop -f "$target" || bspc desktop -f last.local
          super + shift + {1-9,0}
            bspc node -d '^{1-9,10}'

          # Focus the node in the given direction.
          super + {n,e,i,o}
            bspc node -f {west,south,north,east}
          super + {Left,Down,Up,Right}
            bspc node -f {west,south,north,east}

          # Swap focused window with the one in the given direction.
          super + shift + {n,e,i,o}
            bspwm_smart_move {west,south,north,east}
          super + shift + {Left,Down,Up,Right}
            bspwm_smart_move {west,south,north,east}

          # Expand or contract node in the given direction.
          super + alt + {n,e,i,o}
            bspwm_resize {west,south,north,east} 50
          super + alt + {Left,Down,Up,Right}
            bspwm_resize {west,south,north,east} 50

          # Preselect the direction or insert again to cancel the preselection.
          # This enters the manual tiling mode that splits the currently focused
          # window.
          super + ctrl + {n,e,i,o}
            bspc node --presel-dir '~{west,south,north,east}'
          super + ctrl + {Left,Down,Up,Right}
            bspc node --presel-dir '~{west,south,north,east}'

          # Preselect the ratio.  The default value is 0.5, defined in `bspwmrc`.
          super + ctrl + {1-9}
            bspc node -o 0.{1-9}

          # Resize by preselection
          super + alt + {1-9}
            ~/.dotfiles/bin/bspwm/presel 0.{1-9}

          # Rotate all windows {counter-}clockwise by 90 degrees.
          super + {_,shift + }r
            bspc node @/ --rotate {90,-90}

          # Dynamic gaps.
          super + shift + bracket{left,right}
            bspc config -d focused window_gap "$(($(bspc config -d focused window_gap) {-,+} 5 ))"

          #
          ## Media keys

          # screenshot region
          Print
            scrcap

          XF86AudioLowerVolume
            amixer -q set Master 10%- unmute

          XF86AudioMute
            amixer -q set Master toggle

          XF86AudioNext
            spt-send next

          XF86AudioPrev
            spt-send prev

          XF86AudioRaiseVolume
            amixer -q set Master 10%+ unmute

          XF86Audio{Play,Pause}
            spt-send toggle

          XF86MonBrightnessDown
            light -U 5

          XF86MonBrightnessUp
            light -A 5

          F12
            ${pkgs.my.tdrop}/bin/tdrop -ma --wm bspwm -w -24 -x 9 -y 32 -s dropdown alacritty

          ctrl + F12
            # ${pkgs.my.tdrop}/bin/tdrop -ma --wm bspwm -w 50% -h 50% -x 25% -y 25% emacsclient --eval "(emacs-everywhere)"
            bspc rule -a "Emacs:*" -o state=floating sticky=on && emacsclient --eval "(emacs-everywhere)"
        '';
      };
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
          monitor = 0;
          follow = "mouse";
          geometry = "300x50-15+49";
          indicate_hidden = true;
          shrink = false;
          transparency = 20;
          notification_height = 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          frame_width = 3;
          frame_color = "#aaaaaa";
          separator_color = "frame";
          sort = true;
          idle_threshold = 120;
          # font = "Helvetica Neue LT Std,HelveticaNeueLT Std Lt Cn:style=47 Light Condensed,Regular";
          line_height = 0;
          markup = "full";
          format = "<b>%s</b>\n%b";
          alignment = "center";
          show_age_threshold = 60;
          word_wrap = true;
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;
          icon_position = "left";
          max_icon_size = 75;
          sticky_history = true;
          history_length = 20;
          dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst:";
          browser = "${pkgs.firefox}/bin/firefox -new-tab";
          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          startup_notification = false;
          force_xinerama = false;
        };
        experimental = {
          per_monitor_dpi = false;
        };
        shortcuts = {
          close = "mod4+grave"; # mod1 is alt
          close_all = "mod4+shift+grave"; # mod4 is super
          history = "mod1+mod4+grave"; # ` is grave
          context = "ctrl+mod4+grave"; # . is period
        };
        urgency_low = {
          background = "#222222";
          foreground = "#888888";
          timeout = 10;
        };
        urgency_normal = {
          background = "#285577";
          foreground = "#ffffff";
          timeout = 10;
        };
        urgency_critical = {
          background = "#900000";
          foreground = "#ffffff";
          frame_color = "#ff0000";
          timeout = 10;
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
                        bspc rule -a '*:scratch' state=floating sticky=on center=on border=off rectangle=1000x800+0+0
                      '';
        monitors = {
          eDP1 = [ "1" "2" "3" "4" "5"];
          eDP-1 = [ "1" "2" "3" "4" "5"];
          eDP-1-1 = [ "1" "2" "3" "4" "5"];
          HDMI-0 = [ "6" "7" "8" "9" "0"];
        };
        rules = {
          Pinentry = { state = "floating"; center = true; };
          "Emacs:org*" = { state = "floating"; };
          "Emacs:scratch" = { state = "floating"; };
          "Emacs:emacs-everywhere" = { state = "floating"; sticky = true; };
          Emacs = { state = "tiled"; };
          feh = { state = "fullscreen"; };
        };
        settings = {
          normal_border_color = "#44475a";
          # active_border_color = "#bd93f9";
          # focused_border_color = "#ff79c6";
          active_border_color = "#6272a4";
          focused_border_color = "#8be9fd";
          presel_feedback_color = "#6272a4";

          # normal_border_color = "#F9F9F9";
          # active_border_color = "#CCFF00";
          # focused_border_color = "#00CCFF";
          # presel_feedback_color = "#FFCC33";

          initial_polarity = "first_child";

          remove_unplugged_monitors = true;
          remove_disabled_monitors = true;
          border_width = 3;

          window_gap      = 10;
          top_padding     = 22;
          left_padding    = -10;
          right_padding   = -10;
          bottom_padding  = -10;
          top_monocle_padding     = 10;
          left_monocle_padding    = 10;
          right_monocle_padding   = 10;
          bottom_monocle_padding  = 10;

          split_ratio = 0.5;
          borderless_monocle = false;
          gapless_monocle = true;
          single_monocle = true;

          focus_follows_pointer = true;
          pointer_follows_monitor = true;
        };
        startupPrograms = [
          "pkill sxhkd; while pgrep -u $UID -x sxhkd >/dev/null; do sleep 1; done && sxhkd -m 1"
          "pkill polybar; while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done && ( \
          for i in /sys/class/hwmon/hwmon*/temp*_input; do \
              if [ \"$(<$(dirname $i)/name): $(cat $\{i%_*}_label 2>/dev/null || echo $(basename $\{i%_*}))\" = \"coretemp: Package id 0\" ]; then \
                  export HWMON_PATH=\"$i\" \
              fi \
          done \
          for monitor in $(xrandr -q | grep -w connected | awk '{print $1}'); do \
          if [ $(xrandr -q | grep primary | awk '{print $1}') == $monitor ]; then \
            MONITOR=$monitor polybar top-tray & \
          else \
            MONITOR=$monitor polybar top & \
          fi \
          done )"
        ];
      };

      # Setup cursor
      pointerCursor = {
        package = pkgs.gnome3.adwaita-icon-theme;
        name = "Adwaita";
        size = system.cursorSize * system.scale;
      };
    };

  }) cfg;
}
