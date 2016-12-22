#lang racket

(require racket/future)
(require racket/future     
         future-visualizer)

(define f (format "~a" (futures-enabled?))) 
(println (string-append "futures enabled: "  f))

(define pc (format "~a" (processor-count)))
(println (string-append "processor-count: " pc))


(provide pmap)
(provide pmapTwo)

(define (pmap func alist) ; Sort of pmap
  (let* ([f (for/list ([a alist]) (future (lambda () (func a ))) )])
    (for/list ([i f]) (touch i)))
  )

;(visualize-futures ; If function isnt heavy enuf you will get an error, try comment out!
(pmap (lambda (x)(car x)) '((a b)(c d)(e f)))
;)

(define (pmapTwo func alist blist) ; Sort of pmap
  (let* ([f (for/list ([a alist][b blist]) (future (lambda () (func a b))) )])
    (for/list ([i f]) (touch i)))
  )

;(visualize-futures ; If function isnt heavy enuf you will get an error, try comment out!
(pmapTwo (lambda (x y) (* x  y)) '(1 2 3 4 5 6) '(1 2 3 4 5 6))
;)