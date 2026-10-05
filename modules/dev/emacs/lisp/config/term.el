;;; -*- lexical-binding: t; -*-

(use-package vterm
  :hook
  ((vterm-mode . (lambda ()
                  (setq-local confirm-kill-processes nil
                              mode-line-format nil))))
  :init
  (setopt vterm-timer-delay 0.05
          vterm-max-scrollback 5000)
  :config
  (setopt vterm-buffer-name-string "vterm %s"))

(use-package ghostel
  :bind (("C-x m" . ghostel)
         :map ghostel-semi-char-mode-map
         ("C-s"  . consult-line)
         ("C-k"  . my/ghostel-send-C-k-and-kill)
         ("M-p" . (lambda () (interactive) (ghostel-send-key "p" "ctrl")))
         ("M-n" . (lambda () (interactive) (ghostel-send-key "n" "ctrl")))
         :map project-prefix-map
         ("m" . ghostel-project)
         ("M" . ghostel-project-list-buffers))
  :config
  (defun my/ghostel-send-C-k-and-kill ()
    "Send `C-k' to ghostel.
Like normal Emacs `C-k'.  Kill to end of line and put content in kill-ring."
    (interactive)
    (kill-ring-save (point) (line-end-position))
    (ghostel-send-key "k" "ctrl"))
  (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
  (add-to-list 'project-switch-commands '(ghostel-project-list-buffers "Ghostel buffers") t)
  (add-to-list 'ghostel-eval-cmds '("magit-status-setup-buffer" magit-status-setup-buffer)))

(use-package evil-ghostel
  :after (ghostel evil)
  :hook (ghostel-mode . evil-ghostel-mode))

(defun term-scratch ()
  "Open vterm buffer as a bottom popup at 30% height."
  (interactive)
  (require 'vterm)
  (let* ((buf (get-buffer-create "*vterm*"))
         (win (get-buffer-window buf 'visible)))
    (if (eq win (selected-window))
        (window-toggle-side-windows)
      (with-current-buffer buf
        (unless (derived-mode-p 'vterm-mode)
          (vterm-mode)))
      (select-window
       (display-buffer
        buf
        '((display-buffer-reuse-window
           display-buffer-in-side-window)
          (side . bottom)
          (slot . 0)
          (window-height . 0.3)
          (window-parameters . ((no-delete-other-windows . t)))))))))

(provide 'config/term)
