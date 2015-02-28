;; Dit au gestionnaire de fenêtre d'utiliser la variante sombre du thème.
(call-process-shell-command
 (concat "xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT \"dark\" -name "
	 "\"" (cdr (assq 'name (frame-parameters (selected-frame)))) "\""))
(provide 'dark-theme)
