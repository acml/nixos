;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; (setq frame-resize-pixelwise t)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ahmet Cemal Özgezer"
      user-mail-address "ahmet.ozgezer@andasis.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))
;; (setq doom-font (font-spec :family "Fira Code" :size 12)
;;       doom-big-font (font-spec :family "Fira Code" :size 26)
;;       doom-variable-pitch-font (font-spec :family "Overpass" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
(setq doom-theme 'modus-operandi)
;; (setq doom-theme 'modus-vivendi)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(setq-default
 delete-by-moving-to-trash t)

(map! "M-c" #'capitalize-dwim
      "M-l" #'downcase-dwim
      "M-u" #'upcase-dwim)

;; (load! (concat user-emacs-directory "modules/spacemacs/+spacemacs"))

(setq ccls-initialization-options
      `(:cache (:directory ,(file-truename "~/.cache/ccls"))))

;;
;; Dired
(setq dired-hide-details-hide-symlink-targets t)
(add-hook! dired-mode
  (dired-hide-details-mode 1)
  (dired-show-readme-mode 1))

(use-package! dired-subtree
  :after dired
  :init
  (defun acml/dired-subtree-toggle ()
    "Insert subtree at point or remove it if it was not present."
    (interactive)
    (dired-subtree-toggle)
    (dired-revert))
  :config
  (map!
   (:map dired-mode-map
     :desc "Toggle subtree" :n [tab] #'acml/dired-subtree-toggle
     :desc "Cycle subtree" :n "<backtab>" #'dired-subtree-cycle)))

(after! dired
  ;; Define localleader bindings
  (map!
   ;; Define or redefine dired bindings
   (:map dired-mode-map
     :desc "Up" :n "<left>" #'dired-up-directory
     :desc "Down" :n "<right>" #'dired-find-file)))

;;
;; Turkish
(use-package! turkish
  :commands (turkish-mode)
  ;; :init (evil-leader/set-key (kbd "ot") 'turkish-mode)
  )

(after! projectile
  (setq projectile-enable-caching t
        projectile-project-search-path '("~/Projects/")
        ;; Follow suggestion to reorder root functions to find the .projectile file
        ;; https://old.reddit.com/r/emacs/comments/920psp/projectile_ignoring_projectile_files/
        ;; projectile-project-root-files-functions #'(projectile-root-top-down
        ;;                                            projectile-root-top-down-recurring
        ;;                                            projectile-root-bottom-up
        ;;                                            projectile-root-local)
        )
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

(use-package! modus-operandi-theme
  :init
  (setq org-src-block-faces '(("c" (:background "#fef2f2" :extend t))
                              ("python" (:background "#f4f4ff" :extend t))))
  (setq modus-operandi-theme-slanted-constructs t
        modus-operandi-theme-bold-constructs t
        modus-operandi-theme-proportional-fonts t
        modus-operandi-theme-scale-headings t
        modus-operandi-theme-visible-fringes t
        modus-operandi-theme-distinct-org-blocks t
        modus-operandi-theme-subtle-diffs t
        modus-operandi-theme-3d-modeline t))

(use-package! rainbow-mode
  :config
  (add-hook 'prog-mode-hook #'rainbow-mode))

(use-package! docker-tramp)
(use-package! docker)

(use-package! trashed)

;; (use-package! shrface)
