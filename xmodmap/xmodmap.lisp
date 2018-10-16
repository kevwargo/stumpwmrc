(defparameter *xmodmap-rc-main* (merge-pathnames "xmodmap.rc" *load-truename*))
(defparameter *xmodmap-rc-audio* (mapcar
                                  (lambda (p) (merge-pathnames p *load-truename*))
                                  (list "xmodmap.audio.orig.rc" "xmodmap.audio.remapped.rc")))
(defparameter *xmodmap-rc-mods* (merge-pathnames "xmodmap.mods.rc" *load-truename*))

(defun xmodmap-load (file)
  (run-shell-command
   (format nil "[ -f ~A ] && xmodmap ~:*~A 2>&1 >> ~A"
           file
           (data-dir-file (pathname-name file) "log"))))

(defcommand reset-mods () ()
  (xmodmap-load *xmodmap-rc-mods*)
  (message "Modifiers reset"))

(defcommand toggle-audio-keys () ()
  (setq *xmodmap-rc-audio* (nreverse *xmodmap-rc-audio*))
  (let ((rc (car *xmodmap-rc-audio*)))
    (xmodmap-load rc)
    (message (format nil "~A loaded." rc))))

(define-key *root-map* (kbd "a") "toggle-audio-keys")
(define-key *root-map* (kbd "X") "reset-mods")

(dolist (file (list
               *xmodmap-rc-main*
               (car *xmodmap-rc-audio*)
               *xmodmap-rc-mods*
               ))
  (xmodmap-load file))

(let ((xmodmap-local (probe-file (merge-pathnames "xmodmap-local.rc" *load-truename*))))
  (if xmodmap-local (xmodmap-load xmodmap-local)))
