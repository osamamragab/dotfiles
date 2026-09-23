(use-package treesit
  :ensure nil
  :init
  (setopt major-mode-remap-alist
          '((c-mode          . c-ts-mode)
            (go-mode         . go-ts-mode)
            (sh-mode         . bash-ts-mode)
            (html-mode       . html-ts-mode)
            (json-mode       . json-ts-mode)
            (python-mode     . python-ts-mode)
            (yaml-mode       . yaml-ts-mode)
            (javascript-mode . js-ts-mode)
            (dockerfile-mode . dockerfile-ts-mode)
            (nix-mode        . nix-ts-mode)))
  (setopt treesit-language-source-alist
          '((c           "https://github.com/tree-sitter/tree-sitter-c")
            (go          "https://github.com/tree-sitter/tree-sitter-go")
            (gomod       "https://github.com/camdencheek/tree-sitter-go-mod")
            (bash        "https://github.com/tree-sitter/tree-sitter-bash")
            (html        "https://github.com/tree-sitter/tree-sitter-html")
            (json        "https://github.com/tree-sitter/tree-sitter-json")
            (yaml        "https://github.com/ikatyang/tree-sitter-yaml")
            (markdown    "https://github.com/ikatyang/tree-sitter-markdown")
            (python      "https://github.com/tree-sitter/tree-sitter-python")
            (zig         "https://github.com/tree-sitter-grammars/tree-sitter-zig" "master" "src")
            (tsx         "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
            (typescript  "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
            (javascript  "https://github.com/tree-sitter/tree-sitter-javascript")
            (css         "https://github.com/tree-sitter/tree-sitter-css")
            (dockerfile  "https://github.com/camdencheek/tree-sitter-dockerfile")
            (nix          "https://github.com/nix-community/tree-sitter-nix")))
  (dolist (entry '(("\\.go\\'"     . go-ts-mode)
                   ("go\\.mod\\'"  . go-mod-ts-mode)
                   ("go\\.sum\\'"  . go-mod-ts-mode)
                   ("\\.c\\'"      . c-ts-mode)
                   ("\\.h\\'"      . c-ts-mode)
                   ("[Dd]ockerfile\\'" . dockerfile-ts-mode)))
    (add-to-list 'auto-mode-alist entry)))

(dolist (lang (mapcar #'car treesit-language-source-alist))
  (unless (treesit-language-available-p lang)
    (treesit-install-language-grammar lang)))

(use-package treesit-auto
  :custom (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package nix-ts-mode
  :mode "\\.nix\\'")

(provide 'config/treesitter)
