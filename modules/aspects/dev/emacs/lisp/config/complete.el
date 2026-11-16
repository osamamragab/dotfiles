;;; -*- lexical-binding: t; -*-

(use-package consult
  :demand t
  :bind
  (("C-x b"   . consult-buffer)
    ("M-g g"   . consult-goto-line)
    ("C-x C-f" . consult-find)
    ("M-s l"   . consult-line))
  :config
  (setopt xref-show-xrefs-function #'consult-xref
    xref-show-definitions-function #'consult-xref)
  (consult-customize
    consult-ripgrep consult-git-grep consult-grep
    consult-bookmark consult-recent-file consult-theme
    :preview-key '(:debounce 0.4 any))
  :custom
  (consult-async-min-input      3)
  (consult-async-input-debounce 0.5))

(use-package embark
  :bind
  (("C-;" . embark-dwim)
    ("M-o" . embark-export)))

(use-package embark-consult
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package vertico
  :after consult
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t))

(use-package orderless
  :after consult
  :custom
  (orderless-matching-styles '(orderless-literal orderless-regexp orderless-flex))
  (completion-styles '(orderless partial-completion basic))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package corfu
  :demand t
  :init
  (global-corfu-mode 1)
  :bind
  (("C-SPC" . completion-at-point)
    (:map corfu-map
     ("C-y" . corfu-insert)
     ("<tab>" . corfu-next)
     ("TAB" . corfu-next)
     ("<backtab>" . corfu-previous)
     ("<return>" . nil)))
  :custom
  (corfu-auto nil)
  (corfu-cycle t)
  (corfu-auto-delay 0.75)
  (corfu-auto-prefix 3)
  (corfu-quit-no-match t)
  (corfu-preview-current nil)
  (corfu-preselect 'prompt)
  (corfu-popupinfo-delay '(2.0 . 0.5))
  :config
  (setopt text-mode-ispell-word-completion nil)
  (corfu-history-mode 1)
  (corfu-popupinfo-mode -1)
  (savehist-mode 1)
  (add-to-list 'savehist-additional-variables 'corfu-history)
  (with-eval-after-load 'evil
    (keymap-set evil-insert-state-map "C-SPC" 'completion-at-point)))

(use-package dabbrev
  :ensure nil
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
  :custom
  (lsp-completion-provider :capf)
  :config
  (setopt cape-dabbrev-check-other-buffers nil)
  (add-hook 'completion-at-point-functions #'cape-history 10)
  (add-hook 'completion-at-point-functions #'cape-file 20)
  (add-hook 'completion-at-point-functions #'cape-keyword 30)
  (add-hook 'completion-at-point-functions #'cape-dabbrev 40))

(provide 'config/complete)
