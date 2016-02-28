(add-to-list 'load-path "~/.emacs.d/site-lisp/")

(when (window-system)
  (when (string= "Ubuntu\n" (shell-command-to-string "lsb_release --short --id"))
    (call-process-shell-command "setxkbmap -print | xkbcomp - $DISPLAY" nil 0))
  (require 'dark-theme))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
(defalias 'yes-or-no-p 'y-or-n-p)
(require 'iso-transl)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(when (>= emacs-major-version 24)
  ;; Configuration des dépôts ELPA
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
  (use-package less-css-mode :ensure t)
  (use-package magit :ensure t)

  (use-package
   markdown-mode :ensure t
   :init (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)))

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

  (use-package
    yasnippet :ensure t
    :init (progn
          ;; Ne pas utiliser les snippets par défaut. elpy rajoutera les siens.
          (setq yas-snippet-dirs
                (list (expand-file-name "~/.emacs.d/snippets")))))

  (use-package
    elpy :ensure t
    :init (progn
            (require 'my-elpy)
            (my-elpy-enable)))

  ;; Activer le mode ReSTructured text dans les docstring
  (use-package
   mmm-mode :ensure t
   :init (progn
           ;; Activer le mode ReSTructured text dans les docstring
           (require 'my-mmm-mode)
           (add-hook 'find-file-hook 'my-mmm-mode))))

;; Après les installations, fermer la fenêtre de log
(let ((window (get-buffer-window "*Compile-Log*")))
  (when window
    (delete-window window)))

;; Mode serveur. Penser à configurer git pour utiliser emacsclient !
(when (window-system)
  (server-start)
  (require 'server-auto-edit))
