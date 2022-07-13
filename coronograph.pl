run(Graph, N, Result):-
    reachable(1, Graph, CanReach),
    length(CanReach, Len),
    (Len =:= N ->
        path(_,[_|Tl]),
        last(Tl, Last),
        Tl = [Hd|_],
        del_edges(Graph, [Last-Hd, Hd-Last], NewGraph),
        delete_edges(NewGraph, Tl, FinalGraph),
        length(Tl, CyLen),
        get_len(FinalGraph, Tl, FinalList),
        msort(FinalList, NewLen),
        Result = [CyLen, NewLen],
    !
    ;Result = "'NO CORONA'"
).
path(A,Path) :-
    travel(A,A,[A],Q), 
    length(Q, Len),
    Len > 3,
    reverse(Q,Path),
    !.
travel(A,B,P,[B|P]):- 
    arc(A,B).         
travel(A,B,Visited,Path) :-
    arc(A,C),                     
    C \== B,
    not(member(C,Visited)),
    travel(C,B,[C|Visited],Path).

coronograph(File, Answers):-
    open(File,read,Stream),
    read_line_to_codes(Stream, Line),
    number_codes(T, Line),
    read_lines(Stream,T,Answers),
    !.
read_lines(_, 0, []).
read_lines(Stream, T, [Answer|Tl]):-
    T>0,
    retractall(arc(_,_)),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, [N, M]),
    read_edges(M, Stream, [], N, Answer, M),
    NewT is T - 1,
    read_lines(Stream, NewT, Tl),
    !.
read_edges(0, _, Graph, N, Answer, M):- (N=:=M -> run(Graph, N, Answer), ! ;Answer = "'NO CORONA'" ).
read_edges(M, Stream, Graph, N, Answer, FirstM):-
        M > 0,
        read_line_to_codes(Stream, Line),
        atom_codes(Atom, Line),
        atomic_list_concat(Atoms, ' ', Atom),
        maplist(atom_number, Atoms, [Node1, Node2]),
        NewM is M - 1,
        add_edges(Graph, [Node1-Node2, Node2-Node1], NewGraph),
        assertz(arc(Node1,Node2)),
        assertz(arc(Node2,Node1)),
        read_edges(NewM, Stream, NewGraph, N, Answer, FirstM),
        !.
delete_edges(Graph, [Node1,Node2|Tl], FinalGraph):-
    del_edges(Graph, [Node1-Node2, Node2-Node1], NewGraph),
    delete_edges(NewGraph, [Node2|Tl], FinalGraph).
delete_edges(Graph, [Node1,Node2], FinalGraph):-
    del_edges(Graph, [Node1-Node2, Node2-Node1], FinalGraph),
    !.

get_len(Graph, [Node|Tl], [Len|Rest]):-
    reachable(Node, Graph, Reach),
    length(Reach, Len),  
    get_len(Graph, Tl, Rest).
get_len(_, [], []):- !.