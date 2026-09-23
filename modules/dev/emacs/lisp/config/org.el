(use-package org
  :ensure nil
  :hook
  (org-mode . display-line-numbers-mode)
  :init
  (setopt org-directory "~/docs/notes/org")
  :config
  (setopt org-edit-src-content-indentation 0
          org-hide-leading-stars           t
          org-indent-mode                  t
          org-return-follows-link          t)
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("go" . "src go"))
  (add-to-list 'org-structure-template-alist '("sh" . "src sh"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (require 'ob-shell)
  (require 'ob-python)
  (require 'ob-C)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell      . t)
     (emacs-lisp . t)
     (python     . t)
     (C          . t))))

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :init
  (setopt org-modern-star '("●" "○" "◆" "◇" "▸")))

(use-package toc-org
  :after org
  :commands toc-org-enable
  :hook
  (org-mode . toc-org-enable))

(use-package hl-todo
  :hook
  ((org-mode . hl-todo-mode)
   (prog-mode . hl-todo-mode)))

(use-package org-download
  :after org
  :hook ((org-mode   . org-download-enable)
         (dired-mode . org-download-enable))
  :config
  (setopt org-download-heading-lvl nil
          org-download-timestamp "%Y%m%d-%H%M%S_"
          org-download-image-dir (expand-file-name "attachments" org-directory)))

(use-package org-roam
  :hook (org-mode . org-roam-db-autosync-mode)
  :commands (org-roam-node-find
			 org-roam-node-insert
			 org-roam-dailies-goto-today
			 org-roam-buffer-toggle
			 org-roam-db-sync
			 org-roam-capture)
  :init
  (setopt org-roam-directory "~/docs/notes/org/roam"
          org-roam-database-connector 'sqlite-builtin
          org-roam-completion-everywhere t
          org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory)
          org-roam-v2-ack t)
  :config
  (unless (file-exists-p org-roam-directory)
	(make-directory org-roam-directory t)))

(use-package org-roam-ui
  :commands (org-roam-ui-mode org-roam-ui-open)
  :after org-roam
  :config
  (setopt org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start nil))

(use-package ox-typst
  :after org
  :commands (org-export-dispatch)
  :init
  (with-eval-after-load 'org
    (add-to-list 'org-export-backends 'typst)))

(with-eval-after-load 'org
  (add-hook 'org-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                        (list #'yasnippet-capf
                              #'cape-dabbrev
                              #'cape-file
                              #'pcomplete-completions-at-point
                              #'ispell-completion-at-point))
              (setq-local electric-pair-inhibit-predicate
                          (lambda (c)
                            (if (char-equal c ?<)
                                t
                              (electric-pair-conservative-inhibit c)))))))

(provide 'config/org)
