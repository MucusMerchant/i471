#!/usr/bin/env racket

#lang racket

(require rackunit)

(require "lab4-sol.scm")


(define-syntax-rule (check-equal? actual expected)
  (if (equal? actual expected)
      (display (format "okay: ~v: has expected value ~v~%" 'actual 'expected))
      (display (format "fail: ~v: has value ~v not equal to expected value ~v~%"
		       'actual actual 'expected))))
      
(define (ordered-triples1?-tests)
  (check-equal? (ordered-triples1? '((1 2 3) (4 5 6) (4 10 18))) #t)
  (check-equal? (ordered-triples1? '((1 2 2) (4 5 6) (4 10 18))) #f)
  (check-equal? (ordered-triples1? '((1 2 3) (5 5 6) (4 10 18))) #f)
  (check-equal? (ordered-triples1? '((1 2 3) (4 5 6) (4 18 18))) #f)
  (check-equal? (ordered-triples1? '((1 2 3))) #t)
  (check-equal? (ordered-triples1? '((4 2 3))) #f)
  (check-equal? (ordered-triples1? '()) #t)
)
(ordered-triples1?-tests)

(define (ordered-triples2?-tests)
  (check-equal? (ordered-triples2? '((1 2 3) (4 5 6) (4 10 18))) #t)
  (check-equal? (ordered-triples2? '((1 2 2) (4 5 6) (4 10 18))) #f)
  (check-equal? (ordered-triples2? '((1 2 3) (5 5 6) (4 10 18))) #f)
  (check-equal? (ordered-triples2? '((1 2 3) (4 5 6) (4 18 18))) #f)
  (check-equal? (ordered-triples2? '((1 2 3))) #t)
  (check-equal? (ordered-triples2? '((4 2 3))) #f)
  (check-equal? (ordered-triples2? '()) #t)
)
(ordered-triples2?-tests)

(define (map-ordered-triples-tests)
  (check-equal? (map-ordered-triples '((1 2 3) (4 5 6) (4 10 18))) '(#t #t #t))
  (check-equal? (map-ordered-triples '((1 2 2) (4 5 6) (4 10 18))) '(#f #t #t))
  (check-equal? (map-ordered-triples '((1 2 3) (5 5 6) (4 10 18))) '(#t #f #t))
  (check-equal? (map-ordered-triples '((1 2 3) (4 5 6) (4 18 18))) '(#t #t #f))
  (check-equal? (map-ordered-triples '((1 2 3))) '(#t))
  (check-equal? (map-ordered-triples '((4 2 3))) '(#f))
  (check-equal? (map-ordered-triples '()) '())
)
(map-ordered-triples-tests)

(define (ordered-triples3?-tests)
  (check-equal? (ordered-triples3? '((1 2 3) (4 5 6) (4 10 18))) #t)
  (check-equal? (ordered-triples3? '((1 2 2) (4 5 6) (4 10 18))) #f)
  (check-equal? (ordered-triples3? '((1 2 3) (5 5 6) (4 10 18))) #f)
  (check-equal? (ordered-triples3? '((1 2 3) (4 5 6) (4 18 18))) #f)
  (check-equal? (ordered-triples3? '((1 2 3))) #t)
  (check-equal? (ordered-triples3? '((4 2 3))) #f)
  (check-equal? (ordered-triples3? '()) #t)
)
(ordered-triples3?-tests)



