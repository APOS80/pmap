#lang racket

;pmap is a parallel concurrent map function.
;its inspired of Clojures pmap.

(require racket/future)

(provide pmap1)
(provide pmap2)

(define (pmap1 func alist) ; pmap for one list
  (map touch
       (for/list ([a alist])
         (future (lambda () (func a )))
         ))
  )

;(pmap1 (lambda (x)(car x)) '((a b)(c d)(e f))) ; a test


(define (pmap2 func alist blist) ; pmap for two lists
  (map touch
       (for/list ([a alist][b blist])
         (future (lambda () (func a b)))
         ))
  )

;(pmap2 (lambda (x y) (* x y)) '(1 2 3 4 5 6 7 8 9) '(1 2 3 4 5 6 7 8 9)) ; a test