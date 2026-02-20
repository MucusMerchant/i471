#!/usr/bin/env racket

;; To load into the REPL, type
;;    ,enter "lab4-sol.scm"
;; at the REPL > prompt.  This will put you in the module context and
;; you can type expressions involving the module functions.

#lang racket

(provide ordered-triples1?
	 ordered-triples2?
	 map-ordered-triples
	 ordered-triples3?
)

;; to trace function fn, add (trace fn) after fn's definition
(require racket/trace)  


;; Given a list `triples` of number triples, the predicate
;; (ordered-triples1?  triples)` should return `#t` iff every triple
;; (n1 n2 n3)` in `triples` is strictly ordered with `n1 < n2` and `n2
;; < n3`.  It should return `#f` if there is some triple in `triples`
;; which is not strictly ordered.
(define (ordered-triples1? triples)
  (if (null? triples) #t
  (and (match (car triples)
    [(list a b c) (< a b c)]
    [_ #f])
    (ordered-triples1? (cdr triples))
  )))


;; Given a list `triples` of number triples, the predicate
;; (ordered-triples2?  triples)` should return `#t` iff every triple
;; (n1 n2 n3)` in `triples` is strictly ordered with `n1 < n2` and `n2
;; < n3`.  It should return `#f` if there is some triple in `triples`
;; which is not strictly ordered.  All recursion *must* be tail-recursive.
(define (ordered-triples2? triples)
  (define (aux-ordered-triples2 sub ls)
    (if (or (eq? sub #f) (null? ls))
      sub
      (aux-ordered-triples2 (match (car ls) [(list a b c) (< a b c)] [_ #f]) (cdr ls))
    ))
  (aux-ordered-triples2 #t triples)
  )


;; Given a list `triples` of number triples, the function
;; `(map-ordered-triples triples)` returns a list of booleans having
;; the same length as `triples` with an element in the returned list
;; being `#t` iff the corresponding triple in `triples` is strictly
;; ordered.  Cannot directly use recursion.
(define (map-ordered-triples triples)
  (map (lambda (n) (and (< (car n) (cadr n)) (< (cadr n) (caddr n)))) triples)
  )



;; The predicate `(ordered-triples3? triples)` with the same
;; specification as the earlier `ordered-triples[12]` but must
;; be implemented using `foldl`.
(define (ordered-triples3? triples)
  (foldl (lambda (n acc) (and acc (and (< (car n) (cadr n)) (< (cadr n) (caddr n))))) #t triples)
  )

