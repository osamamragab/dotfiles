;;; -*- lexical-binding: t; -*-

(use-package lsp-mode
  :init
  (setopt lsp-keymap-prefix "C-c l")
  :commands (lsp lsp-deferred)
  :config
  (setopt flymake-show-diagnostics-at-end-of-line 'short)
  :custom
  (lsp-keep-workspace-alive nil)
  (lsp-log-io nil)
  (lsp-enable-xref t)
  (lsp-idle-delay 0.5)
  (lsp-enable-symbol-highlighting t)
  (lsp-enable-links t)
  (lsp-headerline-breadcrumb-enable t)
  (lsp-completion-provider :flymake)
  :hook ((lsp-mode . lsp-enable-which-key-integration)
         (lsp-completion-mode . (lambda ()
                                  (setq-local completion-category-defaults
                                              (assoc-delete-all 'lsp-capf completion-category-defaults))))
         ((c-ts-mode
           zig-ts-mode
           go-ts-mode
           rust-ts-mode
           bash-ts-mode
           python-ts-mode
           nix-ts-mode
           nix-mode
           html-ts-mode
           js-ts-mode
           typescript-ts-mode
           tsx-ts-mode
           dockerfile-ts-mode
           json-ts-mode
           yaml-ts-mode) . lsp-deferred)))

(use-package lsp-ui
             :after lsp-mode
             :commands lsp-ui-mode
             :custom
             (lsp-ui-sideline-show-hover nil)
             (lsp-ui-sideline-show-diagnostics t)
             (lsp-ui-sideline-update-mode 'line)
             (lsp-ui-sideline-diagnostic-max-lines 1))

(use-package dap-mode)

(provide 'config/lsp)
