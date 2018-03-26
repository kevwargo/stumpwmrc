(let ((custom-file (probe-file (in-stumpwmrc "custom.lisp"))))
  (if custom-file
      (load custom-file)
      (message "WARNING: no custom.lisp file")))
