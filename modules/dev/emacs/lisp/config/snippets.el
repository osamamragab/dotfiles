(use-package yasnippet
  :demand t
  :config
  (setopt yas-snippet-dirs '("~/.config/emacs/snippets")
          yas-verbosity    0)
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :demand t
  :after yasnippet)

(use-package yasnippet-capf
  :demand t
  :custom
  (yasnippet-capf-lookup-by 'key))

(add-hook 'go-ts-mode-hook #'(lambda () (yas-activate-extra-mode 'go-mode)))

(provide 'config/snippets)
