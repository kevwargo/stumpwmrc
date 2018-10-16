(defcommand set-env-var (var val)
    ((:string "Variable: ")
     (:string "Value: "))
  (setf (getenv var) val)
  (message "Env var '~A' set to '~A'" var val))

(setf *input-history-ignore-duplicates* t)
(setf *mouse-focus-policy* :ignore)
