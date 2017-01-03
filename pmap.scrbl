#lang scribble/manual


@require[@for-label[pmap
                    racket/base
                    racket/future]]

@title{pmap}
@author{APOS80}

@defmodule[pmap]

@section{General behavior}

pmap works as map but applies the function to every item in the list/lists in parallel using futures.
It's restrictions is the same as for futures and map in general in Racket.

@section{Use}
@racketblock[
    (pmap function list/lists)
    
   >(map + '(1 2 3) '(1 2 3))
   >'(2 4 6)
 ]

If the function applied is to simple pmap might perform worse than map because of the
overhead a future generates.