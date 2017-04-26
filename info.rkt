#lang info
(define collection "pmap")
(define deps '("base"
               "rackunit-lib"))
(define build-deps '("scribble-lib"
                     "racket-doc"
                     "math-doc"))
(define scribblings '(["pmap.scrbl" () ("Parallelism")]))
(define pkg-desc "Parallel map")
(define version "1.4")
(define pkg-authors '(APOS80))
