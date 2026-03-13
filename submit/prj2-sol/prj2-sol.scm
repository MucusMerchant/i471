#!/usr/bin/env racket

;; To load into the REPL, type
;;    ,enter "prj2-sol.scm"
;; at the REPL > prompt.  This will put you in the module context and
;; you can type expressions involving the module functions.

#lang racket

;; to trace function fn, add (trace fn) after fn's definition
(require racket/trace)  


(provide nth
	 count-pairs
	 tetrate
	 expt-list1
	 expt-list2
	 strip-end-eq
	 fill-list
	 int-pairs
	 add-coeffs
	 product-coeff
	 mul-coeffs
	 poly-expr-coeffs
)

;; *RESTRICTIONS*:
;;
;; YOU WILL RECEIVE A SUBSTANTIAL PENALTY (INCLUDING POSSIBLY A ZERO)
;; FOR THIS PROJECT IF YOU VIOLATE THE FOLLOWING RESTRICTIONS:
;;
;; You cannot use any destructive operations (operations which end
;; with a ! like set!).
;;
;; You cannot use a named-let
;;   (<https://docs.racket-lang.org/guide/let.html#(part._.Named_let)>).
;;
;; You may only use the built-in Scheme functions mentioned in
;; class or in this project, including the following:
;;   The arithmetic functions +, -, *, /, expt
;;     ((expt a n) = a^n; (expt 2 5) = 32.
;;   The boolean functions and, or, not.
;;   The relational predicates on numbers: <, >, <=, >= and =.
;;   The equality predicate 'eq? to check equality.
;;   Any of Racket's list functions
;;   (<https://docs.racket-lang.org/reference/pairs.html>).
;;   In particular, length, list, list-ref, memf, pair?, range, reverse,
;;   map, fold[lr]. 
;; 

;; *TESTS*:
;;
;; Initially, calls to all the test functions have been commented out
;; (at the bottom of the prj2-tests.scm file).  Activate each call as
;; you implement the corresponding function.
;;
;; If a particular function is going into an infinite loop on any
;; test, submit your attempted code for that function under a
;; different function name so that it is not run as part of the
;; automated tests but your looping code can still be evaluated.
;; Submit the original function in its 'TODO state. This will stop the
;; looping test from preventing subsequent tests from running.  Add a
;; comment specifying which test causes your code to loop.

;; #1: "3-points"
;;
;; return list[index] if index < length list, else return default
(define (nth lst n (default 0))
  (cond
    ((null? lst) default)
    ((= n 0) (car lst))
    (else (nth (cdr lst) (- n 1) default))))

;; #2: "5-points"
;;
;; Given some scheme expression e (count-pairs e) should return the total
;; # of pairs in e (the total count of all subexpressions in e for
;; which (pair? e) is true).
(define (count-pairs e)
  (cond
    ((not (pair? e)) 0)
    (else (+ 1
             (count-pairs (car e))
             (count-pairs (cdr e))))))

;; #3: "5-points"
;;
;; (tetrate a h) should return the tetration a^^h
;; i.e. a tower of powers of a having height h
;; with exponentiation associating to the right.
;; (see <https://en.wikipedia.org/wiki/Tetration>)
;;
;; *Hint*: recurse on h
(define (tetrate a h)
  (cond
    ((= h 0) 1)
    ((= h 1) a)
    (else (expt a (tetrate a (- h 1))))))

;; #4: "7-points"
;;
;; (expt-list list): Given list of integers (n1 n2 n3 ...) return
;; (expt n1 (expt n2 (expt n3 ... ) )).  If the list is empty,
;; return 1.
;;
;; *Restriction*: you must use a tail-recursive auxiliary function
;; (without polluting the global namespace)
;;
;; *Hint*: reverse the list.
(define (expt-list1 lst)
  (define (aux l acc)
    (if (null? l)
        acc
        (aux (cdr l) (expt (car l) acc))))
  (if (null? lst)
      1
      (aux (cdr (reverse lst)) (car (reverse lst)))))

;; #5: "5-points"
;;
;; (expt-list list): Given list of integers (n1 n2 n3 ...) return
;; (expt n1 (expt n2 (expt n3 ... ) )).  If the list is empty,
;; return 1.
;;
;; *Restriction*: cannot use recursion.
;;
;; *Hint*: use a fold.
(define (expt-list2 lst)
  (if (null? lst)
      1
      (foldl (lambda (x acc) (expt x acc)) 1 (reverse lst))))

;; #6: "5-points"
;;
;; return list containing exactly n fill elements
;;
;; *Restriction*: cannot use recursion.
;;
;; Hint: use map with range
(define (fill-list n (fill 0))
  (map (lambda (x) fill) (range n)))

;; #7 "7-points"
;;
;; return list with all trailing val's removed
;;
;; *Restriction*: cannot use recursion
;;
;; *Hint*: use reverse and memf with not eq?
(define (strip-end-eq lst (val 0))
  (let ((trim (memf (lambda (x) (not (eq? x val)))
                    (reverse lst))))
    (if trim
        (reverse trim)
        '())))

;; #8: "13-points"
;;
;; Return list of all non-negative int pairs (i j) such that i + j ==
;; n, sorted in increasing order of i.
;;
;; *Restriction*: cannot use recursion.
;;
;; *Hint*: use a map to return list of pairs of elements from
;; lists (0 ... n) (n ... 0)
(define (int-pairs n)
  (map list (range 0 (+ n 1)) (reverse (range 0 (+ n 1)))))

;; An nth-degree polynomial a_0 + a_1*x^1 + a_2*x^2 + ... + a_n*x^n
;; can be represented using the n + 1 element coeff-list
;; (a_0 a_1 a_2 ... a_n).  To ensure a canonical representation,
;; we forbid any trailing 0's in a coeff-list.

;; #9: "10-points"
;;
;; return list containing sum of individual coefficients in
;; coeff-lists coeffs1 and coeffs2 without any trailing zeros (the
;; result is the length of the longer list with missing elements in
;; the shorter list regarded as zero).
;;
;; *Hints*:
;;   Can be done without using recursion.
;;   Use map over range max-length(coeffs1, coeffs2) with nth used
;;   to access coeff.
;;   Use strip-end-eq to remove trailing zeros.
(define (add-coeffs coeffs1 coeffs2)
  (let* ((len (max (length coeffs1) (length coeffs2)))
         (result
          (map (lambda (i)
                 (+ (nth coeffs1 i 0)
                    (nth coeffs2 i 0)))
               (range len))))
    (strip-end-eq result 0)))

;; #10: "15-points"
;; Given polynomials p1 and p2 determined by coeff-lists coeffs1 and coeffs2,
;; return the n'th coefficient in the coeff-list for the product
;; polynomial p1 * p2.
;;
;; *Hint*: Use int-pairs n to generate coeffs1 and coeffs2 indexes of
;; product elements, form list of products by mapping over pairs
;; (using nth to extract coeff) and finally fold + over the products.
(define (product-coeff coeffs1 coeffs2 n)
  (foldl +
         0
         (map (lambda (p)
                (* (nth coeffs1 (car p) 0)
                   (nth coeffs2 (cadr p) 0)))
              (int-pairs n))))

;; #11: "10-points"
;;
;; Given polynomials p1 and p2 determined by coeff-lists coeffs1 and coeffs2,
;; return the coeff-list for the product polynomial p1 * p2.  Ensure result
;; coeff-list has no trailing zeros.
;;
;; *Hint*: map product-coeff over appropriate range; use strip-end-eq
;; to remove trailing zeros.
(define (mul-coeffs coeffs1 coeffs2)
  (let* ((deg (+ (length coeffs1) (length coeffs2) -1))
         (coeffs
          (map (lambda (i)
                 (product-coeff coeffs1 coeffs2 i))
               (range deg))))
    (strip-end-eq coeffs 0)))
;; A PolyExpr is represented using the following EBNF grammar (where
;; the parentheses represent Scheme lists):
;; PolyExpr               #A PolyExpr is either
;;   : INT                #an integer or 
;;   | SYMBOL             #a symbol or
;;   | (expt SYMBOL INT)  #a symbol raised to a power or
;;   | (+ PolyExpr+)      #a sum of one-or-more PolyExpr's or
;;   | (* PolyExpr+)      #a product of one-or-more PolyExpr's or
;;   | ( INT* )           #a list of integers (representing a coeff-list)
;;   ;
;;
;; The SYMBOL should be the same over an entire PolyExpr.


;; #12: "15-points"
;; Return coeffs-list for single-variable polynomial given by poly-expr.
;; You may assume that poly-expr does not have any errors.
;;
;; *Hints*:
;;   Recurse on the structure of poly-expr (you can use match or simply
;;   conditions; in the absence of errors, conditions may be simpler).
;;   For INT(N) return `(,N)
;;   For SYMBOL, return '(0 1)
;;   For (expt _ N), return (0 ... 0 1) with N leading 0s (use fill-list)
;;   For +, recurse over operands using map and then fold mapped result
;;     using add-coeffs.
;;   For *, recurse over operands using map and then fold mapped result
;;     using mul-coeffs.
;;   Otherwise simply return poly-expr unchanged
(define (poly-expr-coeffs poly-expr)
  (cond
    ((integer? poly-expr)
     (list poly-expr))

    ((symbol? poly-expr)
     '(0 1))

    ((and (pair? poly-expr) (eq? (car poly-expr) 'expt))
     (append (fill-list (caddr poly-expr) 0) '(1)))

    ((and (pair? poly-expr) (eq? (car poly-expr) '+))
     (foldl add-coeffs
            '(0)
            (map poly-expr-coeffs (cdr poly-expr))))

    ((and (pair? poly-expr) (eq? (car poly-expr) '*))
     (foldl mul-coeffs
            '(1)
            (map poly-expr-coeffs (cdr poly-expr))))

    (else poly-expr)))
