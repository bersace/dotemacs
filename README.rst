===============
 Avertissement
===============

Je suis passé à l'excellent `Spacemacs <http://spacemacs.org/>`_ plutôt que de
maintenir ma propre configuration. Je laisse bien sûr ce dépôt pour la
postérité.


==============
 Installation
==============

C'est juste le dossier `.emacs.d` brut. Installer emacs24,
emacs-goodies-el.

.. code-block:: console

   $ git clone https://github.com/bersace/dotemacs.git ~/.emacs.d/


Relancer emacs et c'est bon.

**Attention** Les paquets sont installés à l'initialisation


Emacs sombre
============

Copier le .desktop qui configure emacs avec le thème sombre.

.. code-block:: console

   $ ln ~/.emacs.d/emacs24.desktop ~/.local/share/applications/


Capture d'écran
===============

.. image:: screenshot.png
   :align: center
   :width: 75%


Prose sur mon usage de GNU Emacs
================================

Cette configuration mérite un petit exposé sur mon utilisation d'Emacs. :-)

Étant devops, je travaille sur plusieurs environnements : ma station de travail
avec X11 et des serveurs. Je veux utiliser le même outils, pour travailler dans
des environnements différents sur des technologies différentes (git, python,
php, bash, ansible, salt, jenkins, etc.). Exit donc les éditeurs et IDE
exclusifs ou non graphique. En outre, je veux tirer le maximum du confort de
chaque environnement et limiter les configurations spécifiques d'Emacs et des
envs.

Sur la philosophie de la configuration, je pense qu'il ne fait pas trop
défigurer les logiciels aussi configurable qu'emacs, même si c'est
possible. Cela rends très improductif dès qu'on n'a pas sa conf, par exemple
quand on travaille avec un collègue. C'est plus difficile de mettre à jour la
configuration. Et puis si c'est le collègue qui vient, il est incapable de
faire quoi que ce soit. (Note que c'est souvent le cas à cause du clavier
TypeMatrix BÉPO plus qu'à cause de la conf Emacs).

Et puis Emacs, c'est déjà pas mal de base !!

Sur station graphique, je lance une seule instance d'Emacs qui est
serveur. J'utilise ensuite emacsclient comme éditeur pour développer et pour
git. Je passe beaucoup de temps sur Emacs :-)

Sur serveur, je lance Emacs à la demande tantôt pour des éditions longues,
tantôt pour un simple correctif.

Voici donc les choix que j'ai fait pour répondre à ces besoins :

- Utiliser le plus possible les paquets ELPA plutôt que de copier du lisp.
- Configurer le plus possible avec Customize.
- J'ai choisi l'excellent `elpy <https://github.com/jorgenschaefer/elpy>`_ pour
  le confort de dév python : complétion avec jedi, flake8, coloration de
  l'indentation, snippets, etc.
- J'utilise un thème GTK sombre pour reposer mes yeux.
- Le script `emacslientx
  <https://github.com/bersace/dotemacs/blob/master/emacsclientx>`_ s'occupe de
  me trouver un emacs quand j'en veux un :

  - si un serveur Emacs tourne, ouvrir éventuellement le fichier et changer le
    focus ;
  - sinon, ouvrir Emacs en mode texte, non serveur.
  - Quand je ferme un fichier, que je sois en serveur ou pas, je fais la même
    commande. C'est Emacs qui sait quoi faire.

.. image:: https://imgs.xkcd.com/comics/real_programmers.png
   :align: center
