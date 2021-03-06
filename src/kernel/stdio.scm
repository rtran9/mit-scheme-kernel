(import-from "../shared" session-stdio session-pub)

(define (with-stdio session thunk)
  (let ((port (session-stdio session)))
    (with-output-to-port port thunk)))

(define (stdio-write-char port char)
  ((session-pub (port/state port))
   "stream"
   `((name . "stdout")
     (text . ,(char->string char))))
  0)

(define (stdio-write-substring port string start end)
  ((session-pub (port/state port))
   "stream"
   `((name . "stdout")
     (text . ,(substring string start end))))
  0)

(define stdio-port-type
  (make-textual-port-type
   `((write-substring ,stdio-write-substring)
     (write-char ,stdio-write-char))
   #f))

(define (make-stdio session)
  (make-textual-port stdio-port-type session))

(export-to with-stdio make-stdio)