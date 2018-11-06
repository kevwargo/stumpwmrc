(defun smart-y-or-n-p (fmt &rest args)
  (echo-string (current-screen) (format nil "~a (y or n)"
                                        (apply 'format nil fmt args)))
  (let ((c (read-one-char (current-screen))))
    (prog1
        (and (characterp c) (char= c #\y))
      (unmap-all-message-windows))))

(defun run-prog-collect-lines (prog &rest opts &key args wait &allow-other-keys)
  (remf opts :args)
  (remf opts :wait)
  (let ((proc (apply #'sb-ext:run-program prog args
                     :output :stream
                     :wait nil
                     opts)))
    (prog1
        (with-open-stream (stream (sb-ext:process-output proc))
          (loop with line
             while (setq line
                         (read-line stream nil nil))
             collect line))
      (if wait (sb-ext:process-wait proc)))))
