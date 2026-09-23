(use-package eglot
  :ensure nil
  :config
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (add-to-list 'eglot-server-programs '(nix-ts-mode . ("nil")))
  (add-to-list 'eglot-server-programs '(zig-mode . ("zls")))
  (add-to-list 'eglot-server-programs '(zig-ts-mode . ("zls")))
  (add-to-list 'eglot-server-programs '(go-mode . ("gopls")))
  (add-to-list 'eglot-server-programs '(go-ts-mode . ("gopls")))
  (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '(rust-ts-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '(bash-ts-mode . ("bash-language-server")))
  (add-to-list 'eglot-server-programs '(python-ts-mode . ("pyright")))
  :custom
  (eglot-autoshutdown       t)
  (eglot-events-buffer-size 0)
  (eglot-sync-connect       nil)
  (eglot-extend-to-xref     t)
  :hook ((c-ts-mode
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
           yaml-ts-mode) . eglot-ensure))

(provide 'config/lsp)
