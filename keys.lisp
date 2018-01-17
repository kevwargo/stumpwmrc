(set-prefix-key (kbd "s-x"))

(define-key *top-map* (kbd "XF86AudioPlay") "exec (mocp -i | grep -q 'State: STOP' && mocp -p || mocp -G) || (mocp -S && mocp -p)")
(define-key *top-map* (kbd "XF86AudioPrev") "exec mocp --previous")
(define-key *top-map* (kbd "XF86AudioNext") "exec mocp --next")
(define-key *top-map* (kbd "XF86AudioLowerVolume") "exec amixer -c 0 set Master 2%-")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "exec amixer -c 0 set Master 2%+")
(define-key *top-map* (kbd "XF86AudioMute") "exec amixer set Master toggle")
(define-key *top-map* (kbd "XF86PowerOff") "exec sudo pm-suspend & xscreensaver-command -lock")

(define-key *top-map* (kbd "H-D") "exec xterm -e mocp")
(define-key *top-map* (kbd "H-a") "exec xterm -e alsamixer -c 0")
(define-key *top-map* (kbd "H-x") "exec sudo xterm -e htop")
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
(define-key *root-map* (kbd "c") "exec /mnt/develop/my/cpp/konsole/build/src/konsole")
(define-key *root-map* (kbd "t") "exec xterm")
(define-key *root-map* (kbd "k") "exec krusader")
(define-key *root-map* (kbd "g") "exec google-chrome-stable")
(define-key *root-map* (kbd "L") "loadrc")

(when (boundp '*custom-keys*)
  (loop for key-def in *custom-keys* do
       (eval `(define-key ,@key-def))))
