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
        TERMINAL = "alacritty";
        GDK_SCALE = "${toString system.scale}";
        GDK_DPI_SCALE = "${toString (1.0 / system.scale)}";
        QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      };

      home.packages = with pkgs; [
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
        nixos-unstable.ripcord
        nixos-unstable.bottom
        qtpass
        (pass.withExtensions (p: [ p.pass-import ]))
        # (pkgs.pass.withExtensions (exts: [ exts.pass-otp ]))
        gnome3.seahorse
        lazydocker
        keepassxc
        glava
        meld
        my.worker
        (nixos-unstable.vscode-with-extensions.override {
           vscodeExtensions = with nixos-unstable.vscode-extensions; [
             # bbenoist.Nix
             jnoortheen.nix-ide
             vscodevim.vim
             coenraads.bracket-pair-colorizer-2
             formulahendry.auto-close-tag
             formulahendry.auto-rename-tag
             golang.Go
             ibm.output-colorizer
             mechatroner.rainbow-csv
             ms-azuretools.vscode-docker
             ms-vscode-remote.remote-ssh
             ms-vscode.cpptools
             naumovs.color-highlight
             tyriar.sort-lines
             vincaslt.highlight-matching-tag
           ];
        })
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

          font.name = "Iosevka Term";

          settings = {
            bold_font        = "auto";
            italic_font      = "auto";
            bold_italic_font = "auto";

            font_size = "11.0";

            scrollback_lines = "10000";

            background_opacity = "0.8";

            # dark
            background = "#000000";
            foreground = "#ffffff";
            cursor = "#586e75";

            selection_background = "#555753";
            # selection_foreground = "#eae3cb";

            color0 = "#2e3436";
            color8 = "#555753";

            color1 = "#cc0000";
            color9 = "#ef2929";

            color2 = "#4e9a06";
            color10 = "#8ae234";

            color3 = "#c4a000";
            color11 = "#fce94f";

            color4 = "#3465a4";
            color12 = "#729fcf";

            color5 = "#75507b";
            color13 = "#ad7fa8";

            color6 = "#06989a";
            color14 = "#34e2e2";

            color7 = "#d3d7cf";
            color15 = "#eeeeec";

            # light
            # background = "#fdf6e3";
            # foreground = "#657b83";
            # cursor = "#586e75";

            # selection_background = "#475b62";
            # selection_foreground = "#eae3cb";

            # color0 = "#073642";
            # color8 = "#002b36";

            # color1 = "#dc322f";
            # color9 = "#cb4b16";

            # color2 = "#859900";
            # color10 = "#586e75";

            # color3 = "#b58900";
            # color11 = "#657b83";

            # color4 = "#268bd2";
            # color12 = "#839496";

            # color5 = "#d33682";
            # color13 = "#6c71c4";

            # color6 = "#2aa198";
            # color14 = "#93a1a1";

            # color7 = "#eee8d5";
            # color15 = "#fdf6e3";
          };

          keybindings = {
            "ctrl+insert" = "copy_to_clipboard";
            "shift+insert" =    "paste_from_clipboard";

            "ctrl+enter"  =       "new_window";
            "ctrl+backspace"  =   "close_window";
            "ctrl+delete"  =      "close_window";
            "ctrl+pagedown"  =    "next_window";
            "ctrl+pageup"  =      "previous_window";

            "ctrl+f" =           "goto_layout stack";
            "ctrl+escape" =      "last_used_layout";

            "alt+enter" =         "new_tab";
            "alt+backspace" =     "close_tab";
            "alt+delete" =        "close_tab";
            "alt+pagedown" =      "next_tab";
            "alt+pageup" =        "previous_tab";
          };
        };
        alacritty = {
          enable = true;
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
            background_opacity = 0.9;
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
      services.syncthing.enable = true;
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
          rev    = "ca0d05cf2b7e5c37104c6ad1a3f5378b72c705db";
          sha256 = "0ywkf2bzxkr45a0nmrmb2j3pp7igx6qvq6ar0kk7d5wigmkr9m5n";
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
          # name    = "Adementary-dark";
          # package = pkgs.adementary-theme;
          # name    = "Ant-Dracula";
          # package = pkgs.ant-dracula-theme;
          name    = "Materia-dark-compact";
          package = pkgs.materia-theme;
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
