{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) system;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) flatten;

  iceLib = config.icebox.static.lib;
  lock = "${pkgs.i3lock}/bin/i3lock -c 000000";

  rofi-power-menu = pkgs.stdenv.mkDerivation rec {
    pname = "rofi-power-menu";
    version = "2.4.0";

    src = pkgs.fetchFromGitHub {
      owner = "jluttine";
      repo = pname;
      rev = version;
      sha256 = "1cfk6sapbaczk6viczp6ay4kfah5vx6vssa7x8d0vwblk4xxp44l";
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

    # Rofi
    programs.rofi = {
      enable = true;
      font = "Fira Code 10";
      theme = "glue_pro_blue";
      extraConfig = ''
        rofi.show-icons: true
        rofi.dpi: ${toString (system.scale * system.dpi)}
      '';
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

      # Enable i3
      windowManager.i3 = let
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
        config = {
          terminal = "alacritty";

          fonts = [ "Fira Code Regular 10" ];

          colors.focused = {
            background = "#1febfd"; # Azure
            border = "#1febfd";
            childBorder = "#1febfd";
            indicator =
              "#2ff923"; # The side that the next window is gonna to open.
            text = "#000000"; # Dark
          };

          modes = {
            resize = {
              l = "resize grow height 2 px or 2 ppt";
              k = "resize shrink height 2 px or 2 ppt";
              semicolon = "resize grow width 2 px or 2 ppt";
              j = "resize shrink width 2 px or 2 ppt";
              Escape = "mode default";
              Return = "mode default";
            };
          };

          gaps = {
            smartGaps = true;
            smartBorders = "on";
            inner = 5;
            outer = 5;
          };

          bars = [ ]; # We don't need i3bars

          startup = [{
            command = "systemctl --user restart polybar";
            always = true;
            notification = false;
          }];

          # Set up app specific workspaces and floating rules.
          window.commands = with ws-names;
            let
              # Meta function that could accept { foo = ["bar" "bar1"]; foo1 = ["bar2"] };
              makeScheme = makeItem: scheme:
                flatten (mapAttrsToList
                  (ws: classes: (map (class: makeItem ws class) classes))
                  scheme);

              moveToWorkspaceByClass = makeScheme (ws: class: {
                command = "move workspace ${ws}";
                criteria = { class = class; };
              });

              makeWindowFloating = makeScheme (key: value: {
                command = "floating enable";
                criteria = { ${key} = value; };
              });
            in (moveToWorkspaceByClass {
              # Assign specific apps to specific workspace
              ${web} = [ "^Firefox$" "^Tor Browser$" ];
              ${chat} = [ "^TelegramDesktop$" ];
              ${editing} = [ "^Emacs$" ];
              ${gaming} = [ "^Steam$" "(?i)minecraft" ];
              ${zoom} = [ "^zoom$" ];
            }) ++ (makeWindowFloating {
              # Make apps meet the criteria floating (meet any one of these would go)
              class = [ "^Pavucontrol$" ];
              window_role = [ "About" "pop-up" ];
            });

          # Don't conflict with emacs
          modifier = "Mod4";

          keybindings = let
            modifier =
              config.home-manager.users.${name}.xsession.windowManager.i3.config.modifier;
          in lib.mkOptionDefault {
            # Setup multimedia keys
            "XF86MonBrightnessUp" = " exec --no-startup-id light -A 5";
            "XF86MonBrightnessDown" = "exec --no-startup-id light -U 5";
            "XF86AudioRaiseVolume" =
              "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" =
              "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" =
              "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioMicMute" =
              "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";

            # Bring you home (toggle back to default)
            "${modifier}+q" = "layout default";

            # Shift focus
            "${modifier}+j" = "focus left";
            "${modifier}+k" = "focus down";
            "${modifier}+l" = "focus up";
            "${modifier}+semicolon" = "focus right";

            # Move windows around
            "${modifier}+Shift+j" = "move left";
            "${modifier}+Shift+k" = "move down";
            "${modifier}+Shift+l" = "move up";
            "${modifier}+Shift+semicolon" = "move right";

            # Cycle through the active workspaces
            "${modifier}+n" = "workspace prev";
            "${modifier}+p" = "workspace next";
            "${modifier}+Tab" =
              "workspace back_and_forth"; # Switch back to previously focused workspace

            # Screenlocker
            "${modifier}+Control+n" = "exec --no-startup-id ${lock}";

            # Turn on/off Do Not Disturb
            "${modifier}+Control+m" = ''
              exec --no-startup-id "notify-send \\"DUNST_COMMAND_TOGGLE\\""
            '';

            # Rofi run by zsh because we need environments
            "${modifier}+d" = ''
              exec --no-startup-id "zsh -c 'rofi -combi-modi window,drun -show combi -modi combi'"'';
            "Control+Mod1+Delete" = ''
              exec --no-startup-id "zsh -c 'rofi -show p -modi p:${rofi-power-menu}/bin/rofi-power-menu -matching fuzzy -show-icons -icon-theme Papirus-Dark -theme theme/appmenu.rasi'"'';

            # Screenshot
            "--release Shift+Print" =
              "exec escrotum -C"; # Screenshot the whole screen and copy to clipboard
            "--release Shift+Control+Print" =
              "exec escrotum -Cs"; # Screenshot a selected area and copy to clipboard
            "--release Control+Print" =
              "exec escrotum -s"; # Screenshot a selected area and save it.
            "--release Print" =
              "exec escrotum"; # Screenshot whole screen and save it.
          };
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
