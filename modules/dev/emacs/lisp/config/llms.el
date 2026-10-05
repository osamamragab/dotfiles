;;; -*- lexical-binding: t; -*-

(use-package gptel
  :config
  (defun my/openrouter-api-key ()
    "Read OpenRouter API key from pass"
    (or (bound-and-true-p my/--openrouter-key)
        (setq my/--openrouter-key
              (string-trim
                (shell-command-to-string "pass acc/openrouter.ai | sed -n 's/api_key:\s\+\?\(.*\)/\1/p'")))))
  (setq gptel-default-mode 'org-mode)
  (setq gptel-backend
        (gptel-make-openai "OpenRouter"
          :host "openrouter.ai"
          :endpoint "/api/v1/chat/completions"
          :stream t
          :key #'my/openrouter-api-key
          :models '(qwen/qwen3.8-27b:free
                    meta-llama/llama-3.3-70b-instruct:free
                    mistralai/mistral-small-3.1-24b-instruct:free
                    google/gemma-3-27b-it:free))))

(use-package codeium
    :init
    (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
    :config
    (setopt use-dialog-box nil)
    (setopt codeium-mode-line-enable
            (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
    (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
    (setopt codeium-api-enabled
            (lambda (api)
              (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
    (defun my-codeium/document/text ()
      (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
    ;; if you change the text, you should also change the cursor_offset
    ;; warning: this is measured by UTF-8 encoded bytes
    (defun my-codeium/document/cursor_offset ()
      (codeium-utf8-byte-length
        (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
    (setopt codeium/document/text 'my-codeium/document/text)
    (setopt codeium/document/cursor_offset 'my-codeium/document/cursor_offset))

(provide 'config/llms)
