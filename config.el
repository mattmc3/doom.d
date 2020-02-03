;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
;; https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org#customize

;; key mappings: https://github.com/hlissner/doom-emacs/blob/develop/docs/api.org#map

;; Place your private configuration here

;; hide splash screen
(setq inhibit-splash-screen t)

;; font
(setq doom-font (font-spec :family "Meslo LG S for Powerline" :size 13))

;; evil + colemak
(setq-default evil-escape-key-sequence "tn")

;; centaur tabs: https://github.com/ema2159/centaur-tabs
(centaur-tabs-mode t)
(setq centaur-tabs-set-icons t)
(setq centaur-tabs-set-modified-marker t)
(setq centaur-tabs-modified-marker "*")
(setq centaur-tabs-set-bar 'over)
(setq centaur-tabs-gray-out-icons 'buffer)
;;(centaur-tabs-group-by-projectile-project)
;; https://github.com/hlissner/doom-emacs/blob/develop/docs/api.org#map
(define-key evil-normal-state-map (kbd "g t") 'centaur-tabs-forward)
(define-key evil-normal-state-map (kbd "g T") 'centaur-tabs-backward)

;; which-key is the plugin that makes the SPC magic happen in doom
(setq which-key-idle-delay 0.2)

;; editor
;; (setq display-line-numbers-type 'visual)
;; (desktop-save-mode 1)

;; org mode
(setq org-bullets-bullet-list '("◉" "○" "✸" "◈" "✽" "✲"))
(setq org-startup-with-inline-images t)

;; toggle between todo/done
(defun org-toggle-todo-to-done ()
  (interactive)
  (save-excursion
    (org-back-to-heading t) ;; Make sure command works even if point is
                            ;; below target heading
    (cond ((looking-at "\*+ TODO")
           (org-todo "DONE"))
          ((looking-at "\*+ DONE")
           (org-todo "TODO"))
          (t (message "Can only toggle between TODO and DONE.")))))

(map! :map org-mode-map "s-d" 'org-toggle-todo-to-done)

;; projectile
(projectile-add-known-project "~/org")
(setq projectile-project-search-path '("~/Projects/" "~/.config/"))

;; trailing newlines are the bomb
(setq require-final-newline t)

;; real-auto-save
(add-hook 'prog-mode-hook 'real-auto-save-mode)

;; clear buffers I don't want
;; empty *scratch*
(setq initial-scratch-message "")

;; Removes *scratch* from buffer after the mode has been set.
(defun remove-scratch-buffer ()
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*")))
(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

;; Removes *messages* from the buffer.
(setq-default message-log-max nil)
;; (kill-buffer "*Messages*")

;; remove the *doom* buffer
