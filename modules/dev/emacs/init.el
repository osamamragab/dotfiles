(setopt use-package-always-defer t
        use-package-always-ensure t)

(if init-file-debug
    (setopt debug-on-error t
            use-package-verbose t
            use-package-expand-minimally nil
            use-package-compute-statistics t)
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

(setopt custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

(setopt display-fill-column-indicator-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

(electric-pair-mode 1)
(save-place-mode 1)
(global-hl-line-mode 1)
(column-number-mode 1)
(global-auto-revert-mode 1)
(winner-mode 1)
(show-paren-mode 1)
(editorconfig-mode 1)
(set-fringe-mode 10)
(blink-cursor-mode -1)

(setopt scroll-margin 2
	  display-line-numbers-type 'relative
	  make-backup-files nil
	  auto-save-default nil
	  create-lockfiles nil
	  initial-scratch-message nil
	  require-final-newline t
    use-short-answers t
	  native-comp-async-report-warnings-errors 'silent)

(setopt select-enable-primary t
        select-enable-clipboard nil)
(keymap-global-set "C-S-p" (lambda ()
                             (interactive)
                             (clipboard-yank)))
(keymap-global-set "C-S-y" (lambda ()
                             (interactive)
                             (clipboard-kill-ring-save
                              (region-beginning)
                              (region-end))))

(setopt auth-source-pass-filename
        (or (getenv "PASSWORD_STORE_DIR")
            (expand-file-name "password-store" (or (getenv "XDG_DATA_HOME")))))

(use-package gcmh
  :init
  (setopt native-comp-jit-compilation t
          gc-cons-threshold (* 10 1024 1024)
          read-process-output-max (* 4 1024 1024)
          redisplay-skip-fontification-on-input t)
  :config
  (setopt gcmh-idle-delay 5
          gcmh-high-cons-threshold (* 16 1024 1024))
  (gcmh-mode 1))

(use-package no-littering
  :demand t
  :init
  (setopt no-littering-etc-directory (expand-file-name "etc/" user-emacs-directory)
		no-littering-var-directory "~/.local/share/emacs/"))

;; (use-package envrc
;;   :hook (after-init . envrc-global-mode))

(use-package direnv
  :config
  (direnv-mode 1))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (setopt which-key-idle-delay 0.3)
  (which-key-mode 1))

(use-package recentf
  :ensure nil
  :init
  (recentf-mode 1)
  :config
  (setopt recentf-max-menu-items 25
		recentf-max-saved-items 100)
  (dolist (path '("\\.git/" "/tmp/" "/nix/store/" "\\.gpg/"))
	(add-to-list 'recentf-exclude path))
  (add-to-list 'recentf-exclude (recentf-expand-file-name no-littering-var-directory))
  (add-to-list 'recentf-exclude (recentf-expand-file-name no-littering-etc-directory))
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode 1)
  :config
  (setopt history-length 1000
          history-delete-duplicates t
          savehist-save-minibuffer-history t
          savehist-additional-variables '(search-ring regexp-search-ring kill-ring))
  (dolist (var '(extended-command-history
                  search-ring
                  regexp-search-ring
                  consult--buffer-history
                  recentf-list))
    (add-to-list 'savehist-additional-variables var))
  (add-hook 'savehist-save-hook
            (lambda ()
              (setopt kill-ring
                      (mapcar #'substring-no-properties
                              (cl-remove-if-not #'stringp kill-ring))))))

(add-hook 'after-save-hook
          #'executable-make-buffer-file-executable-if-script-p)

(defun my/ensure-parent-directory ()
  "Create the parent directory of the file being saved, if it doesn't exist."
  (when buffer-file-name
    (let ((dir (file-name-directory buffer-file-name)))
      (unless (file-remote-p buffer-file-name)
        (unless (file-exists-p dir)
          (make-directory dir t))))))
(add-hook 'before-save-hook #'my/ensure-parent-directory)

(defun toggle-delete-other-windows ()
  "Delete other windows in frame if any, or restore previous window config."
  (interactive)
  (if (and winner-mode
           (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))
(keymap-global-set "C-x 1" #'toggle-delete-other-windows)

(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))

(require 'config/modal)
(require 'config/complete)
(require 'config/snippets)
(require 'config/lsp)
(require 'config/git)
(require 'config/org)
(require 'config/term)
(require 'config/undo)
(require 'config/dired)
(require 'config/tramp)
(require 'config/theme)
(require 'config/modes)
(require 'config/format)
(require 'config/treesitter)

(when (eq system-type 'gnu/linux)
  (require 'config/pdf)
  (require 'config/pass))
