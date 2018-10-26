(defcommand debug-level-set (level)
    ((:number "Debug level: "))
  (setf *debug-level* level)
  (message "Current debug-level: ~A" level))

(defcommand debug-level-inc () ()
  (debug-level-set (1+ *debug-level*)))

(defcommand debug-level-dec () ()
  (debug-level-set (1- *debug-level*)))

(define-key *root-map* (kbd "=") "debug-level-inc")
(define-key *root-map* (kbd "-") "debug-level-dec")
