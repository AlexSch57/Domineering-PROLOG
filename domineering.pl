joueur(joueur1) .
joueur(joueur2) .

turn(joueur1) .


vertical(joueur1, X, Y) :- turn(joueur1), ligne(X), colonne(Y) .


ligne(6).
colonne(6).

suivant(1, 2).
suivant(2, 3).
suivant(3, 4).
suivant(4 ,5).
suivant(5, 6).
suivant(6, 7).  % La fonction remplacer( ) marche s'il y a un nombre suivant la taille maximale.

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
    jouer(Plateau, joueur1).

jouer(Plateau, joueur1) :-
    write("Case X: "),
    read(X),
    write("Case Y :"),
    read(Y),
    placementHorizontal(o, X, Y, Plateau, NouveauPlateau),
    afficherTableau(NouveauPlateau),
    jouer(NouveauPlateau, joueur2).

jouer(Plateau, joueur2) :-
    write("Case X: "),
    read(X),
    write("Case Y :"),
    read(Y),
    placementVertical(x, X, Y, Plateau, NouveauPlateau),
    afficherTableau(NouveauPlateau),
    jouer(NouveauPlateau, joueur1).




placementHorizontal(Pion, X, Y, Plateau, NouveauPlateau) :-
    placer(Pion, X, Y, Plateau, PlateauIntermediaire),
    suivant(Y, YSuiv),
    placer(Pion, X, YSuiv, PlateauIntermediaire, NouveauPlateau).

placementVertical(Pion, X, Y, Plateau, NouveauPlateau) :-
    placer(Pion, X, Y, Plateau, PlateauIntermediaire),
    suivant(X, XSuiv),
    placer(Pion, XSuiv, Y, PlateauIntermediaire, NouveauPlateau).


placer(Pion, X, Y, Plateau, NouveauPlateau) :-
    extraire(X, 1, Plateau, ListeX),
    %writeln(ListeX),
    remplacer(Y, 1, ListeX, Pion, NouvelleListeX),
    %writeln(NouvelleListeX),
    remplacer(X, 1, Plateau, NouvelleListeX, NouveauPlateau).


extraire(Position, Position, [ElementExtraite | _], ElementExtraite).
extraire(Position, X, [_ | Liste], ElementExtraite) :-
    suivant(X, XSuiv),
    extraire(Position, XSuiv, Liste, ElementExtraite).


% Remplacer l'element qui se trouve a l'index indique.
remplacer(_, _, [], _, []).

remplacer(Position, Position, [_ | Liste], Element, [Element | CopieReste]) :-
    suivant(Position, PSuiv),
    remplacer(Position, PSuiv, Liste, Element, CopieReste).

remplacer(Position, Y, [Tete | Liste], Element, [Tete | CopieReste]) :-
    suivant(Y, YSuiv),
    \+Position == Y,
    remplacer(Position, YSuiv, Liste, Element, CopieReste).


