#!/usr/bin/env -S prolog
%-*- mode: prolog; -*-

:- module('prj3_tests', []).

:- use_module('prj3-sol.pro').

%%%%%%%%%%%%%%%%%%%%%%%%% greater_than_element/3 %%%%%%%%%%%%%%%%%%%%%%%%

:- begin_tests(greater_than_element, []).
test(three, [all(X == [9, 22, 8])]) :- 
    greater_than_element([2, 9, 22, 7, 8 ], 7, X).
test(all, [all(X == [2, 9, 22, 7, 8])]) :- 
    greater_than_element([2, 9, 22, 7, 8 ], 1, X).
test(none, [all(X == [])]) :- 
    greater_than_element([2, 9, 22, 7, 8 ], 22, X).
test(four, [all(X == [9, 22, 7, 8])]) :-
    greater_than_element([2, 9, 22, 7, 8 ], 6, X).
test(empty, [all(X == [])]) :-
    greater_than_element([], 6, X).
:- end_tests(greater_than_element).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% greater_thans/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- begin_tests(greater_thans, []).
test(three, [all(X == [[9, 22, 8]])]) :- 
    greater_thans([2, 9, 22, 7, 8 ], 7, X).
test(all, [all(X == [[2, 9, 22, 7, 8]])]) :- 
    greater_thans([2, 9, 22, 7, 8 ], 1, X).
test(none, [all(X == [[]])]) :- 
    greater_thans([2, 9, 22, 7, 8 ], 22, X).
test(four, [all(X == [[9, 22, 7, 8]])]) :-
    greater_thans([2, 9, 22, 7, 8 ], 6, X).
test(empty, [all(X == [[]])]) :-
    greater_thans([], 6, X).
:- end_tests(greater_thans).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fill_list/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- begin_tests(fill_list, []).
test(zero_3, [all(X == [[0, 0, 0]])]) :- 
    fill_list(3, 0, X).
test(seven_5, [all(X == [[7, 7, 7, 7, 7]])]) :- 
    fill_list(5, 7, X).
test(a_4, [all(X == [[a, a, a, a]])]) :- 
    fill_list(4, a, X).
test(struct_2, [all(X == [[f(a, 1), f(a, 1)]])]) :- 
    fill_list(2, f(a, 1), X).
test(empty, [all(X == [[]])]) :-
    fill_list(0, 6, X).
:- end_tests(fill_list).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% rm_prefix/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- begin_tests(rm_prefix, []).
test(zero_3, [all(X == [[7, 0, 0, 0]])]) :- 
    rm_prefix([0, 0, 0, 7, 0, 0, 0], 0, X).
test(atom_3, [all(X == [[7, 0, 0, 0]])]) :- 
    rm_prefix([a, a, a, 7, 0, 0, 0], a, X).
test(struct_1, [all(X == [[12, f(a, 2), 0, 0]])]) :- 
    rm_prefix([f(a, 2), 12, f(a, 2), 0, 0], f(a, 2), X).
test(struct_0, [all(X == [[12, f(a, 2), 0, 0]])]) :- 
    rm_prefix([12, f(a, 2), 0, 0], f(a, 2), X).
test(all, [all(X == [[]])]) :- 
    rm_prefix([a, a, a, a], a, X).
test(empty, [all(X == [[]])]) :- 
    rm_prefix([], f(a, 2), X).
:- end_tests(rm_prefix).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% rm_suffix/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- begin_tests(rm_suffix, []).
test(zero_3, [all(X == [[0, 0, 0, 7]])]) :- 
    rm_suffix([0, 0, 0, 7, 0, 0, 0], 0, X).
test(atom_3, [all(X == [[7, 0, 0, 0]])]) :- 
    rm_suffix([7, 0, 0, 0, a, a, a], a, X).
test(struct_1, [all(X == [[12, f(a, 2), 0, 0]])]) :- 
    rm_suffix([12, f(a, 2), 0, 0, f(a, 2)], f(a, 2), X).
test(struct_0, [all(X == [[12, f(a, 2), 0, 0]])]) :- 
    rm_suffix([12, f(a, 2), 0, 0], f(a, 2), X).
test(all, [all(X == [[]])]) :- 
    rm_suffix([a, a, a, a], a, X).
test(empty, [all(X == [[]])]) :- 
    rm_suffix([], f(a, 2), X).
:- end_tests(rm_suffix).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sentence/2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vocab([article(a), article(the),
       adjective(tall), adjective(short),
       noun(man), noun(woman),
       verb(loves), verb(hates)]).

:- begin_tests(sentence, []).
test(n_v, [nondet]) :-
    vocab(Vocab),
    sentence(Vocab, [man, loves]).
test(ar_n_v, [nondet]) :-
    vocab(Vocab),
    sentence(Vocab, [the, woman, loves]).
test(ar_ad_n_v, [nondet]) :-
    vocab(Vocab),
    sentence(Vocab, [the, tall, woman, hates]).
test(ad_n_v, [nondet]) :-
    vocab(Vocab),
    sentence(Vocab, [short, man, loves]).
