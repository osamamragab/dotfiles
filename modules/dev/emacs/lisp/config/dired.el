(use-package dired
  :ensure nil
  :hook
  (dired-mode . auto-revert-mode)
  :custom
  (dired-listing-switches "-lAh --group-directories-first --no-group")
  (dired-dwim-target t)
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-auto-revert-buffer t))

(use-package dirvish
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-attributes '(nerd-icons subtree-state file-size))
  (dirvish-use-mode-line nil)
  (dirvish-use-header-line t)
  (dirvish-header-line-format '(:left (path) :right (free-space)))
  (dirvish-hide-details '(dirvish))
  (dirvish-reuse-session 'open)
  (dirvish-preview-dispatchers '(image gif video audio epub archive pdf)))

(provide 'config/dired)
