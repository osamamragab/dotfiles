(use-package evil
  :demand t
  :init
  (setopt evil-want-integration t
          evil-want-keybinding nil
          evil-want-C-u-scroll t
          evil-want-C-i-jump t
          evil-undo-system 'undo-tree
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
    "d"     (kbd "\"_d")
    "D"     (kbd "\"_D")
    "j"     '((lambda () (interactive) (previous-error) (evil-scroll-line-to-center nil)) :which-key "Prev Error")
    "k"     '((lambda () (interactive) (next-error) (evil-scroll-line-to-center nil)) :which-key "Next Error")
    ","     '(consult-buffer :which-key "Buffers")
    "/"     '(consult-line :which-key "Search")
    "c c"   '(compile)
    "f s"   '(save-buffer :which-key "Save")
    "f f"   '(project-find-file :which-key "Find File")
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
    "p f"   '(project-find-file :which-key "Project File")
    "p r"   '(project-find-regexp :which-key "Project Regexp")
    "p R"   '(project-query-replace-regexp :which-key "Project Replace Regexp")
    "g s"   '(magit-status :which-key "Magit")
    "b m"   '(bookmark-set :which-key "Bookmark")
    "b D"   '(bookmark-delete :which-key "Delete Bookmark")
    "b k"   '(kill-current-buffer :which-key "Kill Buffer")
    "b l"   '((lambda () (interactive) (switch-to-buffer nil)): which-key "Last Buffer")
    "b b"   '(switch-to-buffer :which-key "Buffers")
    "b n"   '(next-buffer :which-key "Next Buffer")
    "b p"   '(previous-buffer :which-key "Previous Buffer")
    "b i"   '(ibuffer :which-key "Ibuffer")
    "b r"   '(revert-buffer :which-key "Revert Buffer")
    "b f"   '(eglot-format-buffer :which-key "Format Buffer")
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
    :prefix "SPC"
    "p" (kbd "\"_dP")
    "J" (kbd ":m '>+1<CR>gv=gv")
    "K" (kbd ":m '<-2<CR>gv=gv"))

  (general-define-key
    :states 'normal
    :prefix "SPC"
    "Y" (kbd "\"+y$")
    "n" (kbd "n z z z v")
    "N" (kbd "N z z z v")
    "J" (kbd "m z J ` z")
    "C-d" (kbd "C-d z z")
    "C-u" (kbd "C-u z z"))

  (defun my/substitute-word-under-cursor ()
    "Populate an ex substitute command for the symbol at point,
    cursor left ready to edit the replacement."
    (interactive)
    (let ((word (or (thing-at-point 'symbol t) "")))
      (minibuffer-with-setup-hook
        (lambda () (goto-char (- (point-max) 3)))
        (evil-ex (format "%%s/\\<%s\\>/%s/gI" word word)))))
  (leader "s" '(my/substitute-word-under-cursor :which-key "Substitute Word")))

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

(keymap-global-set "C-=" #'text-scale-increase)
(keymap-global-set "C--" #'text-scale-decrease)

(provide 'config/modal)
