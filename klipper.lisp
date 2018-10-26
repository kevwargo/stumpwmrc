(require 'trivial-utf-8)
(require 'cl-base64)
(require 'cl-ppcre)

(let ((klipper-log (data-dir-file "klipper" "log")))
  (run-shell-command (format nil "/var/tmp/portage/kde-plasma/plasma-workspace-5.12.3/work/plasma-workspace-5.12.3_build/klipper/klipper >> ~A 2>&1" klipper-log)))

(defun run-prog-collect-lines (prog &rest opts &key args wait &allow-other-keys)
  (remf opts :args)
  (remf opts :wait)
  (let ((proc (apply #'sb-ext:run-program prog args
                     :output :stream
                     :wait nil
                     opts)))
    (prog1
        (loop with line
           while (setq line
                       (read-line (sb-ext:process-output proc) nil nil))
           collect line)
      (if wait (sb-ext:process-wait proc)))))

(defun klipper-run (args &optional ignore-output)
  (apply (if ignore-output
             #'run-prog
             #'run-prog-collect-lines)
         "qdbus"
         :args (append (list "org.kde.klipper" "/klipper") args)
         :search t
         nil))

(defun klipper-history (count &optional from)
  (mapcar (lambda (line)
            (let* ((raw-item (split-string line " "))
                   (uuid (car raw-item))
                   (content (if (= (length raw-item) 2)
                                (trivial-utf-8:utf-8-bytes-to-string
                                 (cl-base64:base64-string-to-usb8-array (cadr raw-item)))
                                ""))
                   (content-display (cl-ppcre:regex-replace-all "[\\r\\n\\t ]+"
                                                                content
                                                                " ")))
              (setq content-display (subseq content-display 0
                                            (min 40 (length content-display))))
              (list content-display content uuid)))
          (klipper-run (list "historySlice"
                             (format nil "~@[~a~]" from)
                             (format nil "~d" count)))))

(defcommand klipper-popup () ()
  (let* ((items (klipper-history -1))
         (*menu-maximum-height* 30))
    (handler-case
        (let* ((item (select-from-menu (current-screen) items
                                       "Klipper contents:")))
          (klipper-run (list "moveToTop" (nth 2 item)) t))
      (error (c)
        (message "Error in klipper-popup: ~A" c)))))

(define-key *top-map* (kbd "H-K") "klipper-popup")
