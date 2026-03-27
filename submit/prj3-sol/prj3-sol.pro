#!/usr/bin/env -S swipl
%-*- mode: prolog; -*-

:- module(prj3_sol,  [
	      greater_than_element/3,
	      greater_thans/3,
	      fill_list/3,
	      rm_prefix/3,
	      rm_suffix/3,
	      sentence/2,
	      sum_to/3,
	      sum_pairs/2,
	      poly_coeffs/3,
	      left_assoc/2
   ]).


/*********************** IMPORTANT RESTRICTIONS ************************/

/*

You may make use of the binary operators `=` (unify), `\=` (not
unify), is/2, arithmetic and relational operators, append/3, length/2,
member/2, reverse/2 but are *not* allowed to use any other features or
built-in Prolog procedures, unless expressly mentioned for that
exercise.  Violating this restriction will result in a zero on that
exercise.

You are not allowed to use any of Prolog's higher-order features or
extra-logical control features like or, cut, if-then, `call` or
`setof`. Violating this restriction will result in a *zero grade* for
the *entire project*.

Unless stated otherwise, you may introduce auxiliary helper
procedures.

*/


% #1: 5-points
% greater_than_element(IntList, N, GtElement): GtElement is
% an element of integer list IntList which is greater-than
% N.  On backtracking, GtElement must be produced in the same order
% as in IntList.
% *Restriction*: cannot use recursion.
% *Hint*:  use a Prolog built-in which was covered in class.
greater_than_element(IntList, N, GtElement) :-
    member(GtElement, IntList),
    GtElement > N.

% #2: "10-points"
% greater_thans(IntList, N, GtList): GtList is a sub-list of
% those elements of integer list IntList which are greater than
% integer N.
% The elements in GtList must be in the same order in which they occur
% in IntList.
% Hint: `X =< Y` can be used to check if `X` is less-than-or-equal-to `Y`.
greater_thans([], _, []).
greater_thans([H|T], N, [H|GtList]) :-
    H > N,
    greater_thans(T, N, GtList).
greater_thans([H|T], N, GtList) :-
    H =< N,
    greater_thans(T, N, GtList).

% #3: "10-points"
% List is a list consisting of N Fill elements.
fill_list(N, Fill, List) :-
    length(List, N),
    fill_list_aux(List, Fill).

fill_list_aux([], _).
fill_list_aux([H|T], Fill) :-
    H = Fill,
    fill_list_aux(T, Fill).

% #4: 10-points"
% rm_prefix(List, X, ListZ): ListZ matches List without its prefix of
% all elements which match X.
rm_prefix([], _, []).
rm_prefix([X|T], X, ListZ) :-
    rm_prefix(T, X, ListZ).
rm_prefix([H|T], X, [H|T]) :-
    H \= X.

% #5: "5-points"
% ListZ is List with any suffix elements equal to End removed.
rm_suffix(List, X, ListZ) :-
    reverse(List, RevList),
    rm_prefix(RevList, X, RevListZ),
    reverse(RevListZ, ListZ).

% #6: 15-points
% A sentence is defined by the following EBNF grammar:
%
%   sentence
%     : noun_phrase verb_phrase
%     ;
%   noun_phrase
%     : ARTICLE? ADJECTIVE? NOUN
%     ;
%   verb_phrase
%     : VERB noun_phrase?
%     ;
%
% sentence(Vocab, Sentence): Sentence is a list of words constituting
% a sentence as per the above grammar, with words taken from list
% Vocab.  Vocab is a list of Prolog terms of the form:
% adjective(ADJECTIVE), article(ARTICLE), noun(NOUN), verb(VERB).
% Hint: use member/2 and append/3.
sentence(Vocab, Sentence) :-
    sentence_aux(Vocab, Sentence).

sentence_aux(Vocab, Sentence) :-
    noun_phrase(Vocab, NP),
    verb_phrase(Vocab, VP),
    append(NP, VP, Sentence).

noun_phrase(Vocab, NP) :-
    member(noun(Noun), Vocab),
    NP = [Noun].
noun_phrase(Vocab, NP) :-
    member(article(Article), Vocab),
    member(noun(Noun), Vocab),
    NP = [Article, Noun].
noun_phrase(Vocab, NP) :-
    member(adjective(Adj), Vocab),
    member(noun(Noun), Vocab),
    NP = [Adj, Noun].
