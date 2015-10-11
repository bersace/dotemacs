(require 'python)
(require 'mmm-mode)

(defun rst-python-statement-is-docstring (begin)
  "Return true if beginning of statiment is :begin"
  (save-excursion
    (save-match-data
      (python-nav-beginning-of-statement)
      (looking-at-p begin))))

(defun rst-python-front-verify ()
  (rst-python-statement-is-docstring (match-string 0)))

(add-to-list 'mmm-save-local-variables 'adaptive-fill-regexp)
(add-to-list 'mmm-save-local-variables 'fill-paragraph-function)

(mmm-add-classes
 '((rst-python-docstrings
    :submode rst-mode
    :face mmm-comment-submode-face
    :front "u?\\(\"\"\"\\|\'\'\'\\)"
    :front-verify rst-python-front-verify
    :back "~1"
    :end-not-begin t
    :save-matches 1
    :insert ((?d embdocstring nil @ "u\"\"\"" @ _ @ "\"\"\"" @))
    :delimiter-mode nil)))

;;;(assq-delete-all 'rst-python-docstrings mmm-classes-alist)

(mmm-add-mode-ext-class 'python-mode nil 'rst-python-docstrings)

(provide 'mmm-rst-python)
