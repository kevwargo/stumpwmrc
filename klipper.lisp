(require 'trivial-utf-8)
(require 'cl-base64)
(require 'cl-ppcre)

(defvar *klipper-logfile*
  (data-dir-file "klipper" "log"))

(defvar *klipper-process*
  nil)

(unless *klipper-process*
  (setf *klipper-process*
        (sb-ext:run-program
         (in-stumpwmrc "plasma-workspace-build/klipper/klipper")
         nil
         :wait nil
         :output *klipper-logfile*
         :if-output-exists :append
         :error :output)))


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

(defun klipper-qdbus-cmd (args &optional ignore-output)
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
                   (content-display (cl-ppcre:regex-replace-all
                                     "\\^"
                                     (cl-ppcre:regex-replace-all "[\\r\\n\\t ]+"
                                                                 content
                                                                 " ")
                                     "^^")))
              (make-instance 'klipper-item
                             :uuid uuid
                             :content content
                             :display content-display)))
          (klipper-qdbus-cmd (list "historySlice"
                             (format nil "~@[~a~]" from)
                             (format nil "~d" count)))))


(defclass klipper-menu (single-menu)
  ((item-width :initarg :item-width
               :initform 40
               :accessor klipper-menu-item-width)))

(defclass klipper-item ()
  ((uuid :initarg :uuid
         :accessor klipper-item-uuid)
   (display :initarg :display
            :accessor klipper-item-display)
   (content :initarg :content
            :accessor klipper-item-content)
   (shift :initform 0)))


(defparameter *klipper-menu-map*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "Left") 'klipper-menu-shift-left)
    (define-key m (kbd "Right") 'klipper-menu-shift-right)
    m))


(defmethod initialize-instance :after ((menu klipper-menu) &key initargs)
  (declare (ignore initargs))
  (with-accessors ((keymap menu-keymap))
      menu
    (push *klipper-menu-map* keymap)))

(defmethod klipper-menu-shift-left ((menu klipper-menu))
  (with-slots (selected table)
      menu
    (shift-klipper-item-left (nth selected table))))

(defmethod klipper-menu-shift-right ((menu klipper-menu))
  (with-slots (selected table)
      menu
    (shift-klipper-item-right (nth selected table))))

(defmethod get-menu-items ((menu klipper-menu))
  (mapcar (lambda (item)
            (get-klipper-item-text item menu))
          (subseq (menu-table menu)
                  (menu-view-start menu) (menu-view-end menu))))

(defmethod (setf menu-selected) (value (menu klipper-menu))
  (with-slots (selected table)
      menu
    (and (/= value selected)
         (>= selected 0)
         (< selected (length table))
         (setf (slot-value (nth selected table) 'shift) 0))
    (setf selected value)))


(defmethod get-klipper-item-text ((item klipper-item) (menu klipper-menu))
  (with-slots ((text display) shift)
      item
    (subseq text shift (min (length text)
                            (+ shift (klipper-menu-item-width menu))))))

(defmethod shift-klipper-item-left ((item klipper-item) &optional (amount 1))
  (with-slots (shift)
      item
    (setf shift (- shift amount))
    (if (< shift 0)
        (setf shift 0))))

(defmethod shift-klipper-item-right ((item klipper-item) &optional (amount 1))
  (with-slots ((text display) shift)
      item
    (setf shift (+ shift amount))
    (if (> shift (1- (length text)))
        (setf shift (1- (length text))))))


(defun klipper-match (item-string item-object user-input)
  t)


(defcommand klipper-popup () ()
  (let ((*menu-maximum-height* 20))
    (handler-case
        (let ((item (run-menu (current-screen)
                              (make-instance 'klipper-menu
                                             :table (klipper-history -1)
                                             :item-width 60
                                             :selected 0
                                             :prompt "Klipper contents:"
                                             :view-start 0
                                             :view-end 0
                                             :filter-pred #'klipper-match))))
          (if item
              (klipper-qdbus-cmd (list "moveToTop"
                                       (klipper-item-uuid item))
                                 t)))
      (error (c)
        (message-no-timeout "Error in klipper-popup: ~A" c)))))


(define-key *top-map* (kbd "H-K") "klipper-popup")
