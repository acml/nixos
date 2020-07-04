;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   `(
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press `SPC f e R' (Vim style) or
     ;; `M-m f e R' (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     (auto-completion :variables
                      auto-completion-enable-help-tooltip t
                      auto-completion-enable-sort-by-usage t
                      auto-completion-enable-snippets-in-popup t)
     better-defaults
     bm
     (c-c++ :variables
            c-c++-adopt-subprojects t
            c-c++-backend 'lsp-ccls
            ;; c-c++-lsp-enable-semantic-highlight 'rainbow
            c-c++-default-mode-for-headers 'c-mode)
     (cmake :variables cmake-enable-cmake-ide-support t)
     ;; (colors :variables colors-colorize-identifiers 'all)
     colors
     csv
     (elfeed :variables rmh-elfeed-org-files (list "~/.emacs.d/private/elfeed.org"))
     emacs-lisp
     epub
     (erc :variables
          erc-autojoin-channels-alist '(("freenode.net" "#emacs" "#guix" "#i3")
                                        ("gitter.im" "#syl20bnr/spacemacs"))
          erc-enable-notifications nil
          erc-enable-sasl-auth t
          erc-hide-list '("JOIN" "PART" "QUIT")
          erc-server-list '(("irc.freenode.net"
                             :port "6667"
                             :nick "aaccmmll")
                            ("irc.gitter.im"
                             :port "6667"
                             :ssl t
                             :nick "acml")))
     git
     gtags
     (helm :variables
           helm-position 'bottom
           helm-enable-auto-resize t)
     helpful
     html
     ;; (ivy :variables ivy-enable-advanced-buffer-information t)
     javascript
     ;; (keyboard-layout :variables kl-layout 'colemak-hnei)
     ;; (keyboard-layout :variables kl-layout 'colemak-jkhl)
     (lsp :variables
          lsp-enable-indentation nil
          lsp-ui-doc-enable nil)
     lua
     markdown
     (mu4e :variables
           mu4e-enable-async-operations t
           mu4e-enable-mode-line t
           mu4e-enable-notifications t
           ;; mu4e-use-maildirs-extension t
           )
     multiple-cursors
     nginx
     nixos
     org
     ,(when (eq system-type 'darwin) 'osx)
     pass
     pdf
     perl5
     php
     python
     ranger
     rebox
     ruby
     rust
     scheme
     search-engine
     ;; semantic
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom
            shell-default-shell 'vterm
            shell-enable-smart-eshell t)
     shell-scripts
     (slack :variables
            slack-spacemacs-layout-name "@Slack"
            slack-spacemacs-layout-binding "s")
     (spacemacs-layouts :variables spacemacs-layouts-restrict-spc-tab t)
     spell-checking
     ;; sql
     syntax-checking
     systemd
     (treemacs :variables
               treemacs-use-scope-type 'Perspectives)
     version-control
     vimscript
     ;; (vinegar :variables vinegar-reuse-dired-buffer t)
     windows-scripts
     yaml
     )

   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   ;; To use a local version of a package, use the `:location' property:
   ;; '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages
   '(
     beacon
     beginend
     charmap
     (declutter :location (recipe :fetcher github :repo "sanel/declutter"))
     diredfl
     dired-filter
     dired-git-info
     dired-hacks-utils
     dired-quick-sort
     ;; dired-rainbow
     (dired-show-readme :location (recipe :fetcher gitlab :repo "kisaragi-hiu/dired-show-readme"))
     dired-subtree
     direnv
     disk-usage
     docker
     docker-tramp
     dts-mode
     hackernews
     (helm-treemacs-icons :location (recipe :fetcher github :repo "yyoncho/helm-treemacs-icons"))
     ;; highlight-indent-guides
     (i3wm-config-mode :location (recipe :fetcher github :repo "Alexander-Miller/i3wm-Config-Mode"))
     ;; magit-todos
     minimap
     posix-manual
     rg
     rmsbolt
     bufler
     somafm
     sx
     treemacs-icons-dired
     trashed
     turkish
     vlf
     wttrin
     (youtube-dl :location (recipe :fetcher github :repo "skeeto/youtube-dl-emacs"))
     ztree
     )

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need
   ;; to compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=$HOME/.emacs.d/.cache/dumps/spacemacs-27.1.pdmp
   ;; (default spacemacs-27.1.pdmp)
   dotspacemacs-emacs-dumper-dump-file (format "spacemacs-%s.pdmp" emacs-version)

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style '(hybrid :variables
                                       hybrid-style-visual-feedback t
                                       hybrid-style-enable-evilified-state t
                                       hybrid-style-enable-hjkl-bindings t
                                       hybrid-style-use-evil-search-module nil
                                       hybrid-style-default-state 'normal)

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version t

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((bookmarks . 5)
                                (recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(modus-operandi
                         modus-vivendi
                         doom-one
                         spacemacs-dark
                         spacemacs-light)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme 'doom

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts.
   dotspacemacs-default-font '(("Iosevka"          :size 12.0 :weight normal :width normal)
                               ("DejaVu Sans Mono" :size 10.5 :weight normal :width normal)
                               ("Source Code Pro"  :size 10.0 :weight normal :width normal)
                               ("Monospace"        :size 10.0 :weight normal :width normal)
                               ("IBM Plex Mono"    :size 10.0 :weight normal :width normal)
                               ("Ubuntu Mono"      :size 10.0 :weight normal :width normal)
                               ("Fira Code"        :size 10.0 :weight normal :width normal))

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "<M-return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key (if window-system "<M-return>" "C-M-m")

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab t

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 10

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
   ;; borderless fullscreen. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but lines are only visual lines are counted. For example, folded lines
   ;; will not be counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S %a"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'changed

   ;; If non nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfer with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."

  (set-face-background 'mouse "white")

  (setq-default custom-file (expand-file-name "custom.el" dotspacemacs-directory))
  (when (file-exists-p custom-file)
    (load custom-file))

  ;; (setq comp-deferred-compilation t)
  (setq
   auto-window-vscroll nil
   browse-url-browser-function 'eww-browse-url
   calendar-location-name "Istanbul, Turkey"
   calendar-latitude 41.168602
   calendar-longitude 29.047024
   vc-follow-symlinks t)

  ;; (setq evil-default-state 'emacs
  ;;       evil-emacs-state-modes nil
  ;;       evil-insert-state-modes nil
  ;;       evil-motion-state-modes nil
  ;;       evil-normal-state-modes '(text-mode prog-mode fundamental-mode
  ;;                                           css-mode conf-mode
  ;;                                           TeX-mode LaTeX-mode
  ;;                                           diff-mode))
  (prefer-coding-system 'windows-1254)
  (prefer-coding-system 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)

  (setq modus-operandi-theme-slanted-constructs t
        modus-operandi-theme-bold-constructs t
        ;; modus-operandi-theme-visible-fringes t
        modus-operandi-theme-3d-modeline t
        modus-operandi-theme-distinct-org-blocks t
        modus-operandi-theme-intense-standard-completions t
        modus-operandi-theme-proportional-fonts t
        modus-operandi-theme-rainbow-headings t
        modus-operandi-theme-subtle-diffs t
        ;; modus-operandi-theme-section-headings t
        modus-operandi-theme-scale-headings t
        modus-operandi-theme-scale-1 1.05
        modus-operandi-theme-scale-2 1.1
        modus-operandi-theme-scale-3 1.15
        modus-operandi-theme-scale-4 1.2
        modus-operandi-theme-scale-5 1.3)
  )

(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."

  ;; Hook up dired-x global bindings without loading it up-front
  (define-key ctl-x-map "\C-j" 'dired-jump)
  (define-key ctl-x-4-map "\C-j" 'dired-jump-other-window)

  (use-package treemacs-icons)
  (treemacs--setup-icon-background-colors)
  (helm-treemacs-icons-enable)

  (setq focus-follows-mouse t
        gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"
        ido-mode -1
        paradox-github-token "1270899b8bbfb19871fb6192c44f768c1817e490")

  (push '("*charmap*" . emacs) evil-buffer-regexps)

  (add-hook 'after-save-hook
            'executable-make-buffer-file-executable-if-script-p)

  (use-package vlf :defer t
    :config (require 'vlf-setup))

  (use-package calc
    :commands (calc)
    :init
    (setq math-additional-units
          '((GiB "1024 * MiB" "Giga Byte")
            (MiB "1024 * KiB" "Mega Byte")
            (KiB "1024 * B"   "Kilo Byte")
            (B   nil          "Byte")
            (Gib "1024 * Mib" "Giga bit")
            (Mib "1024 * Kib" "Mega bit")
            (Kib "1024 * b"   "Kilo bit")
            (b   nil          "bit")
            )))

  ;; (defun turn-off-mouse (&optional frame)
  ;;   (interactive)
  ;;   (shell-command "xinput --disable \"bcm5974\""))

  ;; (defun turn-on-mouse (&optional frame)
  ;;   (interactive)
  ;;   (shell-command "xinput --enable \"bcm5974\""))

  ;; (defun turn-off-mouse (&optional frame)
  ;;   (interactive)
  ;;   (shell-command "xinput --disable \"DELL07FA:00 06CB:7E92 Touchpad\""))

  ;; (defun turn-on-mouse (&optional frame)
  ;;   (interactive)
  ;;   (shell-command "xinput --enable \"DELL07FA:00 06CB:7E92 Touchpad\""))

  ;; (add-hook 'focus-in-hook #'turn-off-mouse)
  ;; (add-hook 'focus-out-hook #'turn-on-mouse)
  ;; (add-hook 'delete-frame-functions #'turn-on-mouse)

  ;; cedet
  ;; (global-ede-mode t)
  ;; (ede-enable-generic-projects)

  ;; (setq project-linux-build-directory-default "~/Projects/gimsa/linux/am43xx_evm/"
  ;;       project-linux-architecture-default "arm")
  ;; (require 'ede/linux)
  ;; (ede-linux-project
  ;;  :directory "~/Projects/gimsa/linux/"
  ;;  :architecture "arm"
  ;;  :build-directory "~/Projects/gimsa/linux/am43xx_evm/"
  ;;  )

  ;; (setq semantic-default-submodes
  ;;       '(
  ;;         global-semanticdb-minor-mode                     ;; Maintain tag database.
  ;;         ;; global-semantic-idle-breadcrumbs-mode            ;; Show a breadcrumb of location during idle time
  ;;         global-semantic-idle-local-symbol-highlight-mode ;; Highlight references of the symbol under point.
  ;;         global-semantic-idle-scheduler-mode              ;; Reparse buffer when idle.
  ;;         global-semantic-idle-summary-mode                ;; Show summary of tag at point.
  ;;         ;; global-semantic-idle-completions-mode            ;; Show completions when idle.
  ;;         global-semantic-decoration-mode                  ;; Additional tag decorations.
  ;;         global-semantic-highlight-func-mode              ;; Highlight the current tag.
  ;;         global-semantic-stickyfunc-mode                  ;; Show current fun in header line.
  ;;         ;; global-semantic-mru-bookmark-mode                ;; Provide switch-to-buffer-like keybinding for tag names.
  ;;         global-cedet-m3-minor-mode                       ;; A mouse 3 context menu.
  ;;         ))

  ;; use snmpv2-mode for *-MIB.txt files
  (add-to-list 'auto-mode-alist '("-MIB\\.txt" . snmpv2-mode))
  (font-lock-add-keywords 'snmpv2-mode
                          '(
                            ("CONTACT-INFO" . font-lock-keyword-face)
                            ("GROUP" . font-lock-keyword-face)
                            ("MANDATORY-GROUPS)" . font-lock-keyword-face)
                            ("LAST-UPDATED" . font-lock-keyword-face)
                            ("M\\(AX-ACCESS\\|ODULE-COMPLIANCE\\)" . font-lock-keyword-face)
                            ("MODULE-IDENTITY" . font-lock-keyword-face)
                            ("MODULE" . font-lock-keyword-face)
                            ("O\\(BJECTS\\|RGANIZATION\\)" . font-lock-keyword-face)
                            ("OBJECT-GROUP" . font-lock-keyword-face)
                            ("REVISION" . font-lock-keyword-face)
                            )
                          )
  (add-hook 'snmpv2-mode-hook
            (lambda ()
              (setq snmp-font-lock-keywords snmp-font-lock-keywords-3)))

  ;;;###autoload
  ;; Author: Zane Ashby
  ;; (http://demonastery.org/2013/04/emacs-narrow-to-region-indirect/)
  (defun narrow-to-region-indirect (start end &optional prefix)
    "Restrict editing in this buffer to the current region, indirectly.
 To deactivate indirect region when you're done, just kill the buffer.
 The new buffer is named as [wide-buffer-name].
 If non-nil, optional argument `prefix' is put ahead of indirect
buffer's name.
 If invoked with C-u, prompt user for `prefix' value."
    (interactive
     (cond
      ((eq current-prefix-arg nil)             ;; normal invocation
       (list (region-beginning) (region-end)))
      (t                                       ;; universal argument invocation
       (let ((prefix-readed (read-string "Prefix: ")))
         (list (region-beginning) (region-end) prefix-readed)))))

    (deactivate-mark)
    (let ((indirect-buffer-name (format "%s[%s]"
                                        (or prefix "") (buffer-name)))
          (buf (clone-indirect-buffer nil nil)))
      (with-current-buffer buf
        (narrow-to-region start end)
        (rename-buffer indirect-buffer-name t))
      (switch-to-buffer buf)))
  (evil-leader/set-key (kbd "oi") 'narrow-to-region-indirect)

  ;; ;; C/C++ styles
  ;; (defun c-lineup-arglist-tabs-only (ignored)
  ;;   "Line up argument lists by tabs, not spaces"
  ;;   (let* ((anchor (c-langelem-pos c-syntactic-element))
  ;;          (column (c-langelem-2nd-pos c-syntactic-element))
  ;;          (offset (- (1+ column) anchor))
  ;;          (steps (floor offset c-basic-offset)))
  ;;     (* (max steps 1)
  ;;        c-basic-offset)))

  ;; ;; Add Linux kernel style
  ;; (add-hook 'c-mode-common-hook
  ;;           (lambda ()
  ;;             (c-add-style "linux-kernel"
  ;;                          '("linux" (c-offsets-alist
  ;;                                     (arglist-cont-nonempty
  ;;                                      c-lineup-gcc-asm-reg
  ;;                                      c-lineup-arglist-tabs-only))))))

  ;; (defun linux-kernel-development-setup ()
  ;;   (let ((filename (buffer-file-name)))
  ;;     ;; Enable kernel mode for the appropriate files
  ;;     (when (and filename
  ;;                (or (locate-dominating-file filename "Kbuild")
  ;;                    (locate-dominating-file filename "Kconfig")
  ;;                    (save-excursion (goto-char 0)
  ;;                                    (search-forward-regexp "^#include <linux/\\(module\\|kernel\\)\\.h>$" nil t))))
  ;;       ;; (setq indent-tabs-mode t)
  ;;       ;; (setq show-trailing-whitespace t)
  ;;       (c-set-style "linux-kernel")
  ;;       (message "Setting up indentation for the linux kernel"))))

  ;; (add-hook 'c-mode-hook 'linux-kernel-development-setup)

  (c-add-style "acml"
               '((indent-tabs-mode . nil)
                 (c-basic-offset . 2)
                 (c-offsets-alist
                  (substatement-open . 0)
                  (inline-open . 0)
                  (statement-cont . c-lineup-assignments)
                  (inextern-lang . 0)
                  (innamespace . 0))))

  (add-hook 'c-mode-common-hook
            (defun acml/c-style ()
              (c-set-style "acml")
              (setq c-macro-names-with-semicolon
                    '("Q_OBJECT"
                      "Q_PROPERTY"
                      "Q_DECLARE"
                      "Q_ENUMS"
                      "Q_INTERFACES"))
              (c-make-macro-with-semi-re)) t)

  ;; (defun c++-header-file-p ()
  ;;   "Return non-nil, if in a C++ header."
  ;;   (and (string-match "\\.h$"
  ;;                      (or (buffer-file-name)
  ;;                          (buffer-name)))
  ;;        (let ((case-fold-search nil))
  ;;          (save-excursion
  ;;            (re-search-forward
  ;;             "^ *\\_<\\(namespace\\|template\\|class\\|public\\|private\\|protected\\)\\_>" nil t)))))

  ;; (add-to-list 'magic-mode-alist
  ;;              '(c++-header-file-p . c++-mode))

  ;; (setq auto-mode-alist
  ;;       (append '(("\\.[Cc][Xx][Xx]$" . c++-mode)
  ;;                 ("\\.[Cc][Pp][Pp]$" . c++-mode)
  ;;                 ("\\.[Hh][Xx][Xx]$" . c++-mode)
  ;;                 ("\\.[Tt][Cc][Cc]$" . c++-mode)
  ;;                 ;; ("\\.i$" . c++-mode)    ; SWIG
  ;;                 ) auto-mode-alist))

  ;; (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

  ;; to fix performance penalty of setting c-c++-lsp-sem-highlight-method to 'overlay
  ;; (set-buffer-multibyte nil)

  (use-package beacon
    :config
    (beacon-mode 1))

  ;; (use-package beacon
  ;;   :init
  ;;   (beacon-mode 1)
  ;;   (evil-leader/set-key (kbd "ob") 'beacon-blink)
  ;;   :config
  ;;   (setq beacon-blink-when-point-moves-vertically 7)
  ;;   :diminish beacon-mode)

  (setq ccls-initialization-options
        `(:cache (:directory ,(file-truename "~/.cache/ccls"))))

  (with-eval-after-load 'cmake-ide
    (setq cmake-ide-build-dir "build/"))

  (use-package evil :defer t
    :init
    (setq evil-lookup-func 'man))

  (use-package beginend :defer t
    :init (beginend-global-mode))

  (use-package dired-aux
    :commands dired-dwim-target-directory)

  (use-package dired

    :hook
    (dired-mode . dired-hide-details-mode)
    (dired-mode . (lambda () (rename-buffer (generate-new-buffer-name (format "*dired: %s*" dired-directory)))))

    :config
    (when (spacemacs/system-is-mac)
      (setq insert-directory-program "/usr/local/bin/gls"))

    (setq ;; Details information
          dired-listing-switches "--group-directories-first -ahl"

          ;; delete and copy recursively
          dired-recursive-copies 'always
          dired-recursive-deletes 'top

          ;; Quickly copy/move file in Dired
          dired-dwim-target t

          delete-by-moving-to-trash t

          wdired-allow-to-change-permissions t)

    (use-package dired-async :defer t
      :config
      (dired-async-mode 1))

    ;; Colourful columns.
    (use-package diredfl :defer t
      :config
      (diredfl-global-mode 1))

    ;; (use-package dired-rainbow
    ;;   :after diredfl
    ;;   :config
    ;;   (progn
    ;;     (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
    ;;     (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
    ;;     (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
    ;;     (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
    ;;     (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
    ;;     (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
    ;;     (dired-rainbow-define media "#de751f" ("mp3" "mp4" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
    ;;     (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
    ;;     (dired-rainbow-define log "#c17d11" ("log"))
    ;;     (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
    ;;     (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
    ;;     (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
    ;;     (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
    ;;     (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
    ;;     (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
    ;;     (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
    ;;     (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
    ;;     (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
    ;;     (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
    ;;     (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*")))

    ;; When activated after creating a new entry (e.g. a directory) cursor jumps
    ;; to beginning of the listing. Annoys me to no end. Disabled for now.
    (use-package dired-filter :defer t
      :disabled
      :config
      (setq dired-filter-group-saved-groups
            '(("default" ("Directories" (directory)))))
      :hook (dired-mode . dired-filter-group-mode))

    (use-package dired-git-info :defer t
      :bind (:map dired-mode-map
                  (")" . dired-git-info-mode)))

    (use-package dired-hacks-utils :defer t
      :config
      (dired-utils-format-information-line-mode t))

    ;; Quick sort dired buffers via hydra
    (use-package dired-quick-sort :defer t
      :bind (:map dired-mode-map ("s" . hydra-dired-quick-sort/body))
      :hook (dired-initial-position . dired-quick-sort))

    (use-package dired-show-readme :defer t
      :hook (dired-mode . dired-show-readme-mode))

    (use-package dired-subtree :defer t
      :bind (:map dired-mode-map
                  ("<tab>" . acml/dired-subtree-toggle)
                  ("<backtab>" . dired-subtree-cycle))
      :init
      (defun acml/dired-subtree-toggle ()
        "Insert subtree at point or remove it if it was not present."
        (interactive)
        (dired-subtree-toggle)
        (dired-revert))
      (autoload 'dired-subtree--is-expanded-p "dired-subtree")
      :config
      (setq dired-subtree-use-backgrounds nil))

    (use-package treemacs-icons-dired :defer t
      :config (use-package treemacs-icons)
      :init
      (defun acml/dired-setup ()
        (unless (eq major-mode 'dired-sidebar-mode)
          (treemacs-icons-dired-mode)
          (treemacs--select-icon-set)))
      :hook (dired-mode . acml/dired-setup))

    :bind (:map dired-mode-map
                ("<left>" . dired-up-directory)
                ("<right>" . dired-find-file)))

  (use-package direnv :defer t
    :config
    (add-to-list 'warning-suppress-types '(direnv))
    (direnv-mode))

  (use-package trashed :defer t)

  (use-package disk-usage :defer t
    :config
    (evil-set-initial-state 'disk-usage-mode 'emacs))

  (use-package docker :defer t)
  (use-package docker-tramp :defer t)

  (use-package dts-mode :defer t :mode "\\.dts\\'")

  (with-eval-after-load 'ediff
    (add-hook 'ediff-startup-hook
              (lambda ()
                (local-set-key (kbd "q") 'my-ediff-quit)))

    (defun my-ediff-quit ()
      "If any of the ediff buffers have been modified, ask if changes
should be saved. Then quit ediff normally, without asking for
confirmation"
      (interactive)
      (ediff-barf-if-not-control-buffer)
      (let* ((buf-a ediff-buffer-A)
             (buf-b ediff-buffer-B)
             (buf-c ediff-buffer-C)
             (ctl-buf (current-buffer))
             (modified (remove-if-not 'buffer-modified-p
                                      (list buf-a buf-b buf-c))))
        (let ((save (if modified (yes-or-no-p "Save changes?")nil)))
          (loop for buf in modified do
                (progn
                  (set-buffer buf)
                  (if save
                      (save-buffer)
                    (set-buffer-modified-p nil))))
          (set-buffer ctl-buf)
          (ediff-really-quit nil))))

    (advice-add 'ediff-quit :around 'ct//no-confirm)

    (defun ediff-copy-both-to-C ()
      (interactive)
      (ediff-copy-diff ediff-current-difference nil 'C nil
                       (concat
                        (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                        (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
    (defun add-c-to-ediff-mode-map () (define-key ediff-mode-map "c" 'ediff-copy-both-to-C))
    (add-hook 'ediff-keymap-setup-hook 'add-c-to-ediff-mode-map))

  (with-eval-after-load 'erc
    (setq erc-prompt-for-nickserv-password nil))

  (with-eval-after-load 'eww
    (defun my/eww-toggle-images ()
      "Toggle whether images are loaded and reload the current page fro cache."
      (interactive)
      (setq-local shr-inhibit-images (not shr-inhibit-images))
      (eww-reload t)
      (message "Images are now %s"
               (if shr-inhibit-images "off" "on")))

    (define-key eww-mode-map (kbd "I") #'my/eww-toggle-images)
    (define-key eww-link-keymap (kbd "I") #'my/eww-toggle-images)

    (setq-default shr-inhibit-images nil)   ; toggle with `I`
    (add-hook 'eww-after-render-hook 'eww-readable)
    (evil-set-initial-state 'eww-mode 'emacs)
    (evil-set-initial-state 'eww-buffers-mode 'emacs)
    (evil-set-initial-state 'eww-bookmark-mode 'emacs))

  (use-package geiser :defer t
    :init
    (spacemacs|define-custom-layout "SICP"
      :binding "S"
      :body
      (find-file "~/Downloads/sicp.pdf")
      (split-window-right)
      (run-geiser 'mit)))

  (use-package hackernews :defer t
    :init
    (evil-leader/set-key (kbd "oh") 'hackernews)
    :config
    (setq hackernews-items-per-page 55)
    ;; (set 'face-remapping-alist '((hackernews-link font-lock-function-name-face)))
    (push '("*hackernews*" . emacs) evil-buffer-regexps))

  (with-eval-after-load 'conf-mode
    (use-package i3wm-config-mode))

  (use-package magit :defer t
    :init
    (setq magit-repository-directories '(( "~/Projects/" . 2)))
    ;; :config
    ;; (magit-add-section-hook 'magit-status-sections-hook
    ;;                         'magit-insert-ignored-files
    ;;                         'magit-insert-untracked-files t)
    )

  ;; (use-package magit-todos
  ;;   :after magit
  ;;   ;; :hook (magit-mode . magit-todos-mode)
  ;;   :init
  ;;   (setq magit-todos-nice t)
  ;;   :config
  ;;   (setq magit-todos-keyword-suffix "\\(?:([^)]+)\\)?:?") ; make colon optional
  ;;   ;;   (setq magit-todos-rg-extra-args '("-M 120"))
  ;;   (define-key magit-todos-section-map "j" nil)
  ;;   (setq magit-todos-group-by
  ;;         '(magit-todos-item-first-path-component magit-todos-item-keyword magit-todos-item-filename)))

  (use-package minimap :defer t
    :init
    (evil-leader/set-key (kbd "om") 'minimap-mode)
    ;; (minimap-mode 1)
    :config (setq minimap-window-location 'right))

  (use-package mu4e :defer t
    :init
    (provide 'html2text) ; disable obsolete package
    (when (or (not (require 'mu4e-meta nil t))
              (version< mu4e-mu-version "1.4"))
      (setq mu4e-maildir "~/.mail"
            mu4e-user-mail-address-list nil))
    (setq mu4e-get-mail-command "mbsync -a"
          mu4e-update-interval nil
          mu4e-attachment-dir
          (lambda (&rest _)
            (expand-file-name ".attachments" (mu4e-root-maildir))))
    :config
    ;; Use fancy icons
    (setq mu4e-use-fancy-chars t
          mu4e-headers-draft-mark '("D" . "")
          mu4e-headers-flagged-mark '("F" . "")
          mu4e-headers-new-mark '("N" . "")
          mu4e-headers-passed-mark '("P" . "")
          mu4e-headers-replied-mark '("R" . "")
          mu4e-headers-seen-mark '("S" . "")
          mu4e-headers-trashed-mark '("T" . "")
          mu4e-headers-attach-mark '("a" . "")
          mu4e-headers-encrypted-mark '("x" . "")
          mu4e-headers-signed-mark '("s" . "")
          mu4e-headers-unread-mark '("u" . ""))

    ;; Add a column to display what email account the email belongs to.
    (add-to-list 'mu4e-header-info-custom
                 '(:account
                   :name "Account"
                   :shortname "Account"
                   :help "Which account this email belongs to"
                   :function
                   (lambda (msg)
                     (let ((maildir (mu4e-message-field msg :maildir)))
                       (format "%s" (substring maildir 1 (string-match-p "/" maildir 1)))))))

    (setq mu4e-update-interval nil
          mu4e-compose-format-flowed t ; visual-line-mode + auto-fill upon sending
          mu4e-view-show-addresses t
          mu4e-sent-messages-behavior 'sent
          mu4e-hide-index-messages t
          ;; try to show images
          mu4e-view-show-images t
          mu4e-view-image-max-width 800
          ;; configuration for sending mail
          message-send-mail-function #'smtpmail-send-it
          smtpmail-stream-type 'starttls
          message-kill-buffer-on-exit t ; close after sending
          ;; start with the first (default) context;
          mu4e-context-policy 'pick-first
          ;; compose with the current context, or ask
          mu4e-compose-context-policy 'ask-if-none
          ;; no need to ask
          mu4e-confirm-quit nil
          ;; remove 'lists' column
          mu4e-headers-fields
          '((:account . 12)
            (:human-date . 12)
            (:flags . 4)
            (:from . 25)
            (:subject))
          mu4e-contexts
          `(,(make-mu4e-context
              :name "andasis"
              :match-func (lambda (msg)
                            (when msg
                              (mu4e-message-contact-field-matches msg :to "ahmet.ozgezer@andasis.com")))
              :vars '((user-mail-address      . "ahmet.ozgezer@andasis.com")
                      (user-full-name         . "Ahmet Cemal Özgezer")
                      (mu4e-drafts-folder     . "/Andasis/Drafts")
                      (mu4e-sent-folder       . "/Andasis/Sent Items")
                      (mu4e-trash-folder      . "/Andasis/Trash")
                      (smtpmail-mail-address . "ahmet.ozgezer@andasis.com")
                      (mu4e-compose-signature . (concat
                                                 "Ahmet Cemal Özgezer\n"
                                                 "Andasis Elektronik San. ve Tic. A.Ş.\n"
                                                 "Teknopark İstanbul, No: 1/1C 1206 Kat:2\n"
                                                 "Pendik İstanbul / Türkiye\n"
                                                 "Tel: +90 216 510 20 01\n"))))
            ,(make-mu4e-context
              :name "gmail"
              :match-func (lambda (msg)
                            (when msg
                              (mu4e-message-contact-field-matches msg :to "ozgezer@gmail.com")))
              :vars '((user-mail-address      . "ozgezer@gmail.com")
                      (user-full-name         . "Ahmet Cemal Özgezer")
                      (mu4e-drafts-folder     . "/GMail/Drafts")
                      (mu4e-sent-folder       . "/GMail/Sent")
                      (mu4e-trash-folder      . "/GMail/Trash")
                      (smtpmail-mail-address . "ozgezer@gmail.com")
                      (mu4e-compose-signature . (concat "Ahmet Cemal Özgezer\n"))))
            ,(make-mu4e-context
              :name "yahoo"
              :match-func (lambda (msg)
                            (when msg
                              (mu4e-message-contact-field-matches msg :to "ozgezer@yahoo.com")))
              :vars '((user-mail-address      . "ozgezer@yahoo.com")
                      (user-full-name         . "Ahmet Cemal Özgezer")
                      (mu4e-drafts-folder     . "/Yahoo/Draft")
                      (mu4e-sent-folder       . "/Yahoo/Sent")
                      (mu4e-trash-folder      . "/Yahoo/Trash")
                      (smtpmail-mail-address . "ozgezer@yahoo.com")
                      (mu4e-compose-signature . (concat "Ahmet Cemal Özgezer\n"))))
            ,(make-mu4e-context
              :name "msn"
              :match-func (lambda (msg)
                            (when msg
                              (mu4e-message-contact-field-matches msg :to "ozgezer@msn.com")))
              :vars '((user-mail-address      . "ozgezer@msn.com")
                      (user-full-name         . "Ahmet Cemal Özgezer")
                      (mu4e-drafts-folder     . "/MSN/Drafts")
                      (mu4e-sent-folder       . "/MSN/Sent")
                      (mu4e-trash-folder      . "/MSN/Deleted")
                      (smtpmail-mail-address . "ozgezer@msn.com")
                      (mu4e-compose-signature . (concat "Ahmet Cemal Özgezer\n")))))))

  ;; mpc
  (evil-set-initial-state 'mpc-mode 'emacs)
  (evil-set-initial-state 'mpc-status-mode 'emacs)
  (evil-set-initial-state 'mpc-tagbrowser-mode 'emacs)
  (evil-set-initial-state 'mpc-songs-mode 'emacs)

  (use-package proced
    :commands proced
    :custom
    (proced-auto-update-flag t)
    (proced-auto-update-interval 1)
    (proced-descend t)
    (proced-filter 'user))

  (use-package helm-sys :defer t
    :commands (helm-top)
    :config (helm-top-poll-mode 1))

  (use-package org :defer t
    :config
    (setq org-directory "~/Dropbox/Documents/org"
          org-agenda-files (list org-directory)
          org-default-notes-file (concat org-directory "/notes.org")))

  (use-package posix-manual :defer t)

  (use-package projectile :defer t
    :config
    (setq projectile-switch-project-action 'projectile-dired)
    (projectile-register-project-type
     'gimsa '("build.sh")
     :compile "./build.sh"
     :compilation-dir ".")
    (projectile-register-project-type
     'linux '("COPYING" "CREDITS" "Kbuild" "Kconfig" "MAINTAINERS" "Makefile" "README")
     :compile "make O=am43xx_evm ARCH=arm CROSS_COMPILE=arm-openwrt-linux-gnueabi- all"
     :compilation-dir ".")
    (projectile-register-project-type
     'openwrt '("BSDmakefile" "Config.in" "feeds.conf.default" "LICENSE" "Makefile" "README" "rules.mk" "version.date")
     :compile "make world"
     :compilation-dir ".")
    (projectile-register-project-type
     'u-boot '("config.mk" "Kbuild" "Kconfig" "MAINTAINERS" "MAKEALL" "Makefile" "README" "snapshot.commit")
     :compile "make O=am43xx_evm ARCH=arm CROSS_COMPILE=arm-openwrt-linux-gnueabi- all"
     :compilation-dir "."))

  (use-package rainbow-mode :defer t
    :hook
    ((prog-mode . rainbow-mode)
     (org-mode . rainbow-mode)))

  (use-package rg :defer t
    :init
    (evil-leader/set-key (kbd "or") 'rg-dwim)
    (evil-leader/set-key (kbd "oR") 'rg))

  (use-package slack :defer t
    :config
    (slack-register-team
     :name "andasis"
     :default t
     :token "xoxs-663392975270-684611065526-682007404980-d820b61e4ce976caf02228e34b5d0f7efdae153b08a41b992dd524dcebe4834b"
     :subscribed-channels '(general nms random)))

  (use-package bufler :defer t)

  (use-package somafm :defer t :commands somafm)

  (use-package sx :defer t
    :init
    (evil-leader/set-key (kbd "os") 'sx-tab-all-questions)
    :config
    (evil-set-initial-state 'sx-question-list-mode 'emacs)
    (evil-set-initial-state 'sx-question-mode 'emacs))

  (use-package treemacs :defer t
    :config
    (define-key treemacs-mode-map (kbd ".") (lambda () (interactive) (treemacs-visit-node-no-split t)))
    (defun acml/treemacs-ignore-gitignore (file _)
      (s-matches? (rx bol
                      (or (or ".git")
                          (or "GPATH" "GRTAGS" "GTAGS" "ID")
                          (seq (1+ any) ".dll")
                          (seq (1+ any) ".dwo")
                          (seq (1+ any) ".exe")
                          (seq (1+ any) ".o")
                          (seq (1+ any) ".o.cmd")
                          (seq (1+ any) ".o.d"))
                      eol)
                  file))
    (push #'acml/treemacs-ignore-gitignore treemacs-ignored-file-predicates))

  (use-package turkish :defer t
    :commands (turkish-mode)
    :init (evil-leader/set-key (kbd "ot") 'turkish-mode))

  (use-package undo-tree :defer t
    :config
    (setq undo-tree-enable-undo-in-region t))

  (use-package vterm :defer t
    :config
    (setq vterm-max-scrollback 100000))

  (use-package which-func :defer t
    :commands which-function-mode
    :init
    (defun acml/which-func-setup ()
      (setq header-line-format
            '((which-function-mode ("" which-func-format " ")))
            mode-line-misc-info
            ;; We remove Which Function Mode from the mode line, because it's mostly
            ;; invisible here anyway.
            (assq-delete-all 'which-function-mode mode-line-misc-info))
      (which-function-mode))
    :hook (prog-mode . acml/which-func-setup))

  (use-package wttrin :defer t
    :commands (wttrin wttrin-query)
    :init
    (setq wttrin-default-cities '("Istanbul"
                                  "Diyarbakir"
                                  "Didim,Turkey")
          wttrin-default-accept-language '("Accept-Language" . "tr-TR"))
    ;; function to open wttrin with first city on list
    (defun acml/wttrin ()
      "Open `wttrin' without prompting, using first city in `wttrin-default-cities'"
      (interactive)
      (wttrin-query (car wttrin-default-cities)))

    (defun my-wttrin-fetch-raw-string (args)
      (if (eq (frame-parameter nil 'background-mode) 'light)
          (list (concat (car args) "?T"))
        args))
    (advice-add 'wttrin-fetch-raw-string :filter-args #'my-wttrin-fetch-raw-string)
    (advice-add 'wttrin-query :after #'(lambda (&rest args)
                                         (face-remap-add-relative 'default '(:family "Source Code Pro"))))

    (evil-leader/set-key (kbd "ow") 'acml/wttrin)
    :config
    (push '("*wttr.in" . emacs) evil-buffer-regexps))

  ;; (use-package ztree
  ;;   :init
  ;;   (evil-set-initial-state 'ztree-mode 'emacs)
  ;;   (evil-set-initial-state 'ztreediff-mode 'emacs)
  ;;   (evil-set-initial-state 'ztreedir-mode 'emacs)
  ;;   (evil-leader/set-key (kbd "oz") 'ztree-diff)
  ;;   :config
  ;;   (setq ediff-keep-variants nil))

  (use-package ztree-view :defer t
    :bind (:map ztree-mode-map
                ("n" . next-line)
                ("p" . previous-line))
    :config
    (setq-default ztree-diff-filter-list (list "^\\." "^.*\\.o")))

  ;; text mode directory tree
  (use-package ztree :defer t
    :custom-face
    (ztreep-header-face ((t (:inherit diff-header))))
    (ztreep-arrow-face ((t (:inherit font-lock-comment-face))))
    (ztreep-leaf-face ((t (:inherit diff-index))))
    (ztreep-node-face ((t (:inherit font-lock-variable-name-face))))
    (ztreep-expand-sign-face ((t (:inherit font-lock-function-name-face))))
    (ztreep-diff-header-face ((t (:inherit (diff-header bold)))))
    (ztreep-diff-header-small-face ((t (:inherit diff-file-header))))
    (ztreep-diff-model-normal-face ((t (:inherit font-lock-doc-face))))
    (ztreep-diff-model-ignored-face ((t (:inherit font-lock-doc-face :strike-through t))))
    (ztreep-diff-model-diff-face ((t (:inherit diff-removed))))
    (ztreep-diff-model-add-face ((t (:inherit diff-nonexistent))))
    :init (setq ztree-draw-unicode-lines t
                ztree-show-number-of-children t)
    (evil-set-initial-state 'ztree-mode 'emacs)
    (evil-set-initial-state 'ztreediff-mode 'emacs)
    (evil-set-initial-state 'ztreedir-mode 'emacs)
    (evil-leader/set-key (kbd "oz") 'ztree-diff))
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
)
