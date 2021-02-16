;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Krasen Penchev"
      user-mail-address "krasen.penchev@protonmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)
(delq! t custom-theme-load-path)

;; Fonts settings
(setq doom-font (font-spec :family "Source Code Pro" :size 16))

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(when (eq initial-window-system 'x)
  (toggle-frame-maximized))

(setq-default major-mode 'org-mode
              delete-by-moving-to-trash t
              uniquify-buffer-name-style 'forward
              window-combination-resize t
              x-stretch-cursor t)

(setq auto-save-default t
      inhibit-compacting-font-caches t
      truncate-string-ellipsis "…"
      enable-recursive-minibuffers t
      kill-whole-line t)

(setq! evil-want-Y-yank-to-eol nil)

(delete-selection-mode 1)
(display-time-mode 1)
(display-battery-mode 1)
(global-subword-mode 1)

;; Ivy settings and bindings
(setq ivy-use-virtual-buffers t)
(setq ivy-read-action-function #'ivy-hydra-read-action)

(map! "C-s" #'+default/search-buffer
      "C-x b" #'counsel-switch-buffer
      "C-x C-f" #'counsel-find-file
      "M-g g" #'avy-goto-line
      "M-g M-g" #'avy-goto-line)

(map! :after magit "C-c C-g" #'magit-status)

(map! "C-x 3" #'(lambda ()
                  (interactive)
                  (split-window-right)
                  (other-window 1)
                  (counsel-switch-buffer)))

(map! "C-z" #'undo-tree-undo
      "C-S-z" #'undo-tree-redo
      "C-M-z" #'undo-tree-visualize)

(setq which-key-idle-delay 0.5)

(defun kp/set-text-mode-abbrev-table ()
  (if (derived-mode-p 'text-mode)
      (setq local-abbrev-table org-mode-abbrev-table)))

(use-package! abbrev
  :init
  (setq-default abbrev-mode 1)
  :commands abbrev-mode
  :hook
  (abbrev-mode . kp/set-text-mode-abbrev-table)
  :config
  (setq abbrev-file-name (expand-file-name "abbrev.el" doom-private-dir)
        save-abbrevs 'silently))

(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2)
  (setq company-show-numbers t))

(use-package! flyspell
  :config
  (setq flyspell-abbrev-p t
        flyspell-issue-message-flag nil
        flyspell-issue-welcome-flag nil))

;; (use-package flyspell-correct
;;   :after flyspell
;;   :bind (:map flyspell-mode-map
;;          ("C-;" . flyspell-correct-wrapper)))

;; (use-package flyspell-correct-popup
;;   :after flyspell-correct)

;; (after! flyspell (require 'flyspell-lazy) (flyspell-lazy-mode 1))

(after! ispell
  (setq ispell-program-name "hunspell")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "bg_BG,en_US")
  (setq ispell-dictionary "bg_BG,en_US"))

(after! text-mode
  (map! :map text-mode-map
        "M-g w" #'avy-goto-word-1
        "M-g M-w" #'avy-goto-word-1))

(add-hook 'text-mode-hook #'(lambda ()
                              (set-fill-column 70)
                              (flyspell-mode 1)))

(after! prog-mode
  (map! :map prog-mode-map
        "M-g w" #'avy-goto-char-2
        "M-g M-w" #'avy-goto-char-2
        "C-h C-f" #'find-function-at-point))

(add-hook 'prog-mode-hook #'(lambda () (set-fill-column 100)))

(after! smartparens
  (add-hook! (clojure-mode
              emacs-lisp-mode
              lisp-mode
              cider-repl-mode) :append #'smartparens-strict-mode)
  (add-hook! smartparens-mode :append #'sp-use-paredit-bindings))

;; (after! lsp-mode
;;   (add-to-list 'exec-path "/home/krasen/elixir-ls/release"))

;; (after! lsp-ui
;;   (setq lsp-ui-doc-max-height 13
;;         lsp-ui-doc-max-width 80
;;         lsp-ui-sideline-ignore-duplicate t
;;         lsp-ui-doc-header t
;;         lsp-ui-doc-include-signature t
;;         lsp-ui-doc-position 'bottom
;;         lsp-ui-doc-use-webkit nil
;;         lsp-ui-flycheck-enable t
;;         lsp-ui-imenu-kind-position 'left
;;         lsp-ui-sideline-code-actions-prefix "💡"
;;         ;; fix for completing candidates not showing after “Enum.”:
;;         company-lsp-match-candidate-predicate #'company-lsp-match-candidate-prefix
;;         ))

;; (use-package! alchemist
;;   :hook (elixir-mode . alchemist-mode)
;;   :config
;;   (set-lookup-handlers! 'elixir-mode
;;     :definition #'alchemist-goto-definition-at-point
;;     :documentation #'alchemist-help-search-at-point)
;;   (set-eval-handler! 'elixir-mode #'alchemist-eval-region)
;;   (set-repl-handler! 'elixir-mode #'alchemist-iex-project-run)
;;   (setq alchemist-mix-env "dev")
;;   (setq alchemist-hooks-compile-on-save t)
;;   (map! :map elixir-mode-map :nv "m" alchemist-mode-keymap))

;; (use-package! lsp
;;   :commands lsp
;;   :hook
;;   (elixir-mode . lsp))

;; (after! lsp-clients
;;   (lsp-register-client
;;    (make-lsp-client :new-connection
;;     (lsp-stdio-connection
;;         "~/elixir-ls/release/language_server.sh")
;;         :major-modes '(elixir-mode)
;;         :priority -1
;;         :server-id 'elixir-ls
;;         :initialized-fn (lambda (workspace)
;;             (with-lsp-workspace workspace
;;              (let ((config `(:elixirLS
;;                              (:mixEnv "dev"
;;                                      :dialyzerEnabled
;;                                      :json-false))))
;;              (lsp--set-configuration config)))))))

;; (after! lsp-ui
;;   (setq lsp-ui-doc-max-height 13
;;         lsp-ui-doc-max-width 80
;;         lsp-ui-sideline-ignore-duplicate t
;;         lsp-ui-doc-header t
;;         lsp-ui-doc-include-signature t
;;         lsp-ui-doc-position 'bottom
;;         lsp-ui-doc-use-webkit nil
;;         lsp-ui-flycheck-enable t
;;         lsp-ui-imenu-kind-position 'left
;;         lsp-ui-sideline-code-actions-prefix "💡"
;;         ;; fix for completing candidates not showing after “Enum.”:
;;         company-lsp-match-candidate-predicate #'company-lsp-match-candidate-prefix
;;         ))

;; (use-package! flycheck-credo
;;   :after flycheck
;;   :config
;;     (flycheck-credo-setup)
;;     (after! lsp-ui
;;       (flycheck-add-next-checker 'lsp-ui 'elixir-credo)))

;; (after! lsp
;;   (add-hook 'elixir-mode-hook
;;             (lambda ()
;;               (add-hook 'before-save-hook 'lsp-format-buffer nil t)
;;               (add-hook 'after-save-hook 'alchemist-iex-reload-module))))
