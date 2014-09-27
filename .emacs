(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(blink-cursor-mode nil)
 '(custom-enabled-themes nil)
 '(doc-view-resolution 300)
 '(font-use-system-font t)
 '(global-linum-mode t)
 '(ido-enable-flex-matching t)
 '(inhibit-startup-echo-area-message t)
 '(initial-scratch-message "")
 '(scroll-error-top-bottom nil)
 '(set-mark-command-repeat-pop nil)
 '(shift-select-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Liberation Mono" :foundry "unknown" :slant normal :weight normal :height 113 :width normal)))))

;; Prevent the cursor from blinking
(blink-cursor-mode 0)
(setq initial-scratch-message "")
(setq inhibit-startup-message t)

(setq inhibit-startup-echo-area-message "xxxx")
(scroll-bar-mode 0)
(tool-bar-mode 0)

;(add-to-list 'load-path "~/.emacs.d/vendor/emacs-powerline")
;(require 'powerline)

;perl
(defalias 'perl-mode 'cperl-mode)

; list buffers in other window and switch to it
(global-set-key (kbd "\C-x\C-b") 'buffer-menu-other-window)

;; put backup files in emacs directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; load files
;(add-to-list 'load-path "~/.emacs.d/")
;(require 'cssh)

;;(require 'ido)
;;(ido-mode t)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; Display ido results vertically, rather than horizontally
  (setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))

 (defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
  (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)
  (defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
    (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
    (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
  (add-hook 'ido-setup-hook 'ido-define-keys)


;;Change "yes or no" to "y or n"
(fset 'yes-or-no-p 'y-or-n-p)

(defun xah-run-current-file ()
  "Execute the current file.
For example, if the current buffer is the file xx.py,
then it'll call “python xx.py” in a shell.
The file can be php, perl, python, ruby, javascript, bash, ocaml, vb, elisp.
File suffix is used to determine what program to run.

If the file is modified, ask if you want to save first.

If the file is emacs lisp, run the byte compiled version if exist."
  (interactive)
  (let* (
         (suffixMap
          `(
            ("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("py3" . ,(if (string-equal system-type "windows-nt") "c:/Python32/python.exe" "python3"))
            ("rb" . "ruby")
            ("js" . "node")             ; node.js
            ("sh" . "bash")
            ("ml" . "ocaml")
            ("vbs" . "cscript")
            )
          )
         (fName (buffer-file-name))
         (fSuffix (file-name-extension fName))
         (progName (cdr (assoc fSuffix suffixMap)))
         (cmdStr (concat progName " \""   fName "\""))
         )

    (when (buffer-modified-p)
      (when (y-or-n-p "Buffer modified. Do you want to save first?")
          (save-buffer) ) )

    (if (string-equal fSuffix "el") ; special case for emacs lisp
        (load (file-name-sans-extension fName))
      (if progName
          (progn
            (message "Running…")
            (shell-command cmdStr "*xah-run-current-file output*" )
            )
        (message "No recognized program file suffix for this file.")
        ) ) ))

(global-set-key (kbd "<f8>") 'xah-run-current-file)
