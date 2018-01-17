(run-shell-command "klipper")

(define-key *top-map* (kbd "H-K") "exec qdbus org.kde.klipper /klipper showKlipperPopupMenu")
