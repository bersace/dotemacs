;; Dit à GTK+ d'utiliser la variante sombre du thème. Valable pour la
;; décoration de fenêtre uniqument.
(when (window-system)
  (call-process-shell-command
   (concat "xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT \"dark\" -name "
	   "\"" (cdr (assq 'name (frame-parameters (selected-frame)))) "\"")))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
(add-to-list 'load-path "~/.emacs.d/lisp/")
(defalias 'yes-or-no-p 'y-or-n-p)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Configuration des dépôts de paquets emacs
(require 'package)
(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (message "Installing dependencies... Please wait!")
  (package-refresh-contents))
(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
(require 'use-package)
(setq use-package-verbose nil)

;; Divers modes de programmation
(use-package coffee-mode :ensure t)
(use-package dockerfile-mode :ensure t)
(use-package git-commit-mode :ensure t)
(use-package git-rebase-mode :ensure t)
(use-package less-css-mode :ensure t)
(use-package magit :ensure t)

(use-package
 highlight-beyond-fill-column-face
 :init (add-hook 'prog-mode-hook 'highlight-beyond-fill-column))

(use-package
 yaml-mode :ensure t
 :init (add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode)))

(use-package
 rst-mode
 :init (progn
	 (add-to-list 'auto-mode-alist
		      '("source/.*\\.txt\\'" . rst-mode))
	 (add-to-list 'auto-mode-alist
		      '("docs/.*\\.txt\\'" . rst-mode))
	 (add-to-list 'auto-mode-alist
		      '("CHANGELOG" . rst-mode))))

;; Activer le mode ReSTructured text dans les docstring
(use-package
 mmm-mode :ensure t
 :init (progn
	 (require 'mmm-rst-python)
	 (setq mmm-parse-when-idle t)
	 (setq mmm-global-mode 'maybe)))

(use-package
 elpy :ensure t
 :init (progn
	 (elpy-enable)
	 ;; Configure elpy pour les gros fichiers, sans complétion
	 (defun my--python-large-file ()
	   (when (> (buffer-size) 100000)
	     (message "Degraded mode for large python file")
	     (setq undo-limit 10)
	     (make-variable-buffer-local 'mmm-global-mode)
	     (setq mmm-global-mode nil)
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
	 
	 ;; Éviter les doublons elpy/yasnippet
	 (setq yas-snippet-dirs
	       (list (expand-file-name "~/.emacs.d/snippets")
		     (concat (file-name-directory
			      (locate-library "elpy"))
			     "snippets/")))
	 (yas-reload-all)))

;; Après les installations, fermer la fenêtre de log
(let ((window (get-buffer-window "*Compile-Log*")))
  (when window
    (delete-window window)))

;; Mode serveur. Penser à configurer git pour utiliser emacsclient !
(when (window-system)
  (server-start)
  ;; C-x # implicite avec C-x k
  (defun my--auto-server-edit ()
    (interactive)
    (if server-buffer-clients
	(server-edit)
      (ido-kill-buffer)))
  (defun my--bind-auto-server-edit ()
    (local-set-key (kbd "C-x k") 'my--auto-server-edit))
  (add-hook 'server-switch-hook 'my--bind-auto-server-edit))
