(setopt
  tramp-use-file-notifications nil
  auto-revert-remote-files nil
  auth-source-save-behavior nil)

(require 'tramp)

;; Core Settings
(setopt
  tramp-default-method "sshx"
  tramp-verbose 1
  tramp-connection-timeout 30)

(add-to-list 'tramp-connection-properties
             (list (regexp-quote "") "term-name" "dumb"))

;; Performance Fixes
(setopt remote-file-name-inhibit-locks t
        remote-file-name-inhibit-cache 30
        dired-listing-switches "-al --group-directories-first")

;; File locations
(setopt tramp-auto-save-directory (expand-file-name "tramp-auto-save/" user-emacs-directory)
        tramp-persistency-file-name
        (expand-file-name "tramp-persistency" user-emacs-directory))


;; Disable project.el VC for remote files
(with-eval-after-load 'project
  (defun my/tramp-disable-project-vc (orig-fn &rest args)
    (if (and (stringp (car args))
             (file-remote-p (car args)))
        nil
      (apply orig-fn args)))
  (advice-add 'project-try-vc :around #'my/tramp-disable-project-vc))

(provide 'config/tramp)
