(use-package pass
  :bind (:map pass-mode-map
              ("W" . pass-copy-field))
  :config
  (add-to-list 'display-buffer-alist
               '("\\*Password-Store\\*"
				 (display-buffer-in-side-window)
				 (side . left)
				 (window-width . 0.25)
				 (window-parameters . ((no-other-window . nil)))
				 (inhibit-same-window . t))))

(provide 'config/pass)
