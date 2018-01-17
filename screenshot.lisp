(defcommand screenshot () ()
  (let* ((dir "/mnt/other/screens")
         (screen-number
          (1+ (apply 'max
                     (or (mapcar (lambda (p)
                                   (parse-integer
                                    (let ((m (cl-ppcre:all-matches-as-strings
                                              "[0-9]+"
                                              (pathname-name p))))
                                      (if m (car m) "0"))
                                    :junk-allowed t))
                                 (directory (concat dir "/screen*.png")))
                         (list 0))))))
    (run-shell-command (format nil "mkdir -p ~a && import -window root ~a/screen~5,'0d.png" dir dir screen-number))))

(define-key *top-map* (kbd "SunPrint_Screen") "screenshot")
