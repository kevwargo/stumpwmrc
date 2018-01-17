(setf *time-modeline-string* "%Y-%m-%d %H:%M:%S")
(setf *screen-mode-line-format*
      (list "%d"))
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

(define-key *root-map* (kbd "m") "mode-line-all-heads-on")
(define-key *root-map* (kbd "M") "mode-line-all-heads-off")

(mode-line-all-heads-on)
