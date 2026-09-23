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
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :bind
  (("C-x b"   . consult-buffer)
   ("M-g g"   . consult-goto-line)
   ("C-x C-f" . consult-find)
   ("M-s l" . consult-line)
   ("C-x m" . consult-man))
  :config
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file
   :preview-key '(:debounce 0.4 any)))

(use-package embark
  :bind
  (("C-." . embark-act)
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
  (with-eval-after-load 'corfu
    (keymap-set corfu-map "<tab>" #'corfu-next)
    (keymap-set corfu-map "TAB" #'corfu-next)
    (keymap-set corfu-map "<backtab>" #'corfu-previous)
    (keymap-set corfu-map "C-y" #'corfu-insert)
    (keymap-set corfu-map "RET" #'corfu-insert))
  :custom
  (corfu-auto        t)
  (corfu-cycle       t)
  (corfu-auto-delay  0.15)
  (corfu-auto-prefix 1)
  (corfu-quit-no-match t)
  (corfu-preview-current t))

(setopt text-mode-ispell-word-completion nil)

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block))

(provide 'config/complete)
