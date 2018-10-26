(defun quicklog (fmt &rest args)
  (with-open-file (log (data-dir-file "quick" "log")
                       :direction :output
                       :if-exists :append
                       :if-does-not-exist :create)
    (multiple-value-bind (s min h d m y) (decode-universal-time (get-universal-time))
      (apply 'format log
             (concat "~2,'0d-~2,'0d-~2,'0d ~2,'0d:~2,'0d:~2,'0d " fmt "~%")
             y m d h min s
             args))))

(defmacro quicklog-safe (fmt &rest args)
  `(handler-case
       (quicklog ,fmt ,@args)
     (error (c)
       (quicklog "Condition in quicklog: ~A" c))))
