initial(conf(w,w,w,w)).
final(conf(e,e,e,e)).

move(conf(w,w,G,C), wolf, conf(e,e,G,C)).
move(conf(e,e,G,C), wolf, conf(w,w,G,C)).
move(conf(w,W,w,C), goat, conf(e,W,e,C)).
move(conf(e,W,e,C), goat, conf(w,W,w,C)).
move(conf(w,W,G,w), cabbage, conf(e,W,G,e)).
move(conf(e,W,G,e), cabbage, conf(w,W,G,w)).
move(conf(w,W,G,C), nothing, conf(e,W,G,C)).
move(conf(e,W,G,C), nothing, conf(w,W,G,C)).

together_or_separated(Same, Same, Same).
together_or_separated(_, X, Y) :- X \= Y.

safe(conf(Man,Wolf,Goat,Cabbage)) :-
    together_or_separated(Man,Wolf,Goat),
    together_or_separated(Man,Goat,Cabbage).

solution(Conf, []) :- final(Conf).
solution(Conf, [Move | Moves]):-
    move(Conf,Move,NewConf),
    safe(NewConf),
    solution(NewConf,Moves).

solve :- 
    initial(Conf),
    length(Moves, Length), 
    ( Length > 11 -> !        
    ; solution(Conf, Moves), 
    writeln(Moves),
    fail
    ).

