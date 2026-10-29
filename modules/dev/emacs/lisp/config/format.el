;;; -*- lexical-binding: t; -*-

(setopt truncate-lines t
  indent-tabs-mode nil
  tab-width 4
  tab-always-indent 'complete)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

(use-package apheleia
  :config
  (add-to-list 'apheleia-formatters '(alejandra "alejandra" "--quiet"))
  (dolist (entry '((emacs-lisp-mode . lisp-indent)
                    (nix-mode       . alejandra)
                    (nix-ts-mode    . alejandra)))
    (add-to-list 'apheleia-mode-alist entry)))

(provide 'config/format)
