;;; -*- lexical-binding: t; -*-

(use-package evil
  :demand t
  :init
  (setopt evil-want-integration t
    evil-want-keybinding nil
    evil-want-C-u-scroll t
    evil-want-C-i-jump t
    evil-want-fine-undo t
    evil-undo-system 'undo-fu
    evil-search-module 'isearch
    evil-kill-on-visual-paste nil
    evil-visual-update-x-selection-p nil)
  :config
  (evil-mode 1)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  :bind
  (:map evil-insert-state-map
    ("C-h" . #'evil-delete-backward-char-and-join)))

(use-package evil-collection
  :demand t
  :after (evil)
  :config
  (evil-collection-init)
  (setopt evil-collection-want-unimpaired-p t))

(use-package general
  :demand t
  :config
  (general-evil-setup t)

  (general-create-definer leader
    :states '(normal visual)
    :prefix "SPC")

  (leader
    "y"     '(my/evil-yank-to-system :which-key "yank to clipboard")
    "Y"     (kbd "\"+y$")
    "d"     (kbd "\"_d")
    "D"     (kbd "\"_D")
    "s"     '(my/substitute-word-under-cursor :which-key "Substitute Word")
    "j"     '((lambda () (interactive) (previous-error) (evil-scroll-line-to-center nil)) :which-key "Prev Error")
    "k"     '((lambda () (interactive) (next-error) (evil-scroll-line-to-center nil)) :which-key "Next Error")
    "."     '(find-file :which-key "Find File")
    ","     '(consult-buffer :which-key "Buffers")
    "/"     '(consult-line :which-key "Go to Line")
    "c c"   '(compile)
    "f s"   '(save-buffer :which-key "Save")
    "f f"   '(project-find-file :which-key "Find File (Project)")
    "f r"   '(consult-recent-file :which-key "Recent")
    "f d"   '(consult-fd :which-key "fd")
    "f g"   '(consult-ripgrep :which-key "ripgrep")
    "a f"   '(lsp-ui-doc-glance :which-key "Doc Glance (lsp)")
    "a c"   '(lsp-ui-sideline-apply-code-actions :which-key "Code Actions (lsp)")
    "a r"   '(flymake-start :which-key "Refresh Diagnostics (flymake)")
    "a L"   '(flymake-show-project-diagnostics :which-key "Show Project Diagnostics (flymake)")
    "a l"   '(flymake-show-buffer-diagnostics :which-key "Show Buffer Diagnostics (flymake)")
    "a k"   '(flymake-goto-next-error :which-key "Next Error (flymake)")
    "a j"   '(flymake-goto-prev-error :which-key "Previous Error (flymake)")
    "e a"   '(embark-act :which-key "Embark Act")
    "e d"   '(embark-dwim :which-key "Embark Dwim")
    "e e"   '(embark-export :which-key "Embark Export")
    "w v"   '(split-window-right :which-key "Vertical")
    "w d"   '(delete-window :which-key "Delete")
    "p p"   '(project-switch-project :which-key "Project")
    "p f"   '(project-find-file :which-key "Project File")
    "p s"   '(project-switch-project :which-key "Switch Project")
    "p r"   '(project-find-regexp :which-key "Project Regexp")
    "p R"   '(project-query-replace-regexp :which-key "Project Replace Regexp")
    "p t"   '(ghostel-project :which-key "Project Terminal")
    "b m"   '(bookmark-set :which-key "Bookmark")
    "b D"   '(bookmark-delete :which-key "Delete Bookmark")
    "b k"   '(kill-current-buffer :which-key "Kill Buffer")
    "b K"   '(my/kill-other-buffers :which-key "Kill Other Buffers")
    "b l"   '((lambda () (interactive) (switch-to-buffer nil)) :which-key "Last Buffer")
    "b b"   '(switch-to-buffer :which-key "Buffers")
    "b n"   '(next-buffer :which-key "Next Buffer")
    "b p"   '(previous-buffer :which-key "Previous Buffer")
    "b i"   '(ibuffer :which-key "Ibuffer")
    "b r"   '(revert-buffer :which-key "Revert Buffer")
    "b f"   '(apheleia-format-buffer :which-key "Format Buffer")
    "b F"   '(lsp-format-buffer :which-key "Format Buffer (lsp)")
    "r c"   '((lambda () (interactive) (load-file user-init-file) (message "config reloaded")) :which-key "Reload Config")
    "o t"   '(term-scratch :which-key "Scratch Terminal")
    "o d"   '(dirvish :which-key "Dirvish")
    "o p"   '(pass :which-key "Pass")
    "C"     '(org-capture :which-key "Org Capture")
    "n r i" '(org-roam-capture :which-key "Org Roam Capture")
    "n r f" '(org-roam-node-find :which-key "Org Roam Find")
    "n j"   '(org-roam-dailies-capture-today :which-key "Org Roam Daily")
    "g"     '(:ignore t :which-key "Magit")
    "g s"   '(magit-status :which-key "Status")
    "g S"   '(magit-status-here :which-key "Status Here")
    "g a"   '(magit-file-stage :which-key "Stage File")
    "g A"   '(magit-stage-modified :which-key "Stage all")
    "g c"   '(magit-commit :which-key "Commit")
    "g C"   '(magit-commit-amend :which-key "Commit Amend")
    "g f"   '(magit-fetch :which-key "Fetch")
    "g F"   '(magit-pull :which-key "Pull")
    "g p"   '(magit-push :which-key "Push")
    "g l"   '(magit-log-current :which-key "Log Current")
    "g L"   '(magit-log-all :which-key "Log All")
    "g b"   '(magit-blame :which-key "Blame")
    "g d s" '(magit-diff-staged :which-key "Diff Staged")
    "g d u" '(magit-diff-unstaged :which-key "Diff Unstaged")
    "g d f" '(magit-diff-buffer-file :which-key "Diff Current File"))

  (general-define-key
    :states 'visual
    "p" (kbd "\"_dP")
    "J" '(move-text-down :which-key "Move Down")
    "K" '(move-text-up :which-key "Move Up"))

  (general-define-key
    :states 'normal
    "Y"   (kbd "\"_y$")
    "g l" '(consult-line :which-key "Go to Line")
    "g t" '(next-buffer :which-key "Next Buffer")
    "g T" '(previous-buffer :which-key "Previous Buffer")
    "g d" '(lsp-find-definition :which-key "Go to Definition (lsp)")
    "g r" '(lsp-find-references :which-key "Go to References (lsp)")
    "g i" '(lsp-find-implementation :which-key "Go to Implementation (lsp)"))

  (evil-define-operator my/evil-yank-to-system (beg end type register yank-handler)
    "Save the characters in motion into the kill-ring and the system clipboard."
    :move-point nil
    :repeat nil
    (interactive "<R><x><y>")
    (let ((select-enable-clipboard t))
      (evil-yank beg end type register yank-handler)))

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

(use-package move-text)

(use-package undo-fu
  :demand t
  :custom
  (undo-limit (* 64  1024 1024))
  (undo-strong-limit (* 96 1024 1024))
  (undo-outer-limit (* 960 1024 1024))
  (undo-fu-allow-undo-in-region nil))

(use-package undo-fu-session
  :custom
  (undo-fu-session-directory
    (expand-file-name "undo-fu-session" user-emacs-directory))
  :config
  (undo-fu-session-global-mode 1))

(keymap-global-set "C-=" #'text-scale-increase)
(keymap-global-set "C--" #'text-scale-decrease)

(provide 'config/modal)
