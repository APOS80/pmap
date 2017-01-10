#lang racket

;pmap is a parallel concurrent map function.
;its inspired of Clojures pmap.

(require racket/future)

(provide pmapf)

(define (transpose lists) ; collumns to rows!
  (apply map list lists))

(define (pmapf func . lists) ; pmap
  (map touch
       (for/list ([a (transpose lists)])
         (future (lambda () (apply func a)))
         )))


