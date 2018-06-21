(defun smart-y-or-n-p (fmt &rest args)
  (echo-string (current-screen) (format nil "~a (y or n)"
                                        (apply 'format nil fmt args)))
  (let ((c (read-one-char (current-screen))))
    (prog1
        (and (characterp c) (char= c #\y))
      (unmap-all-message-windows))))
      
