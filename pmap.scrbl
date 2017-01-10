#lang scribble/manual


@require[@for-label[pmap
                    racket/base
                    racket/future
                    racket/place
                    racket/fixnum
                    math
                    racket/runtime-path]]

@title{pmap}
@author{APOS80}

@defmodule[pmap]

@section{pmapf}

pmapf works as map but applies the function to every item in the list/lists in parallel using futures.
It's restrictions is the same as for futures and map in general in Racket.


@racketblock[
    ;Example:
             
   >(pmapf + '(1 2 3) '(1 2 3))
   >'(2 4 6)
 ]

If the function applied is to simple pmap might perform worse than map because of the
overhead a future generate.


@section{pmapp}

pmapp works almost as map and applies the function to every item in the list/lists in parallel using places.
Places has some restrictions and that impacts on the implementation in several ways, READ ON!

First:
On creation of a place a rkt file is loaded into the new place, that means the uses of the place
is determined of the file and cant be changed by anyone else then the creator. For now it includes racket base, flonum and fixnum.

Second:
A procedure can NOT be passed to a place! Then how do you pass a function, as a list!

pmapp shows it strength in heavyer calcullations like mandelbrot, see the comparison section!

@racketblock[
    ;Example:
             
   >(pmapp '(lambda (x y)(+ x y) ) '(1 2 3) '(1 2 3))
   >'(2 4 6)

   >(pmapp '(lambda (x y)(fl+ x y) ) '(1.0 2.0 3.0) '(1.0 2.0 3.0))
   >'(2.0 4.0 6.0)
 ]

The place file has racket/base, racket/fixnum and math required.

@section{Comparison}

An comparison calcullating two mandelbrot's:
@racketblock[
 "(10000001 10000001) (4976.39990234375 ms)" ;map
 "(10000001 10000001) (4196.400146484375 ms)";pmapf
 "(10000001 10000001) (1840.7998046875 ms)"  ;pmapp
]

An comparison calcullating four mandelbrot's, with flonum:
@racketblock[
 "(10000001 10000001 10000001 10000001) (9752.256591796875 ms)";map
 "(10000001 10000001 10000001 10000001) (8613.47607421875 ms)" ;pmapf
 "(10000001 10000001 10000001 10000001) (1887.66064453125 ms)" ;pmapp
]
