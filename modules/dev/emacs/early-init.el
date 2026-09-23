(setopt package-enable-at-startup nil
        inhibit-startup-screen t
        inhibit-startup-message t
        initial-scratch-message nil
        initial-buffer-choice t
        menu-bar-mode nil
        tool-bar-mode nil
        scroll-bar-mode nil
        use-dialog-box nil
        cursor-type 'box
        tab-bar-show nil
        tab-bar-close-button-show nil
        use-short-answers t
        visible-bell nil
        ring-bell-function 'ignore
        indicate-empty-lines t
        show-trailing-whitespace t
        indent-line-function 'insert-tab
        cursor-in-non-selected-windows nil
        highlight-nonselected-windows nil
        kill-do-not-save-duplicates t
        reb-re-syntax 'string
        ffap-machine-p-known 'reject
        window-combination-resize t
        set-mark-command-repeat-pop t
        help-window-select t)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(menu-bar-mode -1)

(set-language-environment "UTF-8")
(set-charset-priority 'unicode)
(setopt locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(set-face-attribute 'default nil
					:family "monospace"
					:height 130
					:weight 'regular)
(set-face-attribute 'variable-pitch nil
					:family "monospace"
					:height 140
					:weight 'regular)
(set-face-attribute 'fixed-pitch nil
					:family "monospace"
					:height 130
					:weight 'regular)
(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil :slant 'italic)
(add-to-list 'default-frame-alist '(font . "monospace-11"))

(setopt line-spacing 0.12)
(set-face-background 'mouse "#ffffff")

(setopt native-comp-async-report-warnings-errors 'silent)
