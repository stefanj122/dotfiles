;;; php-cs-fixer-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:


;;;### (autoloads nil "php-cs-fixer" "php-cs-fixer.el" (0 0 0 0))
;;; Generated autoloads from php-cs-fixer.el

(let ((loads (get 'php-cs-fixer 'custom-loads))) (if (member '"php-cs-fixer" loads) nil (put 'php-cs-fixer 'custom-loads (cons '"php-cs-fixer" loads))))

(autoload 'php-cs-fixer-fix "php-cs-fixer" "\
Formats the current PHP buffer according to the PHP-CS-Fixer tool." t nil)

(autoload 'php-cs-fixer-before-save "php-cs-fixer" "\
Used to automatically fix the file saving the buffer.
Add this to .emacs to run php-cs-fix on the current buffer when saving:
 (add-hook 'before-save-hook 'php-cs-fixer-before-save)." t nil)

;;;***

(provide 'php-cs-fixer-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; php-cs-fixer-autoloads.el ends here
