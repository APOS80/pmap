# pmap
A pmap implementation in Racket inspired from Clojure's pmap. 

Map applies a funcion to an item one at a time, pmap constructs a future for every item that then run in parallel.

For heavyer computations the gain is positive, because of the future overhead simpler computations will run wors in pmap than in map.

With the help of CarlSmotricz its now refined and tuned to perfection! :-)
