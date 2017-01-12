#lang info
(define collection "pmap")
(define deps '("base"
               "rackunit-lib"))
(define build-deps '("scribble-lib"
                     "racket-doc"
                     "math-doc"))
(define scribblings '(("pmap.scrbl" ())))
(define pkg-desc "Parallel map")
(define version "1.0.1")
(define pkg-authors '(APOS80))
