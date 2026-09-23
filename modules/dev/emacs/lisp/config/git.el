(use-package magit-section)

(use-package magit
  :hook (git-commit-mode . meow-insert)
  :commands (magit-status magit-git-current-branch)
  :config
  (setopt magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1
          magit-bury-buffer-function #'magit-restore-window-configuration)
  (keymap-set magit-status-mode-map "p" #'magit-push)
  (keymap-set magit-status-mode-map "SPC" nil)
  (keymap-set magit-log-mode-map "SPC" nil)
  (keymap-set magit-diff-mode-map "SPC" nil))

  ;;:custom
  ;;(magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package forge)

(use-package git-gutter
  :init
  (global-git-gutter-mode 1)
  :custom
  (git-gutter:update-interval 0.02))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

(use-package git-modes
  :mode (("/\\.gitignore\\'" . gitignore-mode)
         ("/\\.gitconfig\\'" . gitconfig-mode)
         ("/\\.gitattributes\\'" . gitattributes-mode)))

(provide 'config/git)
