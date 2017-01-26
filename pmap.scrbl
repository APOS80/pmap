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

@section{pmap}

@defproc[(pmapf [Proc (procedure?)]
                [list (list?)]
                ...+) list?]

The @racket[pmapf]utures works as @racket[map] but applies the function to every item in the list or lists in parallel using @racket[future]s.


It's restrictions is the same as for @racket[future]s and  @racket[map] in general in Racket.


@racketblock[
    (code:comment ";Example:")
   >(pmapf + '(1 2 3) '(1 2 3))
   >'(2 4 6)
 ]

If the function applied is to simple  @racket[pmapf] might perform worse than  @racket[map] because of the
overhead a @racket[future] generate.

@defproc[(pmapp [Proc (quoted-lambda?)]
                [list (list?)]
                ...+) list?]

The  @racket[pmapp]laces works almost as @racket[map] and applies the function to every item in the list or lists
in parallel using @racket[places]. @racket[places] has some restrictions and that impacts on the
implementation in several ways, @bold{READ ON!}

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

@italic{As of v1.1 pmapp starts a maximum of one place per cpu-core or less if the number of jobs is smaller
than the number of cpu-cores.} 

@racket[pmapp] shows it strength in heavier calculations like approximating the
Mandelbrot set, see the comparison section.

@racketblock[
    (code:comment ";Example_1:")
             
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
    (code:comment ";Example_2:")
   >(define f '(lambda (x y)(+ x y)))
   >(pmapp f '(1 2 3) '(1 2 3))
   >'(2 4 6)

 ]

@defproc[(pmapp-m [Places (exact-nonnegativ-integer?)]
                  [Proc (quoted-lambda?)]
                  [list (list?)]
                  ...+) list?]

@racket[pmapp-m]ax works as @racket[pmapp] but with an aditional parameter setting the max number of places to use.

@section{pmapp-c}
@racket[pmapp-c]ontinuous is @racket[pmapp] in parts. It works like @racket[pmapp] but its set up for continuous work.

@defproc[(pmapp-c-start [Places (exact-nonnegativ-integer?)]
                        ) list?]

@racket[pmapp-c-start] starts a maximum of places given by the parameter.
This is preferebly done in the beginning of the program as the @racket[place]s has a startup time.

@defproc[(pmapp-c [Places (list?)]
                  [Proc (quoted-lambda?)]
                  [list (list?)]
                  ...+) list?]

Works as @racket[pmapp] but with an additional parameter.

@defproc[(pmapp-c-stop [Places (list?)]
                       )list?]

Stops the @racket[place]s started by @racket[pmapp-c-start].

@racketblock[
    (code:comment ";Example:")
   >(define pls (pmapp-c-start 2)) (code:comment ";Start two places")
   >(define f '(lambda (x y)(+ x y)))
   >(pmapp-c pls f '(1 2 3) '(1 2 3)) (code:coment ";Send and recive")
   >'(2 4 6)
   >(pmapp-c-stop pls)(code:comment ";Stops two places")
   >

 ]


@section{Comparison}

We compare here running the core of a Mandelbrot-set computation, using the
code described in @secref["effective-futures" #:doc '(lib "scribblings/guide/guide.scrbl")]
, four times, with @tech["flonum" #:doc '(lib "scribblings/guide/guide.scrbl")]:

@racketblock[
(code:comment "(mandelbrot 10000000 62 500 1000), four calculations")
"(12340.885 ms)"(code:comment "map")
"(8113.297 ms)"(code:comment "pmapf")
"(1727.656 ms)"(code:comment "pmapp")
"(1526.297 ms)"(code:comment "pmapp-m two places")
"(598.170 ms)"(code:comment "pmapp-c four places")
]

@racketblock[
(code:comment "(mandelbrot 100000 62 500 1000), four calculations")
"(149.705 ms)"(code:comment "map")
"(96.563 ms)"(code:comment "pmapf")
"(1588.309 ms)"(code:comment "pmapp")
"(1290.812 ms)"(code:comment "pmapp-m two places")
"(14.502 ms)"(code:comment "pmapp-c four places")
]

As seen above, the number of itterations has significant impact on the performance.

The computations where done with an old "Quad Core 2.4Ghz" CPU. 
