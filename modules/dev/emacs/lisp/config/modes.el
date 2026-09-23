(use-package paren
  :init
  (setopt show-paren-delay 0
          show-paren-when-point-inside-paren t
          show-paren-when-point-in-periphery t))

(use-package python
  :custom
  (python-indent-guess-indent-offset nil)
  (python-indent-offset 4))

(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode)))

(use-package zig-mode
  :mode (("\\.zig\\'" . zig-mode)
         ("\\.zon\\'" . zig-mode)))

(use-package nix-mode)

(use-package ediff
  :config
  (setopt ediff-window-setup-function 'ediff-setup-windows-plain
          ediff-split-window-function 'split-window-horizontally))

(provide 'config/modes)
