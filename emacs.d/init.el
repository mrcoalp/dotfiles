;;; init.el --- Initialization file for Emacs

;;; Commentary:
;;Emacs Startup File --- initialization for Emacs

;;; Code:
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;;hide/show things
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode 0)
(show-paren-mode t)
(global-hl-line-mode t)
(global-visual-line-mode 1)
(setq ring-bell-function 'ignore)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(setq mode-require-final-newline t)
(fringe-mode 16)
(winner-mode t)


;;save state
(desktop-save-mode t)
(save-place-mode t)

;;initialize use package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; ;;powerline
;; (use-package powerline
;;   :ensure t
;;   :config(powerline-default-theme))

;;doom-modeline (instead of powerline)
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config(setq doom-modeline-buffer-file-name-style 'file-name))

;;show line numbers in left side
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; UTF-8 as default encoding
(set-language-environment "UTF-8")

;;themes
;;change font name based on system
(if (string-equal system-type "windows-nt")
    (set-frame-font "FiraCode NF 10" nil t)
  (set-frame-font "FiraCode Nerd Font 10" nil t))
    

;; (use-package nimbus-theme
;;   :ensure t
;;   :init(load-theme 'nimbus t))

;; (use-package zenburn-theme
;;   :ensure t
;;   :init(load-theme 'zenburn t))

;; (use-package solarized-theme
;;   :ensure t
;;   :init(load-theme 'solarized-dark t))

(use-package spacemacs-common
  :ensure spacemacs-theme
  :custom
  (spacemacs-theme-comment-bg nil)
  (spacemacs-theme-comment-italic t)
  :config (load-theme 'spacemacs-dark t))

;;set eshell theme
(use-package eshell-git-prompt
  :ensure t
  :config(eshell-git-prompt-use-theme 'git-radar))

;;ensure org-mode
(use-package org
  :ensure t)

;;dired icons
(use-package all-the-icons
  :ensure t)
(use-package all-the-icons-dired
  :ensure t
  :after all-the-icons
  :init(add-hook 'dired-mode-hook 'all-the-icons-dired-mode))
(setq inhibit-compacting-font-caches t)

;;which key helps listing key combs
(use-package which-key
  :ensure t
  :config(which-key-mode))

;;mode icons
(use-package mode-icons
  :ensure t
  :config(mode-icons-mode))

;;magit
(use-package magit
  :ensure t
  :commands (magit-status)
  :bind(("C-x g" . magit-status)))

;;diff-hl
(use-package diff-hl
  :ensure t
  :hook((dired-mode . diff-hl-dired-mode)
	(magit-post-refresh-hook . diff-hl-magit-post-refresh))
  :config (global-diff-hl-mode t))

(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  (smartparens-global-mode))

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package ivy
  :ensure t
  :init (setq ivy-initial-inputs-alist nil)
  :custom (ivy-use-virtual-buffers t)
  :config (ivy-mode 1)
  (use-package flx
    :ensure t))

(use-package dockerfile-mode
  :ensure t
  :init (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))

(use-package yaml-mode
  :ensure t
  :init (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(add-hook 'yaml-mode-hook
      '(lambda ()
        (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;;==========LANGUAGES==========;;
;;utils
(use-package company
  :ensure t
  :custom
  (company-require-match nil)
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.2)
  (company-tooltip-align-annotation t)
  (company-frontends '(company-pseudo-tooltip-frontend
		               company-echo-metadata-frontend))
  :commands (company-mode global-company-mode company-complete
                          company-complete-common company-manual-begin
                          company-grab-line)
  :bind (
         :map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :hook ((prog-mode . company-mode)
         (comint-mode . company-mode)))

(use-package company-quickhelp
  :ensure t
  :after company
  :commands (company-quickhelp-mode)
  :init
  (company-quickhelp-mode 1)
  (use-package pos-tip
    :commands (pos-tip-show)))

;;checks for errors
(use-package flycheck
  :ensure t
  :config (global-flycheck-mode 1)
  :init
  (progn
    (define-fringe-bitmap 'my-flycheck-fringe-indicator
      (vector #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00011100
              #b00111110
              #b00111110
              #b00111110
              #b00011100
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000))

    (flycheck-define-error-level 'error
      :severity 2
      :overlay-category 'flycheck-error-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-error)

    (flycheck-define-error-level 'warning
      :severity 1
      :overlay-category 'flycheck-warning-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-warning)

    (flycheck-define-error-level 'info
      :severity 0
      :overlay-category 'flycheck-info-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-info)))

;;clang
(use-package clang-format
  :ensure t
  :init (fset 'c-indent-region 'clang-format-region))

;;require cc-mode to prevent warning in c++-mode-map
(use-package cc-mode
  :ensure t)

(defun clang-format-region-google (s e)
  "Indent region with provided options.  (S, E)."
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (list (point) (point))))
  (clang-format-region s e "{BasedOnStyle: Google, IndentWidth: 4, SpacesBeforeTrailingComments: 3, DerivePointerAlignment: false, PointerAlignment: Left, ColumnLimit: 0}"))

;;define c++ indent to Ctrl-F10
(define-key c++-mode-map (kbd "C-<f10>") #'clang-format-region-google)

;;snippets
(use-package yasnippet
  :ensure t
  :init (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

;;global needs to be installed in system
(use-package ggtags
  :ensure t
  :config (add-hook 'c-mode-common-hook
		    (lambda ()
		      (when(derived-mode-p 'c-mode 'c++-mode 'java-mode)
			(ggtags-mode 1)))))

;; JavaScript and TypeScript
(use-package js2-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))

(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-formater-before-save)))

(use-package web-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-mode))
  (setq web-mode-enable-current-element-highlight t))

(provide 'init)
;;; init.el ends here
