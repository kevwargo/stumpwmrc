(setq *debug-level* 0)

(redirect-all-output (data-dir-file "debug-output" "txt"))

(run-shell-command "xscreensaver -no-splash")

(defparameter *stumpwmrc* *load-truename*)
(defun in-stumpwmrc (path)
  (namestring (merge-pathnames path *stumpwmrc*)))
