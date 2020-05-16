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
        my.ripcord
        ytop
        qtpass
        (pass.withExtensions (p: [ p.pass-import ]))
        # (pkgs.pass.withExtensions (exts: [ exts.pass-otp ]))
        gnome3.seahorse
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
        };
      };

      # Package settings
      programs = {
        alacritty = {
          enable = true;
          settings = {
            font = {
              normal = {
                family = "Fira Code";
                style = "Regular";
              };
              size = 7.0;
            };
            env = { WINIT_HIDPI_FACTOR = toString system.scale; };
          };
        };

        # enhances zsh (C-r: history search C-t: file search M-c: change directory)
        fzf = {
          enable = true;
          changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
          # defaultCommand = "rg --files --no-ignore --hidden --follow --glob \"!.git\"";
          defaultCommand = "${pkgs.fd}/bin/fd --type f";
        };

        direnv.enable = true;
        direnv.stdlib = ''
          use_nix() {
            eval "$(lorri direnv)"
          }
      '';

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

      services.lorri.enable = true;

      # Handwritten configs
      home.file = {
        # ".config/gtk-3.0/settings.ini".source = (system.dirs.dotfiles + "/${name}/gtk-settings.ini");
      };

      home.keyboard = {
        layout = "us,tr";
        options = [ "ctrl:nocaps" "grp:rctrl_toggle" ];
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
          "XTerm.vt100.faceName"    = "Hack Nerd Font Mono:size=10";
          "XTerm*decTerminalID"     = "vt340";
          "XTerm*numColorRegisters" = 256;
        };
      };

      # GTK theme configs
      gtk = {
        enable = true;
        # font = {
        #   name    = "Cantarell 11";
        #   package = pkgs.cantarell-fonts;
        # };
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
