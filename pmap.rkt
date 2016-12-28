#lang racket

;pmap is a parallel concurrent map function.
;its inspired of Clojures pmap.

(require racket/future)

(provide pmap)

(define (transpose lists) ; collumns to rows!
  (apply map list lists))

;(transpose '((1 3 5) (2 4 6))) ; test

(define (pmap func . lists) ; pmap
  (map touch
       (for/list ([a (transpose lists)])
         (future (lambda () (apply func a)))
         )))

;(pmap (lambda (x)(car x)) '((a b)(c d)(e f))) ; a test
;(pmap * '(1 2 3 4 5 6 7 8 9) '(1 2 3 4 5 6 7 8 9)) ; a nother test
;(pmap (lambda (x y) (* x y)) '(1 2 3 4 5 6 7 8 9) '(1 2 3 4 5 6 7 8 9)) ; yet a nother test!