(set-prefix-key (kbd "s-x"))

(define-key *top-map* (kbd "XF86AudioPlay") "exec (mocp -i | grep -q 'State: STOP' && mocp -p || mocp -G) || (mocp -S && mocp -p)")
(define-key *top-map* (kbd "XF86AudioPrev") "exec mocp --previous")
(define-key *top-map* (kbd "XF86AudioNext") "exec mocp --next")
(define-key *top-map* (kbd "H-XF86AudioPrev") "exec mocp -k -2")
(define-key *top-map* (kbd "H-XF86AudioNext") "exec mocp -k 2")
(define-key *top-map* (kbd "H-S-XF86AudioPrev") "exec mocp -k -10")
(define-key *top-map* (kbd "H-S-XF86AudioNext") "exec mocp -k 10")
(define-key *top-map* (kbd "XF86AudioLowerVolume") "exec amixer -c 0 set Master 2%-")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "exec amixer -c 0 set Master 2%+")
(define-key *top-map* (kbd "XF86AudioMute") "exec amixer set Master toggle")
(define-key *top-map* (kbd "XF86PowerOff") "exec sudo pm-suspend & xscreensaver-command -lock")
(define-key *top-map* (kbd "C-XF86PowerOff") "exec sudo pm-suspend")

(define-key *top-map* (kbd "H-a") "exec xterm -e alsamixer -c 0")
(define-key *top-map* (kbd "H-C") "exec kcalc")
(define-key *top-map* (kbd "H-l") "exec xscreensaver-command -lock")

(define-key *top-map* (kbd "s-SPC") "next-in-frame")
(define-key *top-map* (kbd "M-s-SPC") "prev-in-frame")
(define-key *top-map* (kbd "C-s-SPC") "other-in-frame")
(define-key *top-map* (kbd "M-F4") "delete")
(define-key *top-map* (kbd "M-TAB") "pull-hidden-other")
(define-key *top-map* (kbd "H-TAB") "windowlist")

(define-key *top-map* (kbd "H-|") "hsplit")
(define-key *top-map* (kbd "H-_") "vsplit")

(define-key *root-map* (kbd "e") "exec emacsclient -c -a ''")
(define-key *root-map* (kbd "t") "exec xterm")
(define-key *root-map* (kbd "k") "exec krusader")
(define-key *root-map* (kbd "L") "loadrc")

(when (boundp '*custom-keys*)
  (loop for key-def in *custom-keys* do
       (eval `(define-key ,@key-def))))
