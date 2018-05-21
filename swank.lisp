(require :swank)
(swank-loader:init)
(handler-case
    (swank:create-server :port 44005 :style swank:*communication-style* :dont-close t)
  (sb-bsd-sockets:address-in-use-error ()))
