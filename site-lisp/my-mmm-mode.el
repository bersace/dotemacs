;; (require 'mmm-defaults)
(require 'mmm-rst-python)

(setq mmm-parse-when-idle t)
(setq mmm-global-mode nil)

(defun my-mmm-mode ()
  (if (> (buffer-size) elpy-rpc-ignored-buffer-size)
      (message "Disabling MMM for large file")
    (mmm-mode)))

(provide 'my-mmm-mode)
