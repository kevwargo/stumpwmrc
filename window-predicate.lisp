(defparameter *window-predicate-hash* (make-hash-table :test 'equal))

(defclass window-predicate ()
  ((name :initarg :name :reader window-predicate-name)
   (var :initarg :var :reader window-predicate-var)
   (body :initarg :body :reader window-predicate-body)
   (cmd :initarg :cmd :initform nil :reader window-predicate-cmd)
   (queue :initform nil :accessor window-predicate-queue)))

(defmethod window-predicate-select ((predicate window-predicate))
  (let* ((var (window-predicate-var predicate))
         (windows (eval
                   `(act-on-matching-windows
                     (,var :group)
                     (progn
                       ,@(window-predicate-body predicate))
                     ,var)))
         (queue (setf (window-predicate-queue predicate)
                      (delete-if (lambda (w)
                                   (null (member w (group-windows (current-group)))))
                                 (window-predicate-queue predicate))))
         w cmd)
    (cond
      ((setq w (find-if (lambda (w)
                          (null (or
                                 (eq (current-window) w)
                                 (member w queue))))
                        windows))
       (setf (window-predicate-queue predicate) (append queue (list w)))
       (group-focus-window (current-group) w))
      ((setq w (find-if (lambda (w) (eq w (car queue)))
                        windows))
       (setf (window-predicate-queue predicate)
             (append (cdr queue) (list (car queue))))
       (group-focus-window (current-group) w))
      ((setq cmd (window-predicate-cmd predicate))
       (when (y-or-n-p (format nil "No window that satisfies predicate ~A.~%Do you want to run ~A? " (window-predicate-name predicate) cmd))
         (run-shell-command cmd))))))

(defmacro define-window-predicate (name (var &optional cmd) &rest body)
  `(setf (gethash ,(format nil "~A" name) *window-predicate-hash*)
         (make-instance 'window-predicate
                        :name ',name
                        :var ',var
                        :cmd ',cmd
                        :body ',body)))

(defcommand select-window-by-predicate
    (name)
    ((:string "Window predicate name: "))
  (let ((p (gethash name *window-predicate-hash*)))
    (when p
        (window-predicate-select p))))

(define-window-predicate emacs (w "emacsclient -c -a ''")
  (classed-p w "Emacs"))
(define-window-predicate chrome (w "google-chrome-stable")
  (classed-p w "Google-chrome"))
(define-window-predicate firefox (w)
  (classed-p w "Firefox"))
(define-window-predicate konsole (w "/mnt/develop/my/cpp/konsole/build/src/konsole")
  (classed-p w "konsole"))
(define-window-predicate krusader (w "krusader")
  (classed-p w "Krusader"))
(define-window-predicate wireshark (w "sudo wireshark")
  (classed-p w "Wireshark"))
(define-window-predicate conky (w "conky")
  (classed-p w "Conky"))

(define-key *top-map* (kbd "H-f") "select-window-by-predicate CHROME")
(define-key *top-map* (kbd "H-e") "select-window-by-predicate EMACS")
(define-key *top-map* (kbd "H-c") "select-window-by-predicate KONSOLE")
(define-key *top-map* (kbd "H-s") "select-window-by-predicate SKYPE")
(define-key *top-map* (kbd "H-z") "select-window-by-predicate CONKY")
(define-key *top-map* (kbd "H-k") "select-window-by-predicate KRUSADER")
(define-key *top-map* (kbd "H-r") "select-window-by-predicate CHROME")
(define-key *top-map* (kbd "H-w") "select-window-by-predicate WIRESHARK")
