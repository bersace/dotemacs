(require 'elpy)

(defun elpy-large-file ()
  (when (> (buffer-size) 20000)
    (message "Degraded mode for large python file")
    (setq undo-limit 10)
    (make-variable-buffer-local 'mmm-global-mode)
    (setq mmm-global-mode nil)
    (setq-default font-lock-multiline t)
    (elpy-modules-buffer-stop)
    (make-variable-buffer-local 'elpy-modules)
    (setq elpy-modules
	  '(elpy-module-flymake
	    elpy-module-yasnippet
	    elpy-module-pyvenv
	    elpy-module-sane-defaults))
    (elpy-modules-buffer-init)))

(add-hook 'elpy-mode-hook 'elpy-large-file)

(provide 'elpy-large)
