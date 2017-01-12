#lang racket

(require racket/place)
(require racket/runtime-path)

(define-runtime-path worker "pmapp_worker.rkt")
;(define pa (build-path (current-directory) "pmapp_worker.rkt"))

(provide pmapp)

(define (transpose lists) ; columns to rows!
  (apply map list lists))

(define (pmapp func . args) ;start places, give work, collect results, stop places.
  
  (define jlist (transpose args))

  (let* ([pls (for/list ([i (in-range (length jlist))])
                (dynamic-place worker 'pmapp-worker ))]
         [wpls (for/list ([j pls] [w jlist])
                (place-channel-put j (append (list func) w)))]         
         [rlist (for/list ([v pls]) (place-channel-get v))]
         [stop (map place-wait pls)])
     rlist
     ))





