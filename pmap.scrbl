#lang scribble/manual


@require[@for-label[pmap
                    racket/base
                    racket/future
                    racket/place
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


@racketblock[
    ;Example:
             
   >(pmapp '(lambda (x y)(+ x y) ) '(1 2 3) '(1 2 3))
   >'(2 4 6)

   >(pmapp '(lambda (x y)(fl+ x y) ) '(1.0 2.0 3.0) '(1.0 2.0 3.0))
   >'(2.0 4.0 6.0)
 ]

