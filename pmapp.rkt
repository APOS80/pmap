#lang racket
;v1.1

(require racket/place)
(require racket/future)
(require racket/runtime-path)

(define-runtime-path worker "pmapp_worker.rkt")
;(define worker (build-path (current-directory) "pmapp_worker.rkt"))

(provide pmapp)
(provide pmapp-m)
(provide pmapp-c-start)
(provide pmapp-c)
(provide pmapp-c-stop)

(define (transpose lists) ; columns to rows!
  (apply map list lists))

(define (pmapp func . args) ;start places, distrebute work, collect results, kill places.   
  (let* ([joblist (transpose args)] ;Transpose list or lists.
         [nopls (if (< (processor-count) (length joblist)) ;Determin amount of places to start.
                       (processor-count) (length joblist))]
         [pls (for/list ([i (in-range nopls)])
                (dynamic-place worker 'pmapp-worker ))] ;Start the places.
         [results ;Send work to places and collect, over and over until done.
          (for/list ([sl (in-slice nopls joblist)]) ;Take slice of jobs to process.
            (for ([wo sl][pl pls]) ;Send jobs to places.
              (place-channel-put pl (append (list func) wo)))
            (for/list ([ra sl][v pls]) (place-channel-get v)) ;Get results from places.
            )]
         [cresults (apply append '() results)] ;Clean results.
         [stop (map place-kill pls)]) ;Kill places. 
     cresults
     ))

;pmapp-max, set maximum places to start.
(define (pmapp-m m func . args) ;start places, distrebute work, collect results, kill places.   
  (let* ([joblist (transpose args)] ;Transpose list or lists.
         [noplsone (if (< (processor-count) (length joblist)) ;Determin amount of places to start.
                       (processor-count) (length joblist))]
         [nopls (if (< m noplsone) (if (= m 0) 1 m) noplsone)]
         [pls (for/list ([i (in-range nopls)])
                (dynamic-place worker 'pmapp-worker ))] ;Start the places.
         [results ;Send work to places and collect, over and over until done.
          (for/list ([sl (in-slice nopls joblist)]) ;Take slice of jobs to process.
            (for ([wo sl][pl pls]) ;Send jobs to places.
              (place-channel-put pl (append (list func) wo)))
            (for/list ([ra sl][v pls]) (place-channel-get v)) ;Get results from places.
            )]
         [cresults (apply append '() results)] ;Clean results.
         [stop (map place-kill pls)]) ;Kill places. 
     cresults
     ))

;pmapp-c, for repetetive calculations.
(define (pmapp-c-start n)
  (let ([nopls (if (< (processor-count) (if (< n 1) 1 n)) ;Determin amount of places to start.
                       (processor-count) n)])
         (for/list ([i (in-range nopls)])
                (dynamic-place worker 'pmapp-worker))));Start the places.

(define (pmapp-c pls func . args)
  (let* ([joblist (transpose args)] ;Transpose list or lists.
         [results ;Send work to places and collect, over and over until done.
           (for/list ([sl (in-slice (length pls) joblist)]) ;Take slice of jobs to process.
            (for ([wo sl][pl pls]) ;Send jobs to places.
              (place-channel-put pl (append (list func) wo)))
            (for/list ([ra sl][v pls]) (place-channel-get v)) ;Get results from places.
            )])
         (apply append '() results))) ;Clean results.)

(define (pmapp-c-stop pls) (map place-kill pls))


