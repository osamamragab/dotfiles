;;; -*- lexical-binding: t -*-

(use-package tramp
  :ensure nil
  :demand t
  :custom
  (tramp-use-file-notifications    nil)
  (tramp-default-method            "sshx")
  (tramp-verbose                   1)
  (tramp-connection-timeout        30)
  (remote-file-name-inhibit-cache  30)
  (remote-file-name-inhibit-locks  t)
  (dired-listing-switches          "-al --group-directories-first")
  (tramp-auto-save-directory
    (expand-file-name "tramp-auto-save/" user-emacs-directory))
  (tramp-persistency-file-name
    (expand-file-name "tramp-persistency" user-emacs-directory))
  :config
  ;; Use "dumb" as the remote term for all hosts
  (add-to-list 'tramp-connection-properties
    (list (regexp-quote "") "term-name" "dumb"))

  ;; Disable project.el's VC backend for remote files
  (with-eval-after-load 'project
    (defun my/tramp-disable-project-vc (orig-fn &rest args)
      (if (and (stringp (car args))
            (file-remote-p (car args)))
        nil
        (apply orig-fn args)))
    (advice-add 'project-try-vc :around #'my/tramp-disable-project-vc)))

(use-package autorevert
  :custom (auto-revert-remote-files nil))

(use-package auth-source
  :custom (auth-source-save-behavior nil))

(provide 'config/tramp)
