#lang racket

;pmap is a parallel concurrent map function.
;its inspired of Clojures pmap.

(require racket/future)

(provide pmapf)
;(provide pmapf-old)

(define (transpose lists) ; collumns to rows!
  (apply map list lists))

;(define (pmapf-old func . lists) ; pmapf
;  (map touch
;       (for/list ([a (transpose lists)])
;         (future (lambda () (apply func a)))
;         )))

(define (pmapf func . args)
  (let* ([joblist (transpose args)] ;Transpose list or lists.
         [nofut (if (< (processor-count) (length joblist)) ;Determin amount of futures per iter.
                       (processor-count) (length joblist))]
         [results
          (for/list ([sl (in-slice nofut joblist)]) ;Take slice of jobs to process.
           (map touch
            (for/list ([a sl])
             (future (lambda () (apply func a)))
              ))
            )]
         [cresults (apply append '() results)]) ;Clean results. 
     cresults
     ))


