joueur(joueur1) .
joueur(joueur2) .

turn(joueur1) .


vertical(joueur1, X, Y) :- turn(joueur1), ligne(X), colonne(Y) .


ligne(6).
colonne(6).

suivant(0, 1).
suivant(1, 2).
suivant(2, 3).
suivant(3, 4).
suivant(4 ,5).
suivant(5, 6).

initLigne([-], X) :- 
    ligne(X).
initLigne([-|L], X) :-
    \+ligne(X),
    suivant(X, Y),
    initLigne(L, Y).

initColonne([L1], X) :- 
    colonne(X), 
    initLigne(L1, 1).
initColonne([L1|L], X) :-
    \+colonne(X),
    suivant(X, Y),
    initLigne(L1, 1),
    initColonne(L, Y).

init(L) :- initColonne(L, 1), afficherTableau(L).

afficherTableau([]).
afficherTableau([X|L]) :- 
    writeln(X), 
    afficherTableau(L).
    
  
description :-
    writeln("Description du jeu et des regles blablabla...").
    
lancerJeu :-
    description,
    init(Plateau),
    jouer(Plateau).
    
jouer(Plateau) :-
    afficherTableau(Plateau),
    write("Case : "),
    read(PositionLigne),
    read(PositionColonne),
    %placerH(Plateau, PositionLigne, PositionColonne, NewPlateau),
    jouer(NewPlateau).
