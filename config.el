;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
;; https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org#customize

;; Place your private configuration here

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
(centaur-tabs-group-by-projectile-project)
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

;; projectile
(projectile-add-known-project "~/org")

;; trailing newlines are the bomb
(setq require-final-newline t)

;; real-auto-save
(add-hook 'prog-mode-hook 'real-auto-save-mode)


;; frame-geometry
(defun frame-geometry/save ()
  "Gets the current frame's geometry and saves to ~/.emacs.d/frame-geometry."
  (let (
        (frame-geometry-left (frame-parameter (selected-frame) 'left))
        (frame-geometry-top (frame-parameter (selected-frame) 'top))
        (frame-geometry-width (frame-parameter (selected-frame) 'width))
        (frame-geometry-height (frame-parameter (selected-frame) 'height))
        (frame-geometry-file (expand-file-name "frame-geometry" user-emacs-directory))
        )

    (when (not (number-or-marker-p frame-geometry-left))
      (setq frame-geometry-left 0))
    (when (not (number-or-marker-p frame-geometry-top))
      (setq frame-geometry-top 0))
    (when (not (number-or-marker-p frame-geometry-width))
      (setq frame-geometry-width 0))
    (when (not (number-or-marker-p frame-geometry-height))
      (setq frame-geometry-height 0))

    (with-temp-buffer
      (insert
       ";;; This is the previous emacs frame's geometry.\n"
       ";;; Last generated " (current-time-string) ".\n"
       "(setq initial-frame-alist\n"
       "      '(\n"
       (format "        (top . %d)\n" (max frame-geometry-top 0))
       (format "        (left . %d)\n" (max frame-geometry-left 0))
       (format "        (width . %d)\n" (max frame-geometry-width 0))
       (format "        (height . %d)))\n" (max frame-geometry-height 0)))
      (when (file-writable-p frame-geometry-file)
        (write-file frame-geometry-file))))
  )

(defun frame-geometry/load ()
  "Loads ~/.emacs.d/frame-geometry which should load the previous frame's geometry."
  (let ((frame-geometry-file (expand-file-name "frame-geometry" user-emacs-directory)))
    (when (file-readable-p frame-geometry-file)
      (load-file frame-geometry-file)))
  )

  ;; add hooks to restore frame size and location, if we are using gui emacs
  (if window-system
      (progn
        (add-hook 'after-init-hook 'frame-geometry/load)
        (add-hook 'kill-emacs-hook 'frame-geometry/save))
    )
