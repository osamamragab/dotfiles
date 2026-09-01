(show-paren-mode 1)
(set-fringe-mode 10)
(blink-cursor-mode 0)
(editorconfig-mode 1)
(save-place-mode 1)

(setopt inhibit-startup-screen t
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
		use-short-answers t
		visible-bell nil
		ring-bell-function 'ignore
		indicate-empty-lines t
		show-trailing-whitespace t
		indent-tabs-mode nil
		tab-width 4
		indent-line-function 'insert-tab)

(setopt native-comp-jit-compilation t
		gc-cons-threshold (* 10 1024 1024)
		read-process-output-max (* 4 1024 1024)
		redisplay-skip-fontification-on-input t
		cursor-in-non-selected-windows nil
		highlight-nonselected-windows nil
		save-interprogram-paste-before-kill t
		kill-do-not-save-duplicates t
		reb-re-syntax 'string
		ffap-machine-p-known 'reject
		window-combination-resize t
		set-mark-command-repeat-pop t
		help-window-select t)

(setopt savehist-additional-variables
		'(search-ring regexp-search-ring kill-ring))
(add-hook 'savehist-save-hook
		  (lambda ()
			(setq kill-ring
				  (mapcar #'substring-no-properties
						  (cl-remove-if-not #'stringp kill-ring)))))

(add-hook 'after-save-hook
		  #'executable-make-buffer-file-executable-if-script-p)

(winner-mode +1)

(defun toggle-delete-other-windows ()
  "Delete other windows in frame if any, or restore previous window config."
  (interactive)
  (if (and winner-mode
           (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))

(global-set-key (kbd "C-x 1") #'toggle-delete-other-windows)

(advice-add 'save-place-find-file-hook :after
            (lambda (&rest _)
              (when buffer-file-name (ignore-errors (recenter)))))

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
  (add-hook mode (lambda ()
				   (display-line-numbers-mode 0))))

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

(add-to-list 'default-frame-alist '(font . "monospace-12"))

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
(setopt package-archive-priorities '(("melpa" . 10) ("elpa" . 5) ("org" . 5)))
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


(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer leader
    :states '(normal visual)
    :prefix "SPC")

  (leader
    "f f" '(find-file :which-key "Find File")
    "f r" '(consult-recent-file :which-key "Recent")
    "f s" '(save-buffer :which-key "Save")
    "b b" '(switch-to-buffer :which-key "Buffers")
    "b d" '(kill-current-buffer :which-key "Kill Buffer")
    "w v" '(split-window-right :which-key "Vertical")
    "w d" '(delete-window :which-key "Delete")
    "p p" '(project-switch-project :which-key "Project")
    "p f" '(project-find-file :which-key "Project File")
    "g s" '(magit-status :which-key "Magit")
	"r c" '((lambda ()
			  (interactive)
			  (load-file user-init-file)
			  (message "config reloaded"))
			:which-key "Reload Config")
    "/" '(consult-line :which-key "Search")))

;;(leader
;;  "y y" '(evil-yank-line :which-key "Yank Line")
;;  "y"   '(evil-yank :which-key "Yank")
;;  "p"   '(evil-paste-after :which-key "Paste")
;;  "P"   '(evil-paste-before :which-key "Paste Before"))

(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package consult)

(use-package corfu
  :init
  (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.15)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  (corfu-preview-current t))

(with-eval-after-load 'corfu
  (define-key corfu-map (kbd "<tab>") #'corfu-next)
  (define-key corfu-map (kbd "TAB") #'corfu-next)
  (define-key corfu-map (kbd "<backtab>") #'corfu-previous)
  (define-key corfu-map (kbd "C-y") #'corfu-insert)
  (define-key corfu-map (kbd "RET") #'corfu-insert))

(use-package corfu-popupinfo
  :after corfu
  :config
  (corfu-popupinfo-mode))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (setopt which-key-idle-delay 0.3)
  (which-key-mode 1))

(use-package envrc
  :hook (after-init . envrc-global-mode))

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

(setopt treesit-language-source-alist
      '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx        "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (json       "https://github.com/tree-sitter/tree-sitter-json")
        (python     "https://github.com/tree-sitter/tree-sitter-python")
        (bash       "https://github.com/tree-sitter/tree-sitter-bash")
        (css        "https://github.com/tree-sitter/tree-sitter-css")
        (html       "https://github.com/tree-sitter/tree-sitter-html")
        (yaml       "https://github.com/ikatyang/tree-sitter-yaml")
        (markdown   "https://github.com/ikatyang/tree-sitter-markdown")))

(dolist (lang (mapcar #'car treesit-language-source-alist))
  (unless (treesit-language-available-p lang)
    (treesit-install-language-grammar lang)))

(use-package treesit-auto
  :custom (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package eglot
  :hook ((typescript-ts-mode tsx-ts-mode js-ts-mode
          python-ts-mode
          rust-ts-mode
          go-ts-mode) . eglot-ensure)
  :custom (eglot-autoshutdown t))

(use-package yasnippet
  :init (yas-global-mode 1))
(use-package yasnippet-snippets)

(use-package org
  :custom
  (org-ellipsis " ▾")
  (org-hide-emphasis-markers t)
  (org-agenda-files '("~/docs/org")))

(use-package org-modern
  :hook (org-mode . org-modern-mode))

(use-package move-text
  :ensure t
  :config
  (global-set-key (kbd "M-j") #'move-text-down)
  (global-set-key (kbd "M-k") #'move-text-up))

(use-package windmove
  :ensure nil
  :config
  (windmove-default-keybindings 'control))

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

(use-package doom-modeline
  :custom (doom-modeline-height 15)
  :config (doom-modeline-mode 1))

(use-package doom-themes
  :config (load-theme 'doom-nord t))

(use-package tldr)

(setopt custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))
