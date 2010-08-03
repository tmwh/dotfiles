(require-and-exec 'vimpulse
  (setq viper-shift-width 4)
  (setq viper-re-search t)
  (setq-default viper-auto-indent t)
  (setq viper-ex-style-editing nil)

  ;; Window keybindings ========================================
  (define-key viper-vi-basic-map (kbd "C-w s") 'split-window-vertically)
  (define-key viper-vi-basic-map (kbd "C-w v") 'split-window-horizontally)
  (define-key viper-vi-basic-map (kbd "C-w o") 'other-window)
  (define-key viper-vi-basic-map (kbd "C-w 1") 'delete-other-windows)
  (define-key viper-vi-basic-map (kbd "C-w d") 'delete-window)
  (define-key viper-vi-basic-map (kbd "C-w m") 'maximize)
  (define-key viper-vi-basic-map (kbd "C-w f") 'fullscreen-toggle)
  (define-key viper-vi-basic-map (kbd "C-w <return>") 'enlarge-window)
  (define-key viper-vi-basic-map (kbd "C-w =") 'enlarge-window-horizontally)
  ;; ============================================================

  ;; fix viper/vimpulse binding shortcomings ==========
  (define-key viper-vi-global-user-map (kbd "_") 'viper-bol-and-skip-white)
  (define-key viper-vi-global-user-map (kbd "+") 'viper-next-line-at-bol)
  (define-key viper-vi-global-user-map (kbd "Y") (kbd "y$")) ; oh why are you compatible to THAT?!
  (define-key viper-insert-global-user-map (kbd "C-h") 'backward-delete-char)
  (when (fboundp 'redo)
    (define-key viper-vi-global-user-map (kbd "r") 'redo))
  (require-and-exec 'goto-last-change
     (define-key viper-vi-global-user-map (kbd "g i") 'goto-last-change))
  (define-key viper-vi-global-user-map (kbd "SPC") 'viper-scroll-up)
  (define-key viper-vi-global-user-map (kbd "S-SPC") 'viper-scroll-down)
  ;; ==================================================

  ;; Mapleader ========================================
  (defconst vim-mapleader "," "Mapping prefix
Vanilla in vi-state; Prefixed witf `C-' in insert-state")
  (defvar vim-mapleader-map (make-sparse-keymap) "Mapleader keymap")
  ;; <leader> key in normal-mode
  (define-key viper-vi-global-user-map vim-mapleader vim-mapleader-map)
  ;; C-<leader> key in insert-mode
  (define-key viper-insert-global-user-map (read-kbd-macro
                                            (format "C-%s" vim-mapleader))
                                           vim-mapleader-map)
  (defun vim-mapleader-add (keyseq fun)
    (interactive "kKeysequence: \naFunction:")
    (define-key vim-mapleader-map keyseq fun))

  (vim-mapleader-add "e" 'ido-find-file)
  (vim-mapleader-add "b" 'ido-switch-buffer)
  (vim-mapleader-add "w" 'save-buffer)
  (vim-mapleader-add "W" 'save-some-buffers)
  (vim-mapleader-add "d" 'dired-jump)
  (vim-mapleader-add "k" 'kill-buffer-and-window)
  (vim-mapleader-add "K" 'kill-buffer)
  (vim-mapleader-add "C" 'cofi-cd-alias)
  (vim-mapleader-add "D" 'cofi-dired-alias)
  ;; ==================================================

  ;; Vim-like backspace (backspace=indent,eol,start) ==========
  (require-and-exec 'sackspace
    ;; this interferes with ido's backspace (wtf?)
    (define-key viper-insert-global-user-map (kbd "<backspace>") 'sack/backspace)
    (define-key viper-insert-global-user-map (kbd "C-<backspace>") 'sack/hyper-sack))
  ;; ==================================================

  ;; Search keybindings ========================================
  (define-key viper-vi-global-user-map (kbd "C-r") 'isearch-backward-regexp)
  (define-key viper-vi-global-user-map (kbd "C-s") 'isearch-forward-regexp)
  (define-key viper-vi-basic-map (kbd "/") 'isearch-forward-regexp)
  (define-key viper-vi-basic-map (kbd "?") 'isearch-backward-regexp)
  (define-key viper-vi-basic-map (kbd "n") 'isearch-repeat-forward)
  (define-key viper-vi-basic-map (kbd "N") 'isearch-repeat-backward)
  (define-key isearch-mode-map (kbd "C-n") 'isearch-repeat-forward)
  (define-key isearch-mode-map (kbd "C-p") 'isearch-repeat-backward)
  (push '("nohighlight" (isearch-done)) ex-token-alist)
  ;; ==================================================

  ;; Additional Modes ================================
  (define-key viper-emacs-global-user-map (kbd "\\") 'viper-escape-to-vi)
  
  (push 'magit-mode viper-emacs-state-mode-list)
  ;; ==================================================

  ;; Conflicts ========================================
  (define-key viper-insert-basic-map (kbd "C-d") nil) ; conflicts with yasnippet
  ;; ==================================================

  ;; Misc ========================================
  (eval-after-load "org"
    '(progn
       (define-key viper-vi-global-user-map (kbd "C-c /") 'org-sparse-tree)
       (add-hook 'org-mode-hook
                 (lambda ()
                   (viper-add-local-keys 'vi-state '(("RET" . org-open-at-point)))
                   (viper-add-local-keys 'insert-state '(("\M-l" . org-metaright)
                                                         ("\M-h" . org-metaleft)
                                                         ))))))

  )

(provide 'cofi-vim)
