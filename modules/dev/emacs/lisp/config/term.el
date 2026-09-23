(use-package vterm
  :hook
  ((vterm-mode . (lambda ()
                  (setq-local confirm-kill-processes nil
                              mode-line-format nil)))
   (vterm-copy-mode . (lambda ()
                        (if vterm-copy-mode
                            (meow-normal-mode 1)
                          (meow-insert-mode 1)))))
  :init
  (setopt vterm-timer-delay 0.05
          vterm-max-scrollback 5000)
  :config
  (setopt vterm-buffer-name-string "vterm %s"))

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
