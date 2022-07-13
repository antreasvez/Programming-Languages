
find_binary(0, List, K, Result) :- sum_list(List, Sum), 
    ( Sum > K -> Result = []
    ;lexigrocafically_smaller(List, 1, K, Sum, Result)
    ).
find_binary(N, List, K, Result) :-
    N > 0,
    Binary is N rem 2,
    NewN is N // 2,
    append(List, [Binary], NewList),
    find_binary(NewN, NewList, K, Result).


replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

lexigrocafically_smaller(List, 0, K, Sum, Result):- !.
lexigrocafically_smaller(List, Index, K, K, Result) :- reverse(List, Newlist), print_list(Newlist, Result).
lexigrocafically_smaller(List, 1, K, Sum, Result) :-
    nth0(1, List, C, _),
    (C = 0 ->  lexigrocafically_smaller(List, 2, K, Sum, Result)
    ; NewC is C - 1, 
    replace(List, 1, NewC, NewList),
    nth0(0, List, Value, _),
    NewVal is Value + 2,
    replace(NewList, 0, NewVal, NewerList),
    sum_list(NewerList, NewSum),
    lexigrocafically_smaller(NewerList, 1, K, NewSum, Result)
).
lexigrocafically_smaller(List, Index, K, Sum, Result) :-
Index > 0,
    nth0(Index, List, C, _), 
    (C = 0 -> NewIndex is Index+1, lexigrocafically_smaller(List, NewIndex, K, Sum, Result)
    ; NewC is C - 1, 
        replace(List, Index, NewC, NewList),
        Index_ is Index - 1,
        nth0(Index_, List, Value, _),
        NewVal is Value + 2,
        replace(NewList, Index_, NewVal, NewerList),
        sum_list(NewerList, NewSum),
        lexigrocafically_smaller(NewerList, Index_, K, NewSum, Result)
    ).


print_list(List, Result) :-
nth0(0, List, C, Tl),
(C = 0 -> print_list(Tl, Result)
;reverse(List, NewList),
Result = NewList,
!
).

powers2(File, Answers) :-
    open(File, read, Stream),
    read_line_to_codes(Stream, Line),
    number_codes(T, Line),
    read_lines(Stream, T, Answers).

read_lines(Stream, 0, Tl).
read_lines(Stream, 1, [Tl]):-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, [N, K]),
    find_binary(N, [], K, Tl),
    read_lines(Stream, 0, Tl),
    !.
read_lines(Stream, T, [Answer|Tl]) :-
    T > 1,
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, [N, K]),
    find_binary(N, [], K, Answer),
    NewT is T - 1,
    read_lines(Stream, NewT, Tl),
    !.