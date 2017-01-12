#lang scribble/manual


@require[scribble/example
         @for-label[pmap
                    racket
                    racket/base
                    racket/future
                    racket/place
                    ]]

@title{pmap : Parallel map}
@author{APOS80}

@defmodule[pmap]

@section{pmapf}

The @racket[pmapf] works as @racket[map] but applies the function to every item in the list or lists in parallel using @racket[future]s.


It's restrictions is the same as for @racket[future]s and  @racket[map] in general in Racket.


@racketblock[
    ;Example:
             
   >(pmapf + '(1 2 3) '(1 2 3))
   >'(2 4 6)
 ]

If the function applied is to simple  @racket[pmapf] might perform worse than  @racket[map] because of the
overhead a @racket[future] generate.


@section{pmapp}

The  @racket[pmapp] works almost as @racket[map] and applies the function to every item in the list or lists in parallel using @racket[places].
@racket[places] has some restrictions and that impacts on the implementation in several ways, @bold{READ ON!}

The first concern is that only some values, as determined by
@racket[place-message-allowed?] can be sent to another @racket[place]. Unfortunately,
a procedure cannot be sent. The current implementation of @racket[pmapp] demands that
the function sent is explicitly quoted.

Second, on creation of a @racket[place], a @tt{.rkt} file is loaded into the new place,
and one function defined within that file gets executed.
The current implementation of @racket[pmapp] loads a file,
@filepath{pmapp_worker.rkt}, which receives the quoted function, the
arguments for an iteration, and @racket[eval]s the function with these
arguments.   
This means that the bindings available are limited to those which are
@racket[require]d by @filepath{pmapp_worker.rkt}. For now, this includes
@racketmodname[racket], @racketmodname[racket/fixnum] and @racketmodname[math].
Since @filepath{pmapp_worker.rkt} is part of this package, it is not easy to
change these without modifying the package. It should however be possible,
within the body of the quoted function, to use @racket[dynamic-require].

@racket[pmapp] shows it strength in heavier calculations like approximating the
Mandelbrot set, see the comparison section.

@racketblock[
    ;Example_1:
             
   >(pmapp '(lambda (x y)(+ x y) )
           '(1 2 3)
           '(1 2 3))
   >'(2 4 6)

   >(pmapp '(lambda (x y)(fl+ x y) )
           '(1.0 2.0 3.0)
           '(1.0 2.0 3.0))
   >'(2.0 4.0 6.0)
 ]

A more natural way to use it:

@racketblock[
    ;Example_2:

   >(define f '(lambda (x y)(+ x y)))
   >(pmapp f '(1 2 3) '(1 2 3))
   >'(2 4 6)

 ]

@section{Comparison}

We compare here running the core of a Mandelbrot-set computation, using the
code described in @secref["effective-futures" #:doc '(lib "scribblings/guide/guide.scrbl")]
, four times, with @tech["flonum" #:doc '(lib "scribblings/guide/guide.scrbl")]:

@racketblock[
 "(10000001 10000001 10000001 10000001) (10046.46435546875 ms)"(code:comment "map")
 "(10000001 10000001 10000001 10000001) (7410.047607421875 ms)"(code:comment "pmapf")
 "(10000001 10000001 10000001 10000001) (1918.812255859375 ms)"(code:comment "pmapp")
]
