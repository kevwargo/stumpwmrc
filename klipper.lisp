(let ((klipper-log (data-dir-file "klipper" "log")))
  (run-shell-command (format nil "klipper >> ~A 2>&1" klipper-log))
  (define-key *top-map* (kbd "H-K") (format nil "exec qdbus org.kde.klipper /klipper showKlipperPopupMenu >> \"~A\" 2>&1" klipper-log)))
