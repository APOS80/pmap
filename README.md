# pmap
A pmap implementation in Racket inspired from Clojure's pmap. 

Map applies a funcion to an item one at a time, 
pmapf constructs a future for every item thats then run in parallel.
pmapp constructs a place for every item thats then run in parallel.

For heavyer computations the gain is positive, because of the future/place overhead simpler computations will run wors in pmapf/pmapp than in map.

With the help of CarlSmotricz and the racket mailing list! :-)