test(ar_ad_n_v_n, [nondet]) :-
    vocab(Vocab),
    sentence(Vocab, [the, tall, woman, hates, man]).
test(ar_n_v_ad_n, [nondet]) :-
    vocab(Vocab),
    sentence(Vocab, [the, woman, hates, tall, man]).
test(n_v_ar_ad_n, [nondet]) :-
    vocab(Vocab),
    sentence(Vocab, [woman, hates, a, tall, man]).
test(ad_ar_n_v_n, [fail]) :-
    vocab(Vocab),
    sentence(Vocab, [tall, the, woman, hates, man]).
test(multiple_np, [set(X = [[woman, hates],
			    [the, woman, hates],
			    [the, tall, woman, hates],
			    [the, short, woman, hates],
			    [a, woman, hates],
			    [a, tall, woman, hates],
			    [a, short, woman, hates],
			    [tall, woman, hates],
			    [short, woman, hates]])]):-
    vocab(Vocab),
    sentence(Vocab, X),
    reverse(X, [hates, woman|_]).
test(multiple_vp, [set(X = [[man,loves,woman],
			 [man,loves,the,woman],
			 [man,loves,the,tall,woman],
			 [man,loves,the,short,woman], 
			 [man,loves,tall,woman],
			 [man,loves,short,woman], 
			 [man,loves,a,woman],
			 [man,loves,a,tall,woman],
			 [man,loves,a,short,woman], 
			 [man,loves,a,woman],
			 [man,loves,a,woman]])]):-
    vocab(Vocab),
    sentence(Vocab, X),
    X = [man, loves|_],
    reverse(X, [woman|_]).
test(v_n, [fail]) :-
    vocab(Vocab),
    sentence(Vocab, [hates, man]).
test(n, [fail]) :-
    vocab(Vocab),
    sentence(Vocab, [man]).
test(bad_vocab, [fail]) :-
    vocab(Vocab),
    sentence(Vocab, [boy, hates]).
:- end_tests(sentence).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sum_to/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- begin_tests(sum_to, []).
test(all_4, [all(X == [[1,3], [2,2], [3,1]])]) :- 
    sum_to(I, J, 4), X = [I, J].
test(all_7, [all(X == [[1,6], [2,5], [3,4], [4, 3], [5, 2], [6, 1]])]) :- 
    sum_to(I, J, 7), X = [I, J].
test(first, [nondet]) :- 
    sum_to(1, 3, 4).
test(one, [fail]) :- 
    sum_to(0, 1, 1).
test(too_big, [fail]) :- 
    sum_to(2, 5, 6).
test(too_small, [fail]) :- 
    sum_to(2, 5, 8).
:- end_tests(sum_to).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sum_pairs/2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- begin_tests(sum_pairs, []).
test(all_4, [all(X == [[[1,3], [2,2], [3,1]]])]) :- 
    sum_pairs(4, X).
test(all_7, [all(X == [[[1,6], [2,5], [3,4], [4, 3], [5, 2], [6, 1]]])]) :- 
    sum_pairs(7, X).
test(order_4, [fail]) :- 
    sum_pairs(4, [[2, 2], [1,3], [3,1]]).
test(one, [all(X = [[]])]) :- 
    sum_pairs(1, X).
:- end_tests(sum_pairs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% poly_coeffs/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- begin_tests(poly_coeffs, []).
test(poly_3_2_1_0, [all(X == [[0, 1, 2, 3]])]) :- 
    poly_coeffs(3*x**3 + 2*x**2 + 1*x**1 + 0*x**0, x, X).
test(poly_7_3_5_2_6, [all(X == [[6, 2, 5, 3, 7]])]) :- 
    poly_coeffs(7*x**4 + 3*x**3 + 5*x**2 + 2*x**1 + 6*x**0, x, X).
test(bad_var, [fail]) :- 
    poly_coeffs(3*x**3 + 2*y**2 + 1*x**1 + 0*x**0, x, _X).
test(bad_exp_op, [fail]) :- 
    poly_coeffs(3*x**3 + 2*x^2 + 1*x**1 + 0*x**0, x, _X).
:- end_tests(poly_coeffs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% left_assoc/2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- begin_tests(left_assoc, []).
test(int, [all(X == [1])]) :- 
    left_assoc(1, X).
test(simple, [all(X == [1+2])]) :- 
    left_assoc(1+2, X).
test(assoc_1__2_3, [all(X == [1+2+3])]) :- 
    left_assoc(1+(2 + 3), X).
test(assoc_1__2_3__3, [all(X == [1+2+3+4])]) :- 
    left_assoc(1+ (2 + 3) + 4, X).
test(assoc_complex, [all(X == [1+2+3+4+5+6+7])]) :- 
    left_assoc(1 + ((2 + 3)) + (4 + (5 + (6 + 7))), X).
:- end_tests(left_assoc).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main/0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

main :-
    current_prolog_flag(argv, Argv),

    %the following option does not work on remote.cs, but can be used
    %in gradescope by installing at least version 9.2.5
    %set_test_options([format(log)]),

    (length(Argv, 0) -> run_tests ; run_tests(Argv)).

:-initialization(main, main).
  
