(use-package undo-tree
  :demand t
  :config
  (setopt undo-tree-auto-save-history t
        undo-tree-history-directory-alist
        `(("." . ,(expand-file-name "undo-tree-history" user-emacs-directory))))
  (global-undo-tree-mode 1))

(provide 'config/undo)
