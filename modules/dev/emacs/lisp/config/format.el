(setopt truncate-lines t
        indent-tabs-mode nil
        tab-width 4
        tab-always-indent 'complete
        save-interprogram-paste-before-kill t)
(add-hook 'before-save-hook #'delete-trailing-whitespace)


(use-package reformatter
  :ensure t)

(provide 'config/format)
