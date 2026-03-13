#!/usr/bin/env racket

#lang racket

(require rackunit)

(require "prj2-sol.scm")


(define-syntax-rule (check-equal? actual expected)
  (if (equal? actual expected)
      (display (format "okay: ~v: has expected value ~v~%" 'actual expected))
      (display (format "fail: ~v: has value ~v not equal to expected value ~v~%"
		       'actual actual expected))))
      
(define (nth-tests)
  (check-equal? (nth '() 0) 0)
  (check-equal? (nth '() 0 22) 22)
  (check-equal? (nth '(1 2 3 4) 1) 2)
  (check-equal? (nth '(1 1 1 1) 3) 1)
  (check-equal? (nth '(1 1 1 1) 4) 0)
  (check-equal? (nth '(1 1 1 1) 4 42) 42)
)

(define (count-pairs-tests)
  (check-equal? (count-pairs 'a) 0)
  (check-equal? (count-pairs '()) 0)
  (check-equal? (count-pairs '(a . b)) 1)
  (check-equal? (count-pairs '(a b)) 2)
  (check-equal? (count-pairs '((a) b)) 3)
  (check-equal? (count-pairs '((a) . b)) 2)
  (check-equal? (count-pairs '((a) (b))) 4)
  (check-equal? (count-pairs '((a) (b . (c)) (b))) 7)
)

(define (tetrate-tests)
  (check-equal? (tetrate 1 8) 1)
  (check-equal? (tetrate 2 0) 1)
  (check-equal? (tetrate 2 1) 2)
  (check-equal? (tetrate 2 2) 4)
  (check-equal? (tetrate 2 3) 16)
  (check-equal? (tetrate 2 4) 65536)
  (check-equal? (tetrate 3 2) 27)
  (check-equal? (tetrate 3 3) (expt 3 27))
)

(define (expt-list1-tests)
  (check-equal? (expt-list1 '()) 1)
  (check-equal? (expt-list1 '(5)) 5)
  (check-equal? (expt-list1 '(3 2 2)) 81)
  (check-equal? (expt-list1 '(2 2 2 2)) 65536)
  (check-equal? (expt-list1 '(3 3 2)) 19683)
  (check-equal? (expt-list1 '(3 3 3)) (expt 3 27))
)

(define (expt-list2-tests)
  (check-equal? (expt-list2 '()) 1)
  (check-equal? (expt-list2 '(5)) 5)
  (check-equal? (expt-list2 '(3 2 2)) 81)
  (check-equal? (expt-list2 '(2 2 2 2)) 65536)
  (check-equal? (expt-list2 '(3 3 2)) 19683)
  (check-equal? (expt-list2 '(3 3 3)) (expt 3 27))
)

(define (fill-list-tests)
  (check-equal? (fill-list 0) '())
  (check-equal? (fill-list 1) '(0))
  (check-equal? (fill-list 4) '(0 0 0 0))
  (check-equal? (fill-list 1 '(a)) '((a)))
  (check-equal? (fill-list 3 '(a)) '((a) (a) (a)))
)

(define (strip-end-eq-tests)
  (check-equal? (strip-end-eq '(1 2 3)) '(1 2 3))
  (check-equal? (strip-end-eq '(1 2 0)) '(1 2))
  (check-equal? (strip-end-eq '(1 0 0)) '(1))
  (check-equal? (strip-end-eq '(0 0 0)) '())
  (check-equal? (strip-end-eq '(22 22 22) 22) '())
  (check-equal? (strip-end-eq '(a b c c c) 'c) '(a b))
  (check-equal? (strip-end-eq '()) '())
)

(define (int-pairs-tests)
  (check-equal? (int-pairs 3) '((0 3) (1 2) (2 1) (3 0)))
  (check-equal? (int-pairs 1) '((0 1) (1 0)))
  (check-equal? (int-pairs 0) '((0 0)))
)

(define (add-coeffs-tests)
  (check-equal? (add-coeffs '(1 2) '(3 4)) '(4 6))
  (check-equal? (add-coeffs '(1 2) '(3 4 5)) '(4 6 5))
  (check-equal? (add-coeffs '(3 4 5) '(1 2)) '(4 6 5))
  (check-equal? (add-coeffs '(1 2) '(3 -2)) '(4))
  (check-equal? (add-coeffs '(1 2) '(-1 -2)) '())
  (check-equal? (add-coeffs '(1 2) '()) '(1 2))
  (check-equal? (add-coeffs '() '(1 2)) '(1 2))  
)

(define (product-coeff-tests)

 (check-equal? (product-coeff '() '(1 2 3) 0) 0)
 (check-equal? (product-coeff '(1 2 3) '() 0) 0)

 (check-equal? (product-coeff '(3 4 5) '(2) 0) 6)
 (check-equal? (product-coeff '(3 4 5) '(2) 1) 8)
 (check-equal? (product-coeff '(3 4 5) '(2) 2) 10)
 (check-equal? (product-coeff '(3 4 5) '(2) 3) 0)

  
  ;https://www.wolframalpha.com/input?i=%281+%2B+2*x%29*%283+%2B+4*x+%2B+5*x%5E2+%2B+6*x%5E3%29
  (check-equal? (product-coeff '(1 2) '(3 4 5 6) 0) 3)
  (check-equal? (product-coeff '(1 2) '(3 4 5 6) 1) 10)
  (check-equal? (product-coeff '(1 2) '(3 4 5 6) 2) 13)
  (check-equal? (product-coeff '(1 2) '(3 4 5 6) 3) 16)
  (check-equal? (product-coeff '(1 2) '(3 4 5 6) 4) 12)
  (check-equal? (product-coeff '(1 2) '(3 4 5 6) 5) 0)


  (check-equal? (product-coeff '(1 2 3) '(4 5 6) 0) 4)
  (check-equal? (product-coeff '(1 2 3) '(4 5 6) 1) 13)
  (check-equal? (product-coeff '(1 2 3) '(4 5 6) 2) (+ 12 10 6))
  (check-equal? (product-coeff '(1 2 3) '(4 5 6) 3) (+ 15 12))
  (check-equal? (product-coeff '(1 2 3) '(4 5 6) 4) 18)
  (check-equal? (product-coeff '(1 2 3) '(4 5 6) 5) 0)
  (check-equal? (product-coeff '(1 2 3) '(4 5 6) 6) 0)
)
  
(define (mul-coeffs-tests)

 (check-equal? (mul-coeffs '() '(1 2 3)) '())
 (check-equal? (mul-coeffs '(1 2 3) '()) '())

 (check-equal? (mul-coeffs '(3 4 5) '(2)) '(6 8 10))
  
  ;https://www.wolframalpha.com/input?i=%281+%2B+2*x%29*%283+%2B+4*x+%2B+5*x%5E2+%2B+6*x%5E3%29
  (check-equal? (mul-coeffs '(1 2) '(3 4 5 6)) '(3 10 13 16 12))

  (check-equal? (mul-coeffs '(1 2 3) '(4 5 6)) '(4 13 28 27 18))
)

(define (poly-expr-coeffs-tests)
  (check-equal? (poly-expr-coeffs 44) '(44))
  ;;44 + 22
  (check-equal? (poly-expr-coeffs '(+ 44 22)) '(66))

  ;;4 * 22
  (check-equal? (poly-expr-coeffs '(* 4 22)) '(88))

  ;x
  (check-equal? (poly-expr-coeffs 'x) '(0 1))

  ;;2 * x
  (check-equal? (poly-expr-coeffs '(* 2 x)) '(0 2))

  ;;x * 2
  (check-equal? (poly-expr-coeffs '(* x 2)) '(0 2))

  ;;3 + x*2 + 4*x
  (check-equal? (poly-expr-coeffs '(+ 3 (* x 2) (* 4 x))) '(3 6))

  ;;x^3
  (check-equal? (poly-expr-coeffs '(expt x 3)) '(0 0 0 1))
  
  ;;x^3 * 5
  (check-equal? (poly-expr-coeffs '(* (expt x 3) 5)) '(0 0 0 5))

  ;;2*x^2 + x^3*5 + 8
  (check-equal?
   (poly-expr-coeffs '(+ (* 2 (expt x 2)) (* (expt x 3) 5) 8))
   '(8 0 2 5))

  ;;(4 + x)*(2*x^2 + 3)
  (check-equal?
   (poly-expr-coeffs '(* (+ 4 x) (+ (* 2 (expt x 2)) 3)))
   '(12 3 8 2))

  ;;(x^3 + 3*x + 2) * (5 + 6*x) + 2*x * (3*x^2 + 4*x)
  ;;https://www.wolframalpha.com/input?i=%28x%5E3+%2B+3*x+%2B+2%29+*+%285+%2B+6*x%29+%2B+2*x+*+%283*x%5E2+%2B+4*x%29
  (check-equal?
   (poly-expr-coeffs '(+ (* (+ (expt x 3) (* x 3) 2) (+ 5 (* 6 x)))
			 (* 2 x (+ (* 3 (expt x 2)) (* 4 x)))))
   '(10 27 26 11 6))
  
  
  
)

(define (run-tests)
  ;; activate tests once function is implemented
  (nth-tests)
  (count-pairs-tests)
  (tetrate-tests)
  (expt-list1-tests)
  (expt-list2-tests)
  (fill-list-tests)
  (strip-end-eq-tests)
  (add-coeffs-tests)
  (int-pairs-tests)
  (product-coeff-tests)
  (mul-coeffs-tests)
  (poly-expr-coeffs-tests)
)


(run-tests)
