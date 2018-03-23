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

(defcommand show-window-properties () ()
  "Shows the properties of the current window. These properties can be
used for matching windows with run-or-raise or window placement
rules."
  (let ((w (current-window)))
    (if (not w)
        (message "No active window!")
        (message-no-timeout "class: ~A~%instance: ~A~%type: :~A~%role: ~A~%title: ~A~%ID: ~A"
                            (window-class w)
                            (window-res w)
                            (string (window-type w))
                            (window-role w)
                            (window-title w)
                            (window-id w)))))

(define-key *top-map* (kbd "M-H-s") "set-current-window-key")
