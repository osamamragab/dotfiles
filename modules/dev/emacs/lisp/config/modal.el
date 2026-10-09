;;; -*- lexical-binding: t; -*-

(use-package evil
  :demand t
  :init
  (setopt evil-want-integration t
          evil-want-keybinding nil
          evil-want-C-u-scroll t
          evil-want-C-i-jump t
          evil-undo-system 'undo-tree
          evil-search-module 'isearch
          evil-kill-on-visual-paste nil
          evil-visual-update-x-selection-p nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :demand t
  :after (evil)
  :config (evil-collection-init))

(use-package general
  :demand t
  :config
  (general-evil-setup t)

  (general-create-definer leader
    :states '(normal visual)
    :prefix "SPC")

  (leader
    "y"     (kbd "\"+y")
    "Y"     (kbd "\"+y$")
    "d"     (kbd "\"_d")
    "D"     (kbd "\"_D")
    "s"     '(my/substitute-word-under-cursor :which-key "Substitute Word")
    "j"     '((lambda () (interactive) (previous-error) (evil-scroll-line-to-center nil)) :which-key "Prev Error")
    "k"     '((lambda () (interactive) (next-error) (evil-scroll-line-to-center nil)) :which-key "Next Error")
    "."     '(find-file :which-key "Find File")
    ","     '(consult-buffer :which-key "Buffers")
    "/"     '(consult-line :which-key "Search")
    "c c"   '(compile)
    "f s"   '(save-buffer :which-key "Save")
    "f f"   '(project-find-file :which-key "Find File (Project)")
    "f r"   '(consult-recent-file :which-key "Recent")
    "f d"   '(consult-fd :which-key "fd")
    "f g"   '(consult-ripgrep :which-key "ripgrep")
    "b b"   '(switch-to-buffer :which-key "Buffers")
    "b d"   '(kill-current-buffer :which-key "Kill Buffer")
    "w v"   '(split-window-right :which-key "Vertical")
    "w d"   '(delete-window :which-key "Delete")
    "p p"   '(project-switch-project :which-key "Project")
    "p f"   '(project-find-file :which-key "Project File")
    "p s"   '(project-switch-project :which-key "Switch Project")
    "p r"   '(project-find-regexp :which-key "Project Regexp")
    "p R"   '(project-query-replace-regexp :which-key "Project Replace Regexp")
    "g s"   '(magit-status :which-key "Magit")
    "b m"   '(bookmark-set :which-key "Bookmark")
    "b D"   '(bookmark-delete :which-key "Delete Bookmark")
    "b k"   '(kill-current-buffer :which-key "Kill Buffer")
    "b K"   '(my/kill-other-buffers :which-key "Kill Other Buffers")
    "b l"   '((lambda () (interactive) (switch-to-buffer nil)): which-key "Last Buffer")
    "b b"   '(switch-to-buffer :which-key "Buffers")
    "b n"   '(next-buffer :which-key "Next Buffer")
    "b p"   '(previous-buffer :which-key "Previous Buffer")
    "b i"   '(ibuffer :which-key "Ibuffer")
    "b r"   '(revert-buffer :which-key "Revert Buffer")
    "b f"   '(apheleia-format-buffer :which-key "Format Buffer")
    "b F"   '(eglot-format-buffer :which-key "Format Buffer (eglot)")
    "r c"   '((lambda () (interactive) (load-file user-init-file) (message "config reloaded")) :which-key "Reload Config")
    "o t"   '(term-scratch :which-key "Scratch Terminal")
    "o d"   '(dirvish :which-key "Dirvish")
    "o p"   '(pass :which-key "Pass")
    "C"     '(org-capture :which-key "Org Capture")
    "n r i" '(org-roam-capture :which-key "Org Roam Capture")
    "n r f" '(org-roam-node-find :which-key "Org Roam Find")
    "n j"   '(org-roam-dailies-capture-today :which-key "Org Roam Daily"))

  (general-define-key
    :states 'visual
    "p" (kbd "\"_dP")
    "J" '(move-text-down :which-key "Move Down")
    "K" '(move-text-up :which-key "Move Up"))

  (defun my/kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (dolist (buf (delq (current-buffer) (buffer-list)))
      (unless (string-match-p "\\`[ *]" (buffer-name buf))
        (kill-buffer buf))))

  (defun my/substitute-word-under-cursor ()
    "Populate an ex substitute command for the symbol at point,
    cursor left ready to edit the replacement."
    (interactive)
    (let ((word (or (thing-at-point 'symbol t) "")))
      (minibuffer-with-setup-hook
        (lambda () (goto-char (- (point-max) 3)))
        (evil-ex (format "%%s/\\<%s\\>/%s/gI" word word))))))

(use-package evil-easymotion
  :after (evil))

(use-package evil-surround
  :after (evil)
  :config
  (global-evil-surround-mode 1))

(use-package evil-lion
  :after (evil)
  :config
  (evil-lion-mode))

(use-package move-text
  :config
  (defun indent-region-advice (&rest ignored)
    (let ((deactivate deactivate-mark))
      (if (region-active-p)
        (indent-region (region-beginning) (region-end))
        (indent-region (line-beginning-position) (line-end-position)))
      (setq deactivate-mark deactivate)))

  (advice-add 'move-text-up :after 'indent-region-advice)
  (advice-add 'move-text-down :after 'indent-region-advice))

(keymap-global-set "C-=" #'text-scale-increase)
(keymap-global-set "C--" #'text-scale-decrease)

(provide 'config/modal)
