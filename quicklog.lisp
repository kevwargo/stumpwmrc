(defun quicklog (fmt &rest args)
  (with-open-file (log (data-dir-file "quick" "log")
                       :direction :output
                       :if-exists :append
                       :if-does-not-exist :create)
    (apply 'format log (concat fmt "~%") args)))
