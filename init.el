
;; Dit à GTK+ d'utiliser la variante sombre du thème. Pas valable pour
;; la décoration de fenêtre.
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

;; Poser toujours la même question pour oui ou non.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Configuration des dépôts de paquets emacs
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
	     '("elpy" . "http://jorgenschaefer.github.io/packages/") t)

;; Installation des dépendances de paquets emacs
(defvar my--packages
  '(
    ;; Pour configurer les paquets installés seulement
    use-package
    ;; Mode pour langage de programmation
    coffee-mode
    django-mode
    dockerfile-mode
    less-css-mode
    mmm-mode
    pip-requirements
    yaml-mode
    ;; Combo autocomplétion, validation syntaxique, snippets, etc. pour python
    elpy
    ;; modes pour git
    git-commit-mode
    git-rebase-mode
    magit
    ))

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

   ;; Utiliser uniquement les snippets elpy et perso. Car sinon, on se
   ;; retrouve avec des doublons.
   (setq yas-snippet-dirs
	 (list (expand-file-name "~/.emacs.d/snippets")
	       (concat (file-name-directory (locate-library "elpy"))
		       "snippets/")))
   (yas-reload-all)))

;; Nettoye les espaces superflus
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; Surligne les fins de lignes trop longues
(add-hook 'prog-mode-hook 'highlight-beyond-fill-column)

;; Associations supplémentaires
(add-to-list 'auto-mode-alist
	     '("source/.*\\.txt\\'" . rst-mode))
(add-to-list 'auto-mode-alist
	     '("docs/.*\\.txt\\'" . rst-mode))
(add-to-list 'auto-mode-alist
	     '("CHANGELOG" . rst-mode))
;; Pour salt
(add-to-list 'auto-mode-alist
	     '("\\.sls\\'" . yaml-mode))

;; Activer le mode ReSTructured text dans les docstring
(use-package
 mmm-mode
 :init
 (progn
   (require 'mmm-rst-python)
   (setq mmm-parse-when-idle t)
   (setq mmm-global-mode 'maybe)))

;; Désactiver le mode django, on veut python-mode. django-mode n'est
;; utile que pour les gabarits.
(use-package
 django-mode
 :init
 (progn
   (setq auto-mode-alist
	 (delete
	  '("\\<\\(models\\|views\\|handlers\\|feeds\\|sitemaps\\|admin\\|context_processors\\|urls\\|settings\\|tests\\|assets\\|forms\\)\\.py\\'" . django-mode)
	  auto-mode-alist))))

;; Mode serveur, n'avoir qu'une instance d'emacs. Penser à configurer
;; git pour utiliser emacsclient !
(if (window-system)
    (server-start))

;; C-x # implicite avec C-x k
(defun my--auto-server-edit ()
  (interactive)
  (if server-buffer-clients
      (server-edit)
    (ido-kill-buffer)))
(defun my--bind-auto-server-edit ()
  (local-set-key (kbd "C-x k") 'my--auto-server-edit))
(add-hook 'server-switch-hook 'my--bind-auto-server-edit)
