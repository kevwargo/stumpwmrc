(defparameter *xmodmap-rc-main* (merge-pathnames "xmodmap.rc" *load-truename*))
(defparameter *xmodmap-rc-audio* (mapcar
                                  (lambda (p) (merge-pathnames p *load-truename*))
                                  (list "xmodmap.audio.orig.rc" "xmodmap.audio.remapped.rc")))
(defparameter *xmodmap-rc-mods* (merge-pathnames "xmodmap.mods.rc" *load-truename*))

(defcommand reset-mods () ()
  (run-shell-command (format nil "[ -f ~A ] && xmodmap ~:*~A" *xmodmap-rc-mods*))
  (message "Modifiers reset"))

(defcommand toggle-audio-keys () ()
  (setq *xmodmap-rc-audio* (nreverse *xmodmap-rc-audio*))
  (let ((rc (car *xmodmap-rc-audio*)))
    (run-shell-command (format nil "[ -f ~A ] && xmodmap ~:*~A" rc))
    (message (format nil "~A loaded." rc))))

(define-key *root-map* (kbd "a") "toggle-audio-keys")
(define-key *root-map* (kbd "X") "reset-mods")

(run-shell-command (format nil "[ -f ~A ] && xmodmap ~:*~A" *xmodmap-rc-main*))
(run-shell-command (format nil "[ -f ~A ] && xmodmap ~:*~A" (car *xmodmap-rc-audio*)))
(run-shell-command (format nil "[ -f ~A ] && xmodmap ~:*~A" *xmodmap-rc-mods*))

