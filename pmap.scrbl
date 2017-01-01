#lang scribble/manual
@require[@for-label[pmap
                    racket/base
                    racket/future]]

@title{pmap}
@author{APOS80}

@defmodule[pmap]

"pmap" is a map function using futures to apply a function to all items in a list i parallel.

It's restrictions is the same as for futures in general in Racket.
