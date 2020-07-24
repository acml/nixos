;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


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
(setq doom-font (font-spec :family "Iosevka" :size 16)
      doom-variable-pitch-font (font-spec :family "Ubuntu Nerd Font" :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(when (window-system)
  (add-to-list 'default-frame-alist '(alpha . (100)))
  (set-frame-parameter (selected-frame) 'alpha '(100)))

(setq-default
 delete-by-moving-to-trash t)

(windmove-default-keybindings 'control)
(windswap-default-keybindings 'control 'shift)

; Each path is relative to `+mu4e-mu4e-mail-path', which is ~/.mail by default
(after! mu4e
  (set-email-account! "yahoo"
                      '((mu4e-sent-folder       . "/Yahoo/Sent")
                        (mu4e-drafts-folder     . "/Yahoo/Draft")
                        (mu4e-trash-folder      . "/Yahoo/Trash")
                        (mu4e-refile-folder     . "/Yahoo/Archive")
                        (smtpmail-smtp-user     . "ozgezer@yahoo.com")
                        (mu4e-compose-signature . "---\nAhmet Cemal Özgezer")))
  (set-email-account! "gmail"
                      '((mu4e-sent-folder       . "/Gmail/[Gmail]/Sent Mail")
                        (mu4e-drafts-folder     . "/Gmail/[Gmail]/Drafts")
                        (mu4e-trash-folder      . "/Gmail/[Gmail]/Trash")
                        (mu4e-refile-folder     . "/Gmail/[Gmail]/Archive")
                        (smtpmail-smtp-user     . "ozgezer@gmail.com")
                        (mu4e-compose-signature . "---\nAhmet Cemal Özgezer")))
  (set-email-account! "msn"
                      '((mu4e-sent-folder       . "/MSN/Sent")
                        (mu4e-drafts-folder     . "/MSN/Drafts")
                        (mu4e-trash-folder      . "/MSN/Deleted")
                        (mu4e-refile-folder     . "/MSN/Archive")
                        (smtpmail-smtp-user     . "ozgezer@msn.com")
                        (mu4e-compose-signature . "---\nAhmet Cemal Özgezer")))
  (set-email-account! "andasis"
                      '((mu4e-sent-folder       . "/Andasis/Sent Items")
                        (mu4e-drafts-folder     . "/Andasis/Drafts")
                        (mu4e-trash-folder      . "/Andasis/Trash")
                        (mu4e-refile-folder     . "/Andasis/Archives")
                        (smtpmail-smtp-user     . "ahmet.ozgezer@andasis.com")
                        (mu4e-compose-signature . "---\nAhmet Cemal Özgezer"))
                      t))

(setq ccls-initialization-options
      `(:cache (:directory ,(file-truename "~/.cache/ccls"))))

(setq calendar-location-name "Istanbul, Turkey"
      calendar-latitude 41.168602
      calendar-longitude 29.047024)

;;; :ui doom-dashboard
(setq fancy-splash-image (concat doom-private-dir "splash.png"))

(map! "M-c" #'capitalize-dwim
      "M-l" #'downcase-dwim
      "M-u" #'upcase-dwim)

;; (setq spacemacs-path doom-modules-dir)
;; (load! (concat spacemacs-path "spacemacs/+spacemacs"))

;; (setq comp-deferred-compilation t)

(custom-set-faces!
  '(aw-leading-char-face
    :foreground "white" :background "red"
    :weight bold :height 2.5 :box (:line-width 10 :color "red")))

(use-package! avy
  :init
  (setq avy-all-windows t))

(use-package! beginend :defer t
  :init (beginend-global-mode))

(use-package! daemons
  :config
  ;; (setq daemons-always-sudo t)
  )

;;
;; Dired
;;
;; Hook up dired-x global bindings without loading it up-front
(define-key ctl-x-map "\C-j" 'dired-jump)
(define-key ctl-x-4-map "\C-j" 'dired-jump-other-window)

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

(use-package! docker-tramp)
(use-package! docker)

(use-package! journalctl-mode)

;;
;; Turkish
(use-package! turkish
  :commands (turkish-mode)
  ;; :init (evil-leader/set-key (kbd "ot") 'turkish-mode)
  )

(after! counsel-projectile
  (setq counsel-projectile-switch-project-action 'counsel-projectile-switch-project-action-dired))

(after! projectile
  (setq projectile-switch-project-action 'projectile-dired
        projectile-enable-caching t
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
  (setq modus-operandi-theme-slanted-constructs t
        modus-operandi-theme-bold-constructs t
        ;; modus-operandi-theme-visible-fringes t
        modus-operandi-theme-3d-modeline t
        modus-operandi-theme-subtle-diffs t
        modus-operandi-theme-intense-standard-completions t
        modus-operandi-theme-org-blocks 'rainbow
        modus-operandi-theme-variable-pitch-headings t
        modus-operandi-theme-rainbow-headings t
        ;; modus-operandi-theme-section-headings t
        modus-operandi-theme-scale-headings t
        modus-operandi-theme-scale-1 1.05
        modus-operandi-theme-scale-2 1.1
        modus-operandi-theme-scale-3 1.15
        modus-operandi-theme-scale-4 1.2
        modus-operandi-theme-scale-5 1.3)
  :config
  (load-theme 'modus-operandi t))

(use-package! rainbow-mode
  :hook
  ((prog-mode . rainbow-mode)
   (org-mode . rainbow-mode)))

;; (use-package! shrface)

(use-package! trashed
  :config
  (add-to-list 'evil-emacs-state-modes 'trashed-mode))

(use-package! vterm
  :config
  (setq vterm-max-scrollback 100000))

;; text mode directory tree
(use-package! ztree
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
  :bind (:map ztreediff-mode-map
         ("C-<f5>" . ztree-diff))
  :init (setq ztree-draw-unicode-lines t
              ztree-show-number-of-children t))
