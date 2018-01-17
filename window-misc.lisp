(defcommand select-window-by-id (id) ((:number "Window id: "))
  (let ((win
         (find-if (lambda (w) (eq (window-id w) id))
                  (group-windows (current-group)))))
    (if win
        (group-focus-window (current-group) win))))

(defcommand set-current-window-key (key) ((:key-seq "Window key: "))
  (let ((cmd (format nil "select-window-by-id ~d" (window-id (current-window)))))
    (when (and key (car key))
      (define-key *top-map* (car key) cmd))))


(define-key *top-map* (kbd "M-H-s") "set-current-window-key")
