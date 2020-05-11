{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) system devices;
  iceLib = config.icebox.static.lib;
in {
  options.icebox.static.users.ahmetde = with lib;
    mkOption {
      type = with types;
        attrsOf (submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = false;
              example = true;
              description = "Whether to enable user <literal>ahmet</literal>.";
            };

            extraPackages = mkOption {
              type = with types; listOf package;
              description =
                "Extra packages to install for user <literal>ahmet</literal>.";
            };
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

  config.home-manager.users = iceLib.functions.mkUserConfigs' (name: cfg: {
    # Home-manager settings.
    # User-layer packages
    home.packages = with pkgs;
      [
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
      ] ++ cfg.extraPackages;

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

    xsession.scriptPath = ".xsession-hm";
    xsession.numlock.enable = true;

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
      # GnuPG
      gpg = {
        enable = true;
        settings = { throw-keyids = false; };
      };

      # Git
      git = {
        enable = true;
        userName = "Ahmet Cemal Özgezer";
        userEmail = "ahmet.ozgezer@andasis.com";
        # signing = {
        #   signByDefault = true;
        #   key = "0xAE53B4C2E58EDD45";
        # };
        extraConfig = { credential = { helper = "store"; }; };
      };

      # enhances zsh (C-r: history search C-t: file search M-c: change directory)
      fzf = {
        enable = true;
        changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
        # defaultCommand = "rg --files --no-ignore --hidden --follow --glob \"!.git\"";
        defaultCommand = "${pkgs.fd}/bin/fd --type f";
      };

      # zsh
      zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        autocd = true;
        dotDir = ".config/zsh";
        initExtra = '' prompt off '';
        # NOTE: We don't use the sessionVar option provided by home-manager, because the former one only make it available in zshrc. We need env vars everywhere.
        # GDK_SCALE: Scale the whole UI for GTK applications
        # GDK_DPI_SCALE: Scale the fonts back for GTK applications to avoid double scaling
        # QT_AUTO_SCREEN_SCALE_FACTOR: Let QT auto detect the DPi
        envExtra = ''
          export GDK_SCALE=${toString system.scale}
          export GDK_DPI_SCALE=${toString (1.0 / system.scale)}
          export QT_AUTO_SCREEN_SCALE_FACTOR=1
        '';
        profileExtra =
          ''
          if [ -d "$HOME/.local/bin" ]; then
             export PATH="$PATH:$HOME/.local/bin"
          fi
          if [ -d "$HOME/.emacs.d/doom/bin" ]; then
             export PATH="$PATH:$HOME/.emacs.d/doom/bin"
          fi
        '';
        defaultKeymap = "emacs";
        oh-my-zsh = {
          enable = true;
          plugins = [
            ## appearence
            "common-aliases"

            "extract"

            ## programs
            "git"
            "pass"

            "gitignore"
            "sudo"
          ];
          # theme = "agnoster";
        };
        plugins = [
          {
            name = "zsh-syntax-highlighting";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-syntax-highlighting";
              rev = "0.7.0-beta1";
              sha256 = "0xk9fwii31zrwvhd441p3c0cr7lqhf97fqif3nys4wkgnvhd5s4x";
            };
          }
        ];
      };

      direnv.enable = true;

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

    # Handwritten configs
    home.file = {
      # ".config/gtk-3.0/settings.ini".source = (system.dirs.dotfiles + "/${name}/gtk-settings.ini");
    };

    # home.keyboard = null;
    # home.keyboard = {
    #   # options = [ "caps:escape" "esperanto:colemak" ];
    #   variant = "colemak";
    # };
    home.keyboard = {
      layout = "us,tr";
      # options = [ "ctrl:swapcaps" "compose:prsc" "grp:rctrl_toggle" ];
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

    # Dconf settings
    # dconf.settings = {
    #   "desktop/ibus/general/hotkey" = {
    #     triggers = [ "<Control><Shift>space" ];
    #   };
    # };
  }) config.icebox.static.users.ahmetde;
}
