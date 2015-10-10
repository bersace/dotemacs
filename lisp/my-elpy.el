(require 'elpy)

(defun my-elpy-mode ()
  (when (> (buffer-size) elpy-rpc-ignored-buffer-size)
    (message "Degraded elpy mode for large python file")
    (make-variable-buffer-local 'elpy-modules)
    (setq elpy-modules
	  '(elpy-module-sane-defaults
            elpy-module-company
            elpy-module-eldoc
            elpy-module-flymake
            ;; This eat too much CPU cycle
            ;; elpy-module-highlight-indentation
            elpy-module-pyvenv
            elpy-module-yasnippet)))
  (elpy-mode))

(defun my-elpy-enable ()
  "Enable Elpy in all future Python buffers."
  (interactive)
  (elpy-modules-global-init)
  (define-key inferior-python-mode-map (kbd "C-c C-z") 'elpy-shell-switch-to-buffer)
  (add-hook 'python-mode-hook 'my-elpy-mode))

(provide 'my-elpy)
