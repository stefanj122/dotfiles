;;; ac-js2-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "ac-js2" "ac-js2.el" (0 0 0 0))
;;; Generated autoloads from ac-js2.el

(autoload 'ac-js2-expand-function "ac-js2" "\
Expand the function definition left of point.
Expansion will only occur for candidates whose documentation
string contain a function prototype." t nil)

(autoload 'ac-js2-completion-function "ac-js2" "\
Function for `completions-at-point'." nil nil)

(autoload 'ac-js2-company "ac-js2" "\


\(fn COMMAND &optional ARG &rest IGNORED)" t nil)

(autoload 'ac-js2-jump-to-definition "ac-js2" "\
Jump to the definition of an object's property, variable or function.
Navigation to a property definend in an Object literal isn't
implemented." t nil)

(autoload 'ac-js2-mode "ac-js2" "\
A minor mode that provides auto-completion and navigation for Js2-mode.

This is a minor mode.  If called interactively, toggle the `Ac-Js2 mode' mode.
If the prefix argument is positive, enable the mode, and if it is zero or
negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable the mode if ARG
is nil, omitted, or is a positive number.  Disable the mode if ARG is a negative
number.

To check whether the minor mode is enabled in the current buffer, evaluate
`ac-js2-mode'.

The mode's hook is called both when the mode is enabled and when it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "ac-js2" '("ac-js2-"))

;;;***

;;;### (autoloads nil "ac-js2-tests" "ac-js2-tests.el" (0 0 0 0))
;;; Generated autoloads from ac-js2-tests.el

(register-definition-prefixes "ac-js2-tests" '("completion-frontend-test"))

;;;***

;;;### (autoloads nil nil ("ac-js2-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ac-js2-autoloads.el ends here
