(defun set-selected-frame-dark ()
  (interactive)
  (call-process-shell-command
   (concat "xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT \"dark\" -name \""
	   (cdr (assq 'name (frame-parameters (selected-frame))))
	   "\"")))

(if (window-system)
    (set-selected-frame-dark))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(backup-by-copying nil)
 '(backup-by-copying-when-linked t)
 '(backup-directory-alist (quote (("." . "~/.emacs.d/saves"))))
 '(column-number-mode t)
 '(custom-enabled-themes (quote (tango-dark)))
 '(fill-column 79)
 '(font-use-system-font t)
 '(global-linum-mode t)
 '(ido-mode (quote both) nil (ido))
 '(inhibit-startup-screen t)
 '(line-number-mode t)
 '(python-fill-docstring-style (quote pep-257-nn))
 '(python-shell-interpreter "ipython")
 '(tool-bar-mode nil)
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight-beyond-fill-column-face ((t (:foreground "red")))))

(add-to-list 'load-path "~/.emacs.d/lisp/")

(defalias 'yes-or-no-p 'y-or-n-p)

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
	     '("elpy" . "http://jorgenschaefer.github.io/packages/") t)

(defvar my--packages
  '(coffee-mode
    django-mode
    dockerfile-mode
    elpy
    fill-column-indicator
    git-commit-mode
    git-rebase-mode
    less-css-mode
    magit
    mmm-mode
    pip-requirements
    use-package
    yaml-mode))

(package-initialize)

(require 'cl)
(defun my--packages-missing ()
  (loop for p in my--packages
	when (not (package-installed-p p)) do (return t)
	finally (return nil)))

(defun my--install-dependencies ()
  (interactive)
  (when (my--packages-missing)
    (message "Installing dependencies... Please wait!")
    (package-refresh-contents)
    (dolist (pack my--packages)
      (unless (package-installed-p pack)
	(package-install pack)))))

(my--install-dependencies)

(require 'use-package)
(setq use-package-verbose nil)

(use-package
 elpy
 :init
 (progn
   (elpy-enable)

   ;; Configure elpy pour les gros fichiers, sans complétion
   (defun my--python-large-file ()
     (when (> (buffer-size) elpy-rpc-large-buffer-size)
       (setq undo-limit 10)
       (setq font-lock-support-mode 'jit-lock-mode)
       (setq jit-lock-stealth-time 16
	     jit-lock-defer-contextually t
	     jit-lock-stealth-nice 1
	     jit-lock-stealh-load 10)
       (setq-default font-lock-multiline t)
       (elpy-modules-buffer-stop)
       (make-variable-buffer-local 'elpy-modules)
       (setq elpy-modules
	     '(elpy-module-flymake
	       elpy-module-yasnippet
	       elpy-module-pyvenv
	       elpy-module-sane-defaults))
       (elpy-modules-buffer-init)))

   (add-hook 'elpy-mode-hook 'my--python-large-file)
   ;; Utiliser uniquement les snippets elpy et perso
   (setq yas-snippet-dirs
	 (list (expand-file-name "~/.emacs.d/snippets")
	       (concat (file-name-directory (locate-library "elpy"))
		       "snippets/")))
   (yas-reload-all)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'prog-mode-hook 'highlight-beyond-fill-column)

(add-to-list 'auto-mode-alist
	     '("docs/.*\\.txt\\'" . rst-mode))
(add-to-list 'auto-mode-alist
	     '("CHANGELOG" . rst-mode))
(add-to-list 'auto-mode-alist
	     '("\\.sls\\'" . yaml-mode))

(use-package
 mmm-mode
 :init
 (require 'mmm-rst-python))

(if (window-system)
    (server-start))

(defun my--auto-server-edit ()
  (interactive)
  (if server-buffer-clients
      (server-edit)
    (ido-kill-buffer)))
(defun my--bind-auto-server-edit ()
  (local-set-key (kbd "C-x k") 'my--auto-server-edit))
(add-hook 'server-switch-hook 'my--bind-auto-server-edit)
