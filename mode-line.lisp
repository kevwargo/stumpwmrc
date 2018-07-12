(setf *time-modeline-string* "%Y-%m-%d %H:%M:%S")
(setf *screen-mode-line-format*
      (list "%d %H"))
(setf *mode-line-position* :bottom)
(setf *mode-line-border-width* 10)
(setf *mode-line-border-color* "Gray20")
(setf *mode-line-background-color* "Gray20")
(setf *mode-line-foreground-color* "White")
(setf *mode-line-timeout* 1)

(defcommand mode-line-all-heads-on () ()
  (let ((screen (current-screen)))
    (dolist (head (screen-heads screen))
      (enable-mode-line screen head t))))

(defcommand mode-line-all-heads-off () ()
  (let ((screen (current-screen)))
    (dolist (head (screen-heads screen))
      (enable-mode-line screen head nil))))

(defun amixer-get-master-volume (mode-line)
  (declare (ignore mode-line))
  ;; (let ((process (sb-ext:run-program "/usr/bin/strace"
  ;;                                    (list "-o" "/home/jarasz/amixer-strace.log" "/usr/bin/amixer" "-M" "-c" "0" "get" "Master")
  ;; (let ((process (sb-ext:run-program "/usr/bin/amixer"
  (let ((process (sb-ext:run-program "/mnt/develop/soft/sources/c/alsa-utils-1.1.2/amixer/amixer"
                                     (list "-M" "-c" "0" "get" "Master")
                                     :output :stream
                                     :wait nil
                                     :environment (sb-ext:posix-environ)))
        line)
    (quicklog "amixer process started")
    (loop while (setf line (read-line (sb-ext:process-output process) nil))
       do (multiple-value-bind (matched groups)
              (cl-ppcre:scan-to-strings "([0-9]+)%" line)
            (if matched
                (return (svref groups 0)))))))
    ;; "asdf"))

(add-screen-mode-line-formatter #\A 'amixer-get-master-volume)

(defun mode-line-head-show (ml)
  (format nil "~a" (if (eq (mode-line-head ml)
                           (group-current-head (screen-current-group (current-screen))))
                       "^43CUR^*"
                       "")))
(add-screen-mode-line-formatter #\H 'mode-line-head-show)

(define-key *root-map* (kbd "m") "mode-line-all-heads-on")
(define-key *root-map* (kbd "M") "mode-line-all-heads-off")

(mode-line-all-heads-on)
