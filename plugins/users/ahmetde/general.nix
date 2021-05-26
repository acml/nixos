{ config, pkgs, lib, ... }:

with lib;

let
  inherit (config.icebox.static.lib.configs.system) dpi scale cursorSize;
  inherit (config.icebox.static.lib.configs) system devices;
  iceLib = config.icebox.static.lib;
  cfg = config.icebox.static.users.ahmetde;
in {
  options.icebox.static.users.ahmetde = with lib;
    mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption
            "the Desktop Environment flavoured by ahmet"; # If this is off, nothing should be configured at all.

          configs = mkOption {
            type = with types;
              attrsOf (submodule {
                options = {
                  enable = mkEnableOption
                    "the Desktop Environment flavoured by ahmet for certain user";
                  battery = mkOption {
                    type = types.enum devices.battery;
                    description =
                      "Battery name under <literal>/sys/class/power_supply/</literal> used by polybar <literal>battery</literal> module. Choose one in <option>options.icebox.devices.battery</option>";
                  };

                  power = mkOption {
                    type = types.enum devices.power;
                    description =
                      "AC power adapter name under <literal>/sys/class/power_supply/</literal> used by polybar <literal>battery</literal> module. Choose one in <option>options.icebox.devices.power</option>";
                  };

                  network-interface = mkOption {
                    type = types.enum devices.network-interface;
                    description = "Network interface name to monitor on bar";
                  };
                };
              });

            default = { };
          };
        };
      };
      default = { };
    };

  config = mkIf cfg.enable {
    services.xserver = {
      dpi = dpi * scale;

      desktopManager.session = [{
        name = "home-manager";
        bgSupport = true;
        start = ''
              ${pkgs.stdenv.shell} $HOME/.xsession-hm &
              waitPID=$!
              '';
      }];

      displayManager = {
        # LightDM display manager
        lightdm = {
          enable = true;
          greeters.gtk = {
            # Set cursor size
            cursorTheme.size = cursorSize * scale;
            # Use dark theme
            theme.name = "Adwaita-dark";
          };
        };
        # Startup commands
        # sessionCommands = ''
        #   ibus-daemon -drx
        # '';
      };
    };
    programs.light.enable = true;
    programs.dconf.enable = true;
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    home-manager.users = iceLib.functions.mkUserConfigs' (n: c: {

      xsession.numlock.enable = true;
      xsession.scriptPath = ".xsession-hm";

      # NOTE: We don't use the sessionVar option provided by home-manager, because the former one only make it available in zshrc. We need env vars everywhere.
      # GDK_SCALE: Scale the whole UI for GTK applications
      # GDK_DPI_SCALE: Scale the fonts back for GTK applications to avoid double scaling
      # QT_AUTO_SCREEN_SCALE_FACTOR: Let QT auto detect the DPi
      home.sessionVariables = {
        BROWSER = "firefox";
        TERMINAL = "kitty";
        GDK_SCALE = "${toString system.scale}";
        GDK_DPI_SCALE = "${toString (1.0 / system.scale)}";
        QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      };

      home.packages = with pkgs.nixos-unstable; [
        i3lock-color
        xss-lock
        xautolock
        escrotum
        dmenu
        libnotify
        gnome3.file-roller
        gnome3.nautilus
        gnome3.eog
        evince    # pdf reader
        feh       # image viewer
        mpv       # video player
        font-manager
        libreoffice
        minicom
        my.sunflower
        # nixos-unstable.ripcord
        my.ripcord
        tdesktop
        nixos-unstable.bottom
        gnome3.seahorse
        nixos-unstable.lazydocker
        nixos-unstable.bitwarden
        # nixos-unstable.bitwarden-cli
        # nixos-unstable.rbw
        # nur.repos.reedrw.bitwarden-rofi-patched
        glava
        meld
        my.worker
        parted
        inetutils
        exercism
      ];

      # HACK Without this config file you get "No pinentry program" on 20.03.
      #      program.gnupg.agent.pinentryFlavor doesn't appear to work, and this
      #      is cleaner than overriding the systemd unit.
      xdg.configFile."gnupg/gpg-agent.conf" = {
        text = ''
          enable-ssh-support
          allow-emacs-pinentry
          default-cache-ttl 1800
          pinentry-program ${pkgs.pinentry.gtk2}/bin/pinentry
        '';
      };

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "image/jpeg" = "eog.desktop"; # `.jpg`
          "application/pdf" = "org.gnome.Evince.desktop"; # `.pdf`
          "x-scheme-handler/mailto" = "thunderbird.desktop";
          "message/rfc822" = "thunderbird.desktop";
          "text/plain" = "emacs.desktop";
          "inode/directory" = "org.gnome.Nautilus.desktop";
        };
      };

      # Package settings
      programs = {
        kitty = {
          enable = true;

          settings = {
            # font_family       = "FiraCode Nerd Font Mono";
            # italic_font       = "auto";
            # bold_font         = "FiraCode Bold Nerd Font Complete Mono";
            # bold_italic_font  = "auto";

            # font_family      = "Iosevka Nerd Font Complete";
            # bold_font        = "Iosevka Bold Nerd Font Complete";
            # italic_font      = "Iosevka Italic Nerd Font Complete Mono";
            # bold_italic_font = "Iosevka Bold Italic Nerd Font Complete";

            font_family      = "Iosevka Term Nerd Font Complete Mono";
            bold_font        = "Iosevka Bold Nerd Font Complete";
            italic_font      = "Iosevka Term Italic Nerd Font Complete";
            bold_italic_font = "Iosevka Term Bold Italic Nerd Font Complete Mono";

            # font_family       = "JetBrains Mono Regular Nerd Font Complete Mono";
            # italic_font       = "JetBrains Mono Italic Nerd Font Complete Mono";
            # bold_font         = "JetBrains Mono Bold Nerd Font Complete Mono";
            # bold_italic_font  = "JetBrains Mono Bold Italic Nerd Font Complete Mono";

            font_size = "11.5";

            adjust_line_height = "-1";
            scrollback_lines = "10000";

            # background_opacity = "0.8";

            # onedark
            # cursor = "#cccccc";

            # foreground = "#eeeeee";
            # background = "#282828";

            # color0 = "#282828";
            # color8 = "#484848";
            # color1 = "#f43753";
            # color9 = "#f43753";
            # color2  = "#c9d05c";
            # color10 = "#c9d05c";
            # color3  = "#ffc24b";
            # color11 = "#ffc24b";
            # color4  = "#b3deef";
            # color12 = "#b3deef";
            # color5  = "#d3b987";
            # color13 = "#d3b987";
            # color6  = "#73cef4";
            # color14 = "#73cef4";
            # color7  = "#eeeeee";
            # color15 = "#ffffff";

            # active_tab_foreground   = "#282828";
            # active_tab_background   = "#bbbbbb";
            # active_tab_font_style   = "bold";
            # inactive_tab_foreground = "#eeeeee";
            # inactive_tab_background = "#282828";
            # inactive_tab_font_style = "normal";

            # # selection_foreground = "#282c34";
            # # selection_background = "#979eab";

            # gruvbox dark
            background  = "#282828";
            foreground  = "#ebdbb2";

            cursor                = "#928374";

            selection_foreground  = "#928374";
            selection_background  = "#3c3836";

            color0  = "#282828";
            color8  = "#928374";

            color1                = "#cc241d";
            color9                = "#fb4934";

            color2                = "#98971a";
            color10               = "#b8bb26";

            color3                = "#d79921";
            color11               = "#fabd2d";

            color4                = "#458588";
            color12               = "#83a598";

            color5                = "#b16286";
            color13               = "#d3869b";

            color6                = "#689d6a";
            color14               = "#8ec07c";

            color7                = "#a89984";
            color15               = "#928374";

            # gruvbox light
            # background  = "#fbf1c7";
            # foreground  = "#3c3836";

            # cursor                = "#928374";

            # selection_foreground  = "#3c3836";
            # selection_background  = "#928374";

            # color0  = "#fbf1c7";
            # color8  = "#282828";

            # color1                = "#cc241d";
            # color9                = "#9d0006";

            # color2                = "#98971a";
            # color10               = "#79740e";

            # color3                = "#d79921";
            # color11               = "#b57614";

            # color4                = "#458588";
            # color12               = "#076678";

            # color5                = "#b16286";
            # color13               = "#8f3f71";

            # color6                = "#689d6a";
            # color14               = "#427b58";

            # color7                = "#7c6f64";
            # color15               = "#928374";
          };

          extraConfig = ''
            # symbol_map U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00D,U+E0A3,U+E0B4-U+E0C8,U+E0CC-U+E0D2,U+E0D4,U+E200-U+E2A9,U+E300-U+E3EB,U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+F27C,U+F300-U+F313,U+F400-U+F4A8,U+F500-U+FD46 BlexMono Nerd Font Bold

            # # Map the specified unicode codepoints to a particular font. Useful
            # # if you need special rendering for some symbols, such as for
            # # Powerline. Avoids the need for patched fonts. Each unicode code
            # # point is specified in the form U+<code point in hexadecimal>. You
            # # can specify multiple code points, separated by commas and ranges
            # # separated by hyphens. symbol_map itself can be specified multiple
            # # times. Syntax is::
            # #     symbol_map codepoints Font Family Name
            # #
            # # See https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
            # # Seti-UI + Custom
            # symbol_map U+E5FA-U+E62B Iosevka Term
            # # Devicons
            # symbol_map U+E700-U+E7C5 Iosevka Term
            # # Font Awesome
            # symbol_map U+F000-U+F2E0 Iosevka Term
            # # Font Awesome Extension
            # symbol_map U+E200-U+E2A9 Iosevka Term
            # # Material Design Icons
            # symbol_map U+F500-U+FD46 Iosevka Term
            # # Weather
            # symbol_map U+E300-U+E3EB Iosevka Term
            # # Octicons
            # symbol_map U+F400-U+F4A8,U+2665,U+26A1,U+F27C Iosevka Term
            # # Powerline Extra Symbols
            # symbol_map U+E0A3,U+E0B4-U+E0C8,U+E0CC-U+E0D2,U+E0D4 Iosevka Term
            # # IEC Power Symbols
            # symbol_map U+23FB-U+23FE,U+2b58 Iosevka Term
            # # Font Logos
            # symbol_map U+F300-U+F313 Iosevka Term
            # # Pomicons
            # symbol_map U+E000-U+E00D Iosevka Term
          '';

          # keybindings = {
          #   "ctrl+insert" = "copy_to_clipboard";
          #   "shift+insert" =    "paste_from_clipboard";

          #   "ctrl+enter"  =       "new_window";
          #   "ctrl+backspace"  =   "close_window";
          #   "ctrl+delete"  =      "close_window";
          #   "ctrl+pagedown"  =    "next_window";
          #   "ctrl+pageup"  =      "previous_window";

          #   "ctrl+f" =           "goto_layout stack";
          #   "ctrl+escape" =      "last_used_layout";

          #   "alt+enter" =         "new_tab";
          #   "alt+backspace" =     "close_tab";
          #   "alt+delete" =        "close_tab";
          #   "alt+pagedown" =      "next_tab";
          #   "alt+pageup" =        "previous_tab";
          # };
        };

        alacritty = {
          enable = true;
          package = pkgs.nixos-unstable.alacritty;
          settings = {
            font = {
              normal = {
                family = "Iosevka Term";
                style = "Regular";
              };
              bold = {
                family = "Iosevka Term";
                style = "Bold";
              };
              italic = {
                family = "Iosevka Term";
                style = "Italic";
              };
              bold_italic = {
                family = "Iosevka Term";
                style = "Bold Italic";
              };
              size = 12.0;
            };
            env = {
              # TERM = "xterm-256color";
              WINIT_X11_SCALE_FACTOR = toString system.scale;
            };
            # background_opacity = 0.9;
            scrolling = {
              history = 100000;
            };
          };
        };

        ssh = {
          enable = true;
          controlMaster = "auto";
          controlPersist = "10m";
          matchBlocks = {
            "sw" = {
              hostname = "10.0.0.1";
              user = "root";
            };
          };
        };

        # enhances zsh (C-r: history search C-t: file search M-c: change directory)
        skim = {
          enable = true;
          defaultCommand = "${pkgs.fd}/bin/fd -L -tf";
          defaultOptions = [ "--height 100%" "--prompt ⟫" "--bind '?:toggle-preview,ctrl-o:execute-silent(xdg-open {})'"];
          fileWidgetCommand = "${pkgs.fd}/bin/fd -L -tf";
          fileWidgetOptions = [ "--preview '${pkgs.bat}/bin/bat --color=always --style=header,grid,numbers --line-range :300 {}'" ];
          changeDirWidgetCommand = "${pkgs.fd}/bin/fd -L -td";
          changeDirWidgetOptions = [ "--preview '${pkgs.tree}/bin/tree -C {} | head -200'" ];
        };

        direnv.enable = true;
        direnv.stdlib = ''
          use_nix() {
          eval "$(lorri direnv)"
          }
        '';

        zsh.initExtra = ''
                        if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
                         eval "$(${pkgs.starship}/bin/starship init zsh)"
                        fi
                        '' + "\n" + readFile (system.dirs.dotfiles + "/${n}/emacs-vterm-zsh.sh");

        starship = {
          enable = true;
          settings = {
            # aws.disabled = true;
            # battery.disabled = true;
            # cmd_duration.disabled = true;
            # conda.disabled = true;
            # dotnet.disabled = true;
            # env_var.disabled = true;
            # git_branch.disabled = true;
            # git_commit.disabled = true;
            # git_state.disabled = true;
            git_status = {
              disabled = true;
            };
            # golang.disabled = true;
            # hg_branch.disabled = true;
            java.disabled = true;
            # kubernetes.disabled = true;
            # memory_usage.disabled = true;
            # nodejs.disabled = true;
            # package.disabled = true;
            # php.disabled = true;
            # python.disabled = true;
            # ruby.disabled = true;
            # rust.disabled = true;
            # terraform.disabled = true;
            # time.disabled = true;
          };
        };

        vscode.enable = true;
        vscode.package = pkgs.nixos-unstable.vscode-fhsWithPackages (ps: with ps; [ git rustup zsh zlib ]);
      };

      services.grobi = {
        enable = true;
        executeAfter = [ "${pkgs.bspwm}/bin/bspc wm -r" ];
        rules = [
          {
            name = "Home";
            outputs_connected = [
              "eDP-1-1"
              "HDMI-0-SAM-1316-1279341106-SyncMaster-H1AK500000" ];
            configure_row = [ "eDP-1-1" "HDMI-0" ];
            primary = "eDP-1-1";
            atomic = true;
          }
          {
            name = "Office";
            outputs_connected = [
              "eDP-1-1"
              "HDMI-0-ACR-1406-2233467840-SA230-T91EE0012410" ];
            configure_row = [ "eDP-1-1" "HDMI-0" ];
            primary = "eDP-1-1";
            atomic = true;
          }
          {
            name = "Office-2";
            outputs_connected = [
              "eDP-1-1"
              "HDMI-0-ACR-1406-2435846283-SA230-T91EE0012410" ];
            configure_row = [ "eDP-1-1" "HDMI-0" ];
            primary = "eDP-1-1";
            atomic = true;
          }
          {
            name = "Fallback";
            configure_single = "eDP-1-1";
            primary = "eDP-1-1";
            atomic = true;
          }
        ];
      };

      services.lorri.enable = true;
      # services.owncloud-client.enable = true;
      # services.syncthing.enable = true;
      # services.syncthing.tray = true;
      # services.kdeconnect.enable = true;
      # services.kdeconnect.indicator = true;

      # Handwritten configs
      home.file = {
        # ".config/gtk-3.0/settings.ini".source = (system.dirs.dotfiles + "/${name}/gtk-settings.ini");
        ".docker/config.json".text = ''
            {
              "detachKeys": "ctrl-],]"
            }
        '';
      };

      home.keyboard = {
        layout = "us,tr";
        options = [ "ctrl:nocaps" "grp:ctrls_toggle" ];
        variant = "colemak,";
      };

      systemd.user.startServices = true;

      xresources = {
        extraConfig = builtins.readFile (pkgs.fetchFromGitHub {
          owner  = "dracula";
          repo   = "xresources";
          rev    = "8de11976678054f19a9e0ec49a48ea8f9e881a05";
          sha256 = "12wmjynk0ryxgwb0hg4kvhhf886yvjzkp96a5bi9j0ryf3pc9kx7";
        } + "/Xresources");
        properties = {
          # Everything
          # "*.font" = "Hack Nerd Font:pixelsize=13:antialias=true:autohint=true";
          # XTerm stuff
          "XTerm.termName"          = "xterm-256color";
          "XTerm.vt100.faceName"    = "Iosevka Term:size=12";
          "XTerm*decTerminalID"     = "vt340";
          "XTerm*numColorRegisters" = 256;
        };
      };

      # GTK theme configs
      gtk = {
        enable = true;
        font = {
        #   name    = "Cantarell 11";
        #   package = pkgs.cantarell-fonts;
          package = pkgs.roboto;
          name = "Roboto 11";
        };
        iconTheme = {
          # name    = "Paper";
          # package = pkgs.paper-icon-theme;
          name    = "Papirus";
          package = pkgs.papirus-icon-theme;
        };
        theme = {
          name    = "Dracula";
          package = pkgs.nixos-unstable.dracula-theme;
        };
        # gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
      };

      qt = {
        enable = false;
        platformTheme = "gtk";
      };

    }) cfg;
  };

  #  config.
}