noun_phrase(Vocab, NP) :-
    member(article(Article), Vocab),
    member(adjective(Adj), Vocab),
    member(noun(Noun), Vocab),
    NP = [Article, Adj, Noun].

verb_phrase(Vocab, VP) :-
    member(verb(Verb), Vocab),
    VP = [Verb].
verb_phrase(Vocab, VP) :-
    member(verb(Verb), Vocab),
    noun_phrase(Vocab, NP),
    append([Verb], NP, VP).

% #7: 10-points
% sum_to(I, J, N): I, J and N are positive integers such that N = I + J.
% Note that N is instantiated when this procedure is called, I and J may
% or may not be instantiated.
% Answers must be generated in increasing order by I.
% *Restriction*: must consist of a single rule.
% *Hint*: use builtin between/3.
sum_to(I, J, N) :-
    between(1, N, I),
    J is N - I,
    J > 0.

% #8: 10-points
% sum_pairs(N, SumPairs): Given positive integer N, SumPairs is a list
% of pairs [I, J] with I, J > 0 and I + J == N, ordered in increasing
% order by I.
% Hint: use an auxiliary recursive procedure.
sum_pairs(N, SumPairs) :-
    sum_pairs_aux(1, N, SumPairs).

sum_pairs_aux(I, N, []) :-
    I >= N.
sum_pairs_aux(I, N, [[I,J]|Rest]) :-
    I < N,
    J is N - I,
    I1 is I + 1,
    sum_pairs_aux(I1, N, Rest).

% #9: 10-points
% poly_coeffs(Poly, Var, Coeffs): Given a polynomial
% CN*Var**N + ... + C2*Var**2 + C1*Var**1 + C0*Var**0,
% Coeffs is the list [C0, C1, C2, ..., CN].
% Note that Poly is guaranteed to contain all powers 0..N of Var.
% Hint: + is left-associative.
poly_coeffs(Poly, Var, Coeffs) :-
    poly_coeffs_aux(Poly, Var, Pairs),
    sort_pairs(Pairs, SortedPairs),
    extract_coeffs(SortedPairs, Coeffs).

poly_coeffs_aux(Term, Var, [Power-Coeff]) :-
    Term = (Coeff * (Var ** Power)),
    integer(Coeff),
    integer(Power).
poly_coeffs_aux(Term, Var, Pairs) :-
    Term = (Left + Right),
    poly_coeffs_aux(Left, Var, PairsLeft),
    poly_coeffs_aux(Right, Var, PairsRight),
    append(PairsLeft, PairsRight, Pairs).

sort_pairs([], []).
sort_pairs([Power-Coeff|Rest], Sorted) :-
    sort_pairs(Rest, SortedRest),
    insert_pair(Power-Coeff, SortedRest, Sorted).

insert_pair(Power-Coeff, [], [Power-Coeff]).
insert_pair(Power1-Coeff1, [Power2-Coeff2|Rest], [Power1-Coeff1, Power2-Coeff2|Rest]) :-
    Power1 =< Power2.
insert_pair(Power1-Coeff1, [Power2-Coeff2|Rest], [Power2-Coeff2|NewRest]) :-
    Power1 > Power2,
    insert_pair(Power1-Coeff1, Rest, NewRest).

extract_coeffs([], []).
extract_coeffs([_-Coeff|Rest], [Coeff|Coeffs]) :-
    extract_coeffs(Rest, Coeffs).

% #10: 15-points
% left_assoc(PlusTerm, LeftAssocTerm): PlusTerm is a Prolog term
% involving integers and Prolog's + operator.  LeftAssocTerm is
% like PlusTerm but associated so that the second operand of any
% + cannot be a +-term.
% *Hints*:
%    A + (B + C) ==> (A + B) + C.
%    integer/1 succeeds if its argument is an integer
left_assoc(Term, Result) :-
    left_assoc_aux(Term, Result).

left_assoc_aux(Int, Int) :-
    integer(Int).
left_assoc_aux(Var, Var) :-
    atom(Var).
left_assoc_aux(Term, Result) :-
    Term = (A + B),
    left_assoc_aux(A, LeftA),
    left_assoc_aux(B, LeftB),
    left_assoc_combine(LeftA, LeftB, Result).

left_assoc_combine(LeftA, LeftB, (LeftA + LeftB)) :-
    \+ (LeftB = (_ + _)).
left_assoc_combine(LeftA, LeftB, Result) :-
    LeftB = (X + Y),
    left_assoc_aux((LeftA + X), Temp),
    left_assoc_aux((Temp + Y), Result).
