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

(provide 'config/llms)
