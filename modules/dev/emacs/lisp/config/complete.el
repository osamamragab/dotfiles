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
    :preview-key '(:debounce 0.4 any)))

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
  :config
  (corfu-popupinfo-mode 1)
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
  (corfu-auto-delay  5)
  (corfu-auto-prefix 3)
  (corfu-quit-no-match t)
  (corfu-preview-current t))

(setopt text-mode-ispell-word-completion nil)

(with-eval-after-load 'evil
  (keymap-set evil-insert-state-map "C-SPC" 'completion-at-point))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block))

(provide 'config/complete)
