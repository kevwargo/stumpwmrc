(defcommand xbacklight-change (amount) ((:number "Amount: "))
  (run-shell-command (format nil "xbacklight -inc ~A" amount))
  (message (run-shell-command "xbacklight" t)))

(define-key *top-map* (kbd "XF86MonBrightnessDown") "xbacklight-change -10")
(define-key *top-map* (kbd "XF86MonBrightnessUp") "xbacklight-change 10")
