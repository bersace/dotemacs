;; C-x # implicite avec C-x k
(defun server-auto-edit ()
  (interactive)
  (if server-buffer-clients
      (server-edit)
    (ido-kill-buffer)))

(defun bind-server-auto-edit ()
  (local-set-key (kbd "C-x k") 'server-auto-edit))

(add-hook 'server-switch-hook 'bind-server-auto-edit)

(provide 'server-auto-edit)
