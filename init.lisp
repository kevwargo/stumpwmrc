(setq *debug-level* 0)

(redirect-all-output (data-dir-file "debug-output" "txt"))

(defparameter *stumpwmrc* *load-truename*)
(defun in-stumpwmrc (path)
  (namestring (merge-pathnames path
                               (directory-namestring *stumpwmrc*))))

(run-shell-command "xset b off")
