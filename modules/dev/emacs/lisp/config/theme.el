(use-package nerd-icons
  :demand t)

(use-package nord-theme
  :demand t
  :init
  (if (daemonp)
      (cl-labels ((load-nord (frame)
                    (with-selected-frame frame
                      (load-theme 'nord t))
                    (remove-hook
                     'after-make-frame-functions
                     #'load-nord)))
        (add-hook 'after-make-frame-functions #'load-nord))
    (load-theme 'nord t)))

(use-package doom-modeline
  :demand t
  :init
  (setopt doom-modeline-icon t)
  :config
  (doom-modeline-mode 1))

(provide 'config/theme)
