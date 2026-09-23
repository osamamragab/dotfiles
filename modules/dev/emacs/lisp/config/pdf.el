(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :hook (pdf-view-mode . (lambda ()
                           (pdf-view-midnight-minor-mode 1)
                           (setq-local mode-line-format nil)))
  :bind (:map pdf-view-mode-map
			  ("j" . pdf-view-next-line-or-next-page)
  			  ("k" . pdf-view-previous-line-or-previous-page)
  			  ("J" . pdf-view-next-page)
    		  ("K" . pdf-view-previous-page)
    		  ("g" . pdf-view-first-page)
			  ("G" . pdf-view-last-page)
              ("C-d" . pdf-view-scroll-up-or-next-page)
              ("C-u" . pdf-view-scroll-down-or-previous-page)
              ("+" . pdf-view-enlarge)
              ("-" . pdf-view-shrink)
              ("=" . pdf-view-fit-page-to-window)
              ("s" . pdf-view-fit-width-to-window)
              ("m" . pdf-view-set-slice-from-bounding-box)
              ("M" . pdf-view-reset-slice)
              ("i" . pdf-view-midnight-minor-mode)  ;; toggle midnight
              ("y" . pdf-view-kill-ring-save)
              ("/" . isearch-forward)
              ("n" . isearch-repeat-forward)
              ("N" . isearch-repeat-backward)
              ("q" . quit-window))
  :config
  (pdf-tools-install :no-query)
  (setopt pdf-view-display-size 'fit-page
          pdf-view-continuous t
          pdf-view-midnight-colors '("#d8dee9" . "#121212")
          pdf-annot-activate-created-annotations t))

(provide 'config/pdf)
