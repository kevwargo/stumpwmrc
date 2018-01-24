(defvar *xev-frame* nil)
(defvar *xev-group-dump* nil)

(defun handle-xev-open (w)
  (when (and
         (string= (window-title w) "Event Tester")
         (null (window-class w))
         *xev-frame*)
    (pull-window w *xev-frame*)
    (remove-hook *new-window-hook* 'handle-xev-open)
    (setq *xev-frame* nil)))

(defun handle-xev-destroy (w)
  (when (and (string= (prog2
                          (quicklog "before (window-title w) ~A" w)
                          (window-title w)
                        (quicklog "done.")) "Event Tester")
             (null (prog2
                       (quicklog "before (window-class w) ~A" w)
                       (window-class w)
                     (quicklog "done.")))
             *xev-group-dump*)
    (prog2
        (quicklog "before (restore-group (window-group w) *xev-group-dump*) ~A" w)
        (restore-group (prog2
                           (quicklog "before (window-group w) ~A" w)
                           (window-group w)
                         (quicklog "done.")) *xev-group-dump*)
      (quicklog "done."))
    (setq *xev-group-dump* nil)
    (remove-hook *destroy-window-hook* 'handle-xev-destroy)))

(defcommand run-xev () ()
  (setq *xev-group-dump* (dump-group (current-group)))
  (let* ((group (current-group))
         (current-frame (tile-group-current-frame group))
         (frames (head-frames group (current-head)))
         (frame-count (length frames))
         (xterm-frame current-frame)
         xev-frame)
    (cond
      ((eq frame-count 1)
       (setq xev-frame (frame-by-number group (split-frame group :column))))
      ((> frame-count 1)
       (setq xev-frame
             (or (neighbour :left current-frame frames)
                 (neighbour :right current-frame frames)
                 (neighbour :down current-frame frames)
                 (neighbour :up current-frame frames)))))
    ;; (focus-frame group xterm-frame)
    (setq *xev-frame* xev-frame)
    (add-hook *new-window-hook* 'handle-xev-open)
    (add-hook *destroy-window-hook* 'handle-xev-destroy)
    (run-shell-command "xterm -e 'xev | nl'")))

