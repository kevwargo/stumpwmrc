(defparameter *additional-cyrillic* (make-hash-table :test 'equal))

(defcommand window-send-raw-keycode
    (keysym &optional (win (current-window)))
    ((:string keysym))
  (let ((key (gethash keysym *additional-cyrillic*)))
    (when key
      (xlib:send-event (window-xwin win) :key-press (xlib:make-event-mask :key-press)
                       :display *display*
                       :root (screen-root (window-screen win))
                       ;; Apparently we need these in here, though they
                       ;; make no sense for a key event.
                       :x 0 :y 0 :root-x 0 :root-y 0
                       :window (window-xwin win) :event-window (window-xwin win)
                       :code (car key)
                       :state (cdr key)))))

(setf (gethash "Cyrillic_io" *additional-cyrillic*) '(247 . 0))
(setf (gethash "Cyrillic_IO" *additional-cyrillic*) '(247 . 1))
(setf (gethash "Ukrainian_ghe_with_upturn" *additional-cyrillic*) '(248 . 0))
(setf (gethash "Ukrainian_GHE_WITH_UPTURN" *additional-cyrillic*) '(248 . 1))
(setf (gethash "Cyrillic_i" *additional-cyrillic*) '(249 . 0))
(setf (gethash "Cyrillic_I" *additional-cyrillic*) '(249 . 1))
(setf (gethash "Cyrillic_shcha" *additional-cyrillic*) '(250 . 0))
(setf (gethash "Cyrillic_SHCHA" *additional-cyrillic*) '(250 . 1))
(setf (gethash "Cyrillic_hardsign" *additional-cyrillic*) '(251 . 0))
(setf (gethash "Cyrillic_HARDSIGN" *additional-cyrillic*) '(251 . 1))
(setf (gethash "Ukrainian_yi" *additional-cyrillic*) '(252 . 0))
(setf (gethash "Ukrainian_YI" *additional-cyrillic*) '(252 . 1))
(setf (gethash "Ukrainian_ie" *additional-cyrillic*) '(253 . 0))
(setf (gethash "Ukrainian_IE" *additional-cyrillic*) '(253 . 1))
(setf (gethash "lcaron" *additional-cyrillic*) '(254 . 0))
(setf (gethash "Lcaron" *additional-cyrillic*) '(254 . 1))

(define-key *top-map* (kbd "s-quoteleft") "window-send-raw-keycode Cyrillic_io")
(define-key *top-map* (kbd "s-~") "window-send-raw-keycode Cyrillic_IO")
(define-key *top-map* (kbd "s-u") "window-send-raw-keycode Ukrainian_ghe_with_upturn")
(define-key *top-map* (kbd "s-U") "window-send-raw-keycode Ukrainian_GHE_WITH_UPTURN")
(define-key *top-map* (kbd "s-b") "window-send-raw-keycode Cyrillic_i")
(define-key *top-map* (kbd "s-B") "window-send-raw-keycode Cyrillic_I")
(define-key *top-map* (kbd "s-o") "window-send-raw-keycode Cyrillic_shcha")
(define-key *top-map* (kbd "s-O") "window-send-raw-keycode Cyrillic_SHCHA")
(define-key *top-map* (kbd "s-]") "window-send-raw-keycode Cyrillic_hardsign")
(define-key *top-map* (kbd "s-}") "window-send-raw-keycode Cyrillic_HARDSIGN")
(define-key *top-map* (kbd "s-quoteright") "window-send-raw-keycode Ukrainian_ie")
(define-key *top-map* (kbd "s-\"") "window-send-raw-keycode Ukrainian_IE")
(define-key *top-map* (kbd "s-s") "window-send-raw-keycode Ukrainian_yi")
(define-key *top-map* (kbd "s-S") "window-send-raw-keycode Ukrainian_YI")
(define-key *top-map* (kbd "s-l") "window-send-raw-keycode lcaron")
(define-key *top-map* (kbd "s-L") "window-send-raw-keycode Lcaron")
