(show-paren-mode 1)
(set-fringe-mode 10)
(blink-cursor-mode 0)
(editorconfig-mode 1)

(setopt
    inhibit-startup-screen t
    inhibit-startup-message t
    initial-scratch-message nil
    initial-buffer-choice t
    menu-bar-mode nil
    tool-bar-mode nil
    scroll-bar-mode nil
    use-dialog-box nil
    cursor-type 'box
    tab-bar-show nil
    tab-bar-close-button-show nil
	use-short-answer t
	visible-bell nil
	ring-bell-function 'ignore
    indicate-empty-lines t
    show-trailing-whitespace t
    indent-tabs-mode nil
    tab-width 4
    indent-line-function 'insert-tab)

(setopt auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "auto-save/") t))
        backup-directory-alist `((".*" . ,(concat user-emacs-directory "backups/")))
        backup-by-copying t
        version-control t
        delete-old-versions t
        kept-new-versions 6
        kept-old-versions 2)

(dolist (dir '("auto-save/" "backups/"))
  (let ((path (concat user-emacs-directory dir)))
    (unless (file-directory-p path)
      (make-directory path t))))

(setopt display-line-numbers-type 'relative)
(global-display-line-numbers-mode +1)
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setopt display-fill-column-indicator-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

(setopt select-enable-primary t
        select-enable-clipboard nil)
(keymap-global-set "C-S-p" (lambda ()
                             (interactive)
                             (clipboard-yank)))
(keymap-global-set "C-S-c" (lambda ()
                             (interactive)
                             (clipboard-kill-ring-save
                              (region-beginning)
                              (region-end))))

(setopt auth-source-pass-filename
        (or (getenv "PASSWORD_STORE_DIR")
            (expand-file-name "password-store" (or (getenv "XDG_DATA_HOME")
                                                   "~/.local/share"))))

(keymap-global-set "<escape>" 'keyboard-escape-quit)

(add-to-list 'default-frame-alist '(font . "Hack-14"))

(if init-file-debug
    (setopt use-package-verbose t
            use-package-expand-minimally nil
            use-package-compute-statistics t
            debug-on-error t)
  (setopt use-package-verbose nil
          use-package-expand-minimally t))

(require 'package)
(setopt package-archives '(("melpa" . "https://melpa.org/packages/")
                           ("elpa" . "https://elpa.gnu.org/packages/")
                           ("org" . "https://orgmode.org/elpa/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setopt use-package-always-ensure t)

(use-package evil
  :init
  (setopt evil-want-integration t
          evil-want-keybinding nil
          evil-want-C-u-scroll t
          evil-want-C-i-jump t
          evil-kill-on-visual-paste nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after (evil)
  :config (evil-collection-init))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config (ivy-mode 1)
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-count-format "(%d/%d) ")
  (ivy-initial-inputs-alist nil))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config (counsel-mode 1))

(use-package ivy-rich
  :after (ivy counsel)
  :config (ivy-rich-mode 1))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (setopt which-key-idle-delay 0.3)
  (which-key-mode 1))

(use-package projectile
  :diminish projectile-mode
  :bind-keymap ("C-c p" . projectile-command-map)
  :custom ((projectile-completion-system 'ivy))
  :init
  (when (file-directory-p "~/src")
    (setopt projectile-project-search-path '(("~/src" . 4))))
  (setopt projectile-switch-project-action #'projectile-dired)
  :custom (projectile-completion-system 'ivy)
  :config
  (projectile-mode 1)
  (projectile-discover-projects-in-search-path))

(use-package counsel-projectile
  :after (counsel projectile)
  :config (counsel-projectile-mode 1))

(use-package magit
  :commands (magit-status magit-git-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package forge)

(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :custom (git-gutter:update-interval 0.02))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . lsp-headerline-breadcrumb-mode)
  :init (setopt lsp-keymap-prefix "C-c l")
  :config
  (setopt lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-enable-which-key-integration t))

(use-package lsp-ivy
  :after (lsp-mode ivy))

(use-package lsp-ui
  :after (lsp-mode)
  :custom (lsp-ui-doc-position 'bottom))

(use-package company
  :after (lsp-mode)
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection)
              :map lsp-mode-map
              ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.3))

(use-package go-mode
  :hook (go-mode . lsp-deferred))

(use-package zig-mode
  :hook (zig-mode . lsp-deferred))

(use-package doom-modeline
  :custom (doom-modeline-height 15)
  :config (doom-modeline-mode 1))

(use-package doom-themes
  :config (load-theme 'doom-nord t))

(use-package tldr)

(setopt custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))
