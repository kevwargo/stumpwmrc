(defcommand aws-cli-help
    (cmd) ((:string "Command: "))
  (run-shell-command (format nil "xterm -e 'aws ~A help'" cmd)))
