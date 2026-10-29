;;; -*- lexical-binding: t; -*-

(use-package vertico
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package orderless
  :custom
  (orderless-matching-styles '(orderless-literal orderless-regexp orderless-flex))
  (completion-styles '(orderless partial-completion basic))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :bind
  (("C-x b"   . consult-buffer)
    ("M-g g"   . consult-goto-line)
    ("C-x C-f" . consult-find)
    ("M-s l"   . consult-line)
    ("C-x m"   . consult-man))
  :config
  (consult-customize
    consult-ripgrep consult-git-grep consult-grep
    consult-bookmark consult-recent-file
    :preview-key '(:debounce 0.4 any))
  :custom
  (consult-async-min-input      3)
  (consult-async-input-debounce 0.5))

(use-package embark
  :bind
  (("M-." . embark-act)
    ("M-o" . embark-export)
    ("C-;" . embark-dwim)))

(use-package embark-consult
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package nerd-icons-completion
  :init
  (nerd-icons-completion-mode 1))

(use-package corfu
  :init
  (global-corfu-mode 1)
  :bind
  ((:map corfu-map
     ("<tab>" . #'corfu-next)
     ("TAB" . #'corfu-next)
     ("<backtab>" . #'corfu-previous)
     ("C-y" . #'corfu-insert)
     ("RET" . #'corfu-insert)
     ("S-SPC" . #'corfu-insert-separator))
    ("C-SPC" . #'completion-at-point))
  :custom
  (corfu-auto        t)
  (corfu-cycle       t)
  (corfu-auto-delay  0.3)
  (corfu-auto-prefix 4)
  (corfu-quit-no-match t)
  (corfu-preview-current t)
  (corfu-popupinfo-delay '(2.0 . 0.5))
  :config
  (corfu-popupinfo-mode 1)

  (with-eval-after-load 'evil
    (keymap-set evil-insert-state-map "C-SPC" 'completion-at-point))
  (defun my/corfu-completion-styles ()
    (setq-local completion-styles '(basic partial-completion)))
  (add-hook 'eglot-managed-mode-hook #'my/corfu-completion-styles)
  (with-eval-after-load 'lsp-mode
    (add-hook 'lsp-managed-mode-hook #'my/corfu-completion-styles)))

(setopt text-mode-ispell-word-completion nil)

(use-package dabbrev
  :init
  (setopt dabbrev-check-other-buffers 'maybe)
  :config
  (dolist (rx '("^ "
                 "^\\*[^*]+\\*$"
                 "\\.\\(?:elc\\|o\\|so\\|pyc\\|class\\|jar\\)\\'"))
    (add-to-list 'dabbrev-ignored-buffer-regexps rx))
  (dolist (m '(messages-buffer-mode compilation-mode
                help-mode doc-view-mode image-mode))
    (add-to-list 'dabbrev-ignored-buffer-modes m)))

(use-package cape
  :config
  (add-to-list 'completion-at-point-functions
    (cape-capf-super
      #'cape-elisp-block
      #'cape-keyword
      #'cape-dabbrev
      #'cape-file)
    t))

(provide 'config/complete)
