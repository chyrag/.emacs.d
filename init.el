;;;
;;; William Denton <wtd@pobox.com>
;;;

;; Look at 
;; https://github.com/magnars/.emacs.d
;; https://gitcafe.com/Leaflet/.emacs.d/blob/master/sane-defaults.el
;; And figure out why auctex completion isn't working

;; Only on GitHub, possibly worth getting:
;; google-maps.el http://julien.danjou.info/projects/emacs-packages#google-maps

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode 1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No startup screen
(setq inhibit-startup-message t)

; user-emacs-directory is ~/.emacs.d/
; I keep my local things in ~/.emacs.d/site-lisp/
; and I want everything in there available, including inside subdirectories
(setq site-lisp-dir (expand-file-name "site-lisp" user-emacs-directory))
(let ((default-directory site-lisp-dir)) (normal-top-level-add-subdirs-to-load-path))

; Set up load path
(add-to-list 'load-path user-emacs-directory)
(add-to-list 'load-path site-lisp-dir)

;;; Packages
(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

; Make sure that all of the packages I want are installed. If not, install them.
(setq my-packages '(anzu
		    auctex 
		    auto-complete
		    ;autopair 
		    color-theme-solarized
		    ess 
		    ess-R-object-popup
		    expand-region 
		    flymake-ruby
		    gh
		    gist
		    ibuffer-vc
		    inf-ruby
		    magit
		    markdown-mode 
		    org
		    org-bullets
		    org-reveal
		    pcache
		    rainbow-mode
		    ruby-block
		    ruby-electric
		    ruby-mode 
		    rvm
		    smartparens
		    yaml-mode
		    yasnippet
		    zotelo
		    ))
(when (not package-archive-contents) 
  (package-refresh-contents))
(dolist (p my-packages) 
  (when (not (package-installed-p p)) 
    (package-install p)))

;;; Parentheses-handling stuff

;; Highlight matching parenthesis whenever the point is over one.
(require 'paren)

;; Matches parentheses and such in every mode
(show-paren-mode 1)
(setq show-paren-style 'mixed) ; Values; 'expression, 'parenthesis or 'mixed

;; Make matching parentheses and quotes always appear
;; https://github.com/capitaomorte/autopair
;(require 'autopair)
;(autopair-global-mode) ;; to enable in all buffers

;; smartparens for good handling of parentheses (https://github.com/Fuco1/smartparens/)
(smartparens-global-mode t)
(require 'smartparens-config)

;; Nifty parenthesis thing - hit % to toggle between a pair.
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key "%"             'match-paren)           ; % like vi

;;; General onfigurations

;; Light on dark theme; soothing to my eyes
(load-theme 'solarized-dark t)

;;
(setq default-major-mode 'text-mode)

;;
(setq font-lock-maximum-decoration t)

;; Sentences do not need double spaces to end.
(set-default 'sentence-end-double-space nil)

;; UTF-8 please (surely this is overkill?)
(set-language-environment "UTF-8")
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Proper line wrapping
(global-visual-line-mode 1)

;; Highlight current row
(global-hl-line-mode 1)
;; And set its colour
;; (set-face-background hl-line-face "#efefef")

;; Calendar should start on Monday (not that I ever use the calendar)
(setq calendar-week-start-day 1)

;; I don't want to type in "yes" or "no" - I want y/n.
(fset 'yes-or-no-p 'y-or-n-p)

;; Refresh buffers when files change (don't worry, changes won't be lost)
(global-auto-revert-mode t)

;; Keep a list of recently opened files
(require 'recentf)
(recentf-mode 1)
(global-set-key "\C-xf" 'recentf-open-files)

;; Split window horizontally, not vertically (I prefer side by side with the newer wider screens)
(setq split-height-threshold nil)
(setq split-width-threshold 0)

;; Enable cutting/pasting and putting results into the X clipboard
(global-set-key [(shift delete)] 'clipboard-kill-region)
(global-set-key [(control insert)] 'clipboard-kill-ring-save)
(global-set-key [(shift insert)] 'clipboard-yank)

;; Allow pasting selection outside of Emacs
(setq x-select-enable-clipboard t)

;; M-backspace is backward-word-kill, and C-backspace is bound to that
;; by default.  Change that to backword-kill-line so it deletes from
;; the point to the beginning of the line.
(global-set-key (kbd "C-<backspace>") (lambda ()
  (interactive)
  (kill-line 0)))

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Automatically load a gist in the browser when I post one.
(defvar gist-view-gist 1)

;; Save all of the buffers I'm working on, for next time
(desktop-save-mode 1)
(setq history-length 50)
(setq desktop-buffers-not-to-save
      (concat "\\("
	      "^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
	      "\\|\\.emacs.*\\|\\.diary\\|elpa\/*\\|\\.bbdb"
	      "\\)$"))
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'Info-mode)
(add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)

;; Keep custom settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; nxml for HTML etc.
(add-to-list 'auto-mode-alist
       (cons (concat "\\." (regexp-opt '("xml" "xsd" "sch" "rng" "xslt" "svg" "rss") t) "\\'")
       'nxml-mode))
(fset 'html-mode 'nxml-mode)

(require 'setup-autocomplete)
(require 'setup-ess)
(require 'setup-latex)
(require 'setup-markdown)
(require 'setup-orgmode)
(require 'setup-outline)
(require 'setup-ruby)
(require 'setup-useful-functions) 
(require 'setup-yaml)
(require 'setup-ibuffer)

;; expand-region (see https://github.com/magnars/expand-region.el)
;; C-= successively expands the region with great intelligence
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; Remove trailing whitespace automatically
; (add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Highlight marked text - only works under X.
(transient-mark-mode t)

;; "All strings representing colors will be highlighted with the color they represent."
(rainbow-mode t)

;; Remove text in active region if inserting text
(delete-selection-mode 1)

;; Scroll by one line at a time.
(setq scroll-step 1)

;; Make searches case insensitive.
(setq case-fold-search nil)

;; Down-arrow at the end of a file doesn't add in a new line.
(setq next-line-add-newlines nil)

;; Silently ensure a file ends in a newline when it's saved.
(setq require-final-newline t)

;; Show me empty lines after buffer end
(set-default 'indicate-empty-lines t)

;; Turn on highlighting for search strings.
(setq search-highlight t)

;; Add parts of each file's directory to the buffer name if not unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Make script files executable automatically
; http://www.masteringemacs.org/articles/2011/01/19/script-files-executable-automatically/
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; I'm old enough to be able to use narrow-to-region
(put 'narrow-to-region 'disabled nil)

;; With this, C-x C-j (M-x dired-jump) goes to the current file's position in a dired buffer
;; (http://emacsredux.com/blog/2013/09/24/dired-jump/)
(require 'dired-x)

;; anzu-mode provides a "minor mode which display current point and total matched in various search mode."
;; https://github.com/syohex/emacs-anzu
(global-anzu-mode t)

; In case I experiment with Gnus
(setq gnus-home-directory "~/.emacs.d/gnus.d/")
(setq gnus-directory "~/.emacs.d/gnus.d/News/")
(setq message-directory "~/.emacs.d/gnus.d/Mail/")
(setq nnfolder-directory "~/.emacs.d/gnus.d/Mail/archive/")
(setq gnus-init-file "~/.emacs.d/gnus.d/init.el")
