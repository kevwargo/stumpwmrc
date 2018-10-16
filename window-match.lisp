(defparameter *window-match-hash* (make-hash-table :test 'equal))

(defclass window-match ()
  ((name :initarg :name :reader window-match-name)
   (var :initarg :var :reader window-match-var)
   (body :initarg :body :reader window-match-body)
   (cmd :initarg :cmd :initform nil :reader window-match-cmd)
   (queue :initform nil :accessor window-match-queue)
   (autostart :initarg :autostart :initform nil :accessor window-match-autostart-p)))

(defmethod window-match-select ((match window-match))
  (let* ((var (window-match-var match))
         (windows (eval
                   `(act-on-matching-windows
                     (,var :group)
                     (progn
                       ,@(window-match-body match))
                     ,var)))
         (queue (setf (window-match-queue match)
                      (delete-if (lambda (w)
                                   (null (member w (group-windows (current-group)))))
                                 (window-match-queue match))))
         w cmd)
    (cond
      ((setq w (find-if (lambda (w)
                          (null (or
                                 (eq (current-window) w)
                                 (member w queue))))
                        windows))
       (setf (window-match-queue match) (append queue (list w)))
       (group-focus-window (current-group) w))
      ((setq w (find-if (lambda (w) (eq w (car queue)))
                        windows))
       (setf (window-match-queue match)
             (append (cdr queue) (list (car queue))))
       (group-focus-window (current-group) w))
      ((setq cmd (window-match-cmd match))
       (when (or
              (window-match-autostart-p match)
              (smart-y-or-n-p (format nil "No window that matches ~A.~%Do you want to run ~A? " (window-match-name match) cmd)))
         (run-shell-command cmd))))))

(defmacro define-window-match (name (var &optional cmd autostart) &rest body)
  `(setf (gethash ,(if (stringp name) name (format nil "~A" name)) *window-match-hash*)
         (make-instance 'window-match
                        :name ',name
                        :var ',var
                        :cmd ,cmd
                        :body ',body
                        :autostart ,autostart)))

(defcommand select-window-by-match
    (name)
    ((:string "Window match name: "))
  (let ((p (gethash name *window-match-hash*)))
    (when p
        (window-match-select p))))

(define-window-match emacs (w "emacsclient -c -a ''")
  (classed-p w "Emacs"))
(define-window-match chrome (w "google-chrome-stable")
  (classed-p w "Google-chrome"))
(define-window-match firefox (w)
  (classed-p w "Firefox"))
(define-window-match konsole (w (in-stumpwmrc "konsole.sh"))
  (classed-p w "konsole"))
(define-window-match krusader (w "krusader")
  (classed-p w "Krusader"))
(define-window-match wireshark (w "sudo wireshark")
  (classed-p w "Wireshark"))
(define-window-match conky (w "conky" t)
  (classed-p w "Conky"))
(define-window-match okular (w)
  (classed-p w "Okular"))
(define-window-match gwenview (w)
  (classed-p w "org.kde.gwenview"))

(define-window-match imv (w)
  (classed-p w "imv"))

(define-window-match lyx (w)
  (classed-p w "lyx"))

(define-window-match ricoh-emulator (w)
  (classed-p w "jp-co-ricoh-dsdk-emulator-Emulator"))

(define-window-match dbeaver (w "/mnt/develop/soft/installed/dbeaver/dbeaver")
  (classed-p w "DBeaver"))

(defun command-matches-p (w cmd)
  (string= (concatenate 'string
                        (mapcar
                         (lambda (x)
                           (code-char (if (= x 0) 32 x)))
                         (let ((prop (window-property w :WM_COMMAND)))
                           (if (null prop)
                               (quicklog "Window ~a has no WM_COMMAND property set." (window-id w)))
                           prop)))
           cmd))

(define-window-match mocp (w "xterm -e mocp" t)
  (command-matches-p w "xterm -e mocp "))

(define-window-match htop (w "sudo xterm -e htop" t)
  (command-matches-p w "xterm -e htop "))

(define-window-match android-studio (w "/mnt/develop/sdk/android-studio/bin/studio.sh")
  (classed-p w "jetbrains-studio"))

(define-window-match lyx-cheat-sheet (w "xterm -e less /mnt/other/info/dox/notes/lyx/cheat-sheet.txt" t)
  (command-matches-p w "xterm -e less /mnt/other/info/dox/notes/lyx/cheat-sheet.txt "))

(define-window-match lyx-edit-cheat-sheet (w "xterm -e emacsclient -nw -a '' /mnt/other/info/dox/notes/lyx/cheat-sheet.txt" t)
  (command-matches-p w "xterm -e emacsclient -nw -a '' /mnt/other/info/dox/notes/lyx/cheat-sheet.txt "))

(define-key *top-map* (kbd "H-f") "select-window-by-match CHROME")
(define-key *top-map* (kbd "H-F") "select-window-by-match FIREFOX")
(define-key *top-map* (kbd "H-e") "select-window-by-match EMACS")
(define-key *top-map* (kbd "H-c") "select-window-by-match KONSOLE")
(define-key *top-map* (kbd "H-z") "select-window-by-match CONKY")
(define-key *top-map* (kbd "H-d") "select-window-by-match KRUSADER")
(define-key *top-map* (kbd "H-r") "select-window-by-match OKULAR")
(define-key *top-map* (kbd "H-w") "select-window-by-match WIRESHARK")
(define-key *top-map* (kbd "H-g") "select-window-by-match GWENVIEW")
(define-key *top-map* (kbd "H-i") "select-window-by-match IMV")
(define-key *top-map* (kbd "H-s") "select-window-by-match LYX")
(define-key *top-map* (kbd "H-S") "select-window-by-match LYX-CHEAT-SHEET")
(define-key *top-map* (kbd "M-H-l") "select-window-by-match LYX-EDIT-CHEAT-SHEET")
(define-key *top-map* (kbd "H-A") "select-window-by-match ANDROID-STUDIO")
(define-key *top-map* (kbd "H-D") "select-window-by-match MOCP")
(define-key *top-map* (kbd "H-x") "select-window-by-match HTOP")
(define-key *top-map* (kbd "H-R") "select-window-by-match RICOH-EMULATOR")
(define-key *top-map* (kbd "H-b") "select-window-by-match DBEAVER")
