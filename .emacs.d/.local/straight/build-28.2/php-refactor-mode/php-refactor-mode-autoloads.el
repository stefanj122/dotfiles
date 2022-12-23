;;; php-refactor-mode-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:


;;;### (autoloads nil "php-refactor-mode" "php-refactor-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from php-refactor-mode.el

(autoload 'php-refactor-mode "php-refactor-mode" "\
Minor mode to quickly and safely perform common refactorings.

This is a minor mode.  If called interactively, toggle the
`Php-Refactor mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `php-refactor-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

;;;***

(provide 'php-refactor-mode-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; php-refactor-mode-autoloads.el ends here
