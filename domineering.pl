%
% BASE DE FAITS
%
%
joueur(joueur1).
joueur(joueur2).

ligne(2).		% Nombre de lignes composant le plateau.
colonne(2).		% Nombre de colonnes composant le plateau.

suivant(1, 2).
suivant(2, 3).
suivant(3, 4).
suivant(4 ,5).
suivant(5, 6).
suivant(6, 7).  % La fonction remplacer( ) marche s'il y a un nombre suivant la taille maximale.



%
% FONCTIONS / REGLES
%

% Initialise une liste vide. Il s'agit d'une ligne dans un plateau.
initLigne([-], X) :-
    ligne(X).
initLigne([-|L], X) :-
    \+ligne(X),
    suivant(X, Y),
    initLigne(L, Y).

% Initialise une liste de liste (= plateau)
initColonne([L1], X) :-
    colonne(X),
    initLigne(L1, 1).
initColonne([L1|L], X) :-
    \+colonne(X),
    suivant(X, Y),
    initLigne(L1, 1),
    initColonne(L, Y).

% Initialise un plateau vide.
init(L) :-
    initColonne(L, 1),
    afficherTableau(L).

% Afficher le plateau de jeu
afficherTableau([]) :-
    writeln("").
afficherTableau([X|L]) :-
    writeln(X),
    afficherTableau(L).

% Description du jeu. Doit se lancer au debut du jeu pour expliquer aux joueurs
% le fonctionnement de la partie.
description :-
    writeln("Description du jeu et des regles blablabla...").

% Fonction pour lancer le jeu.
lancerJeu :-
    description,
    init(Plateau),
    jouer(Plateau, joueur1).

% Lire une position.
lireReponse(X, Y) :-
    write("Ligne : "),
    read(X),
    write("Colonne :"),
    read(Y).

% Pour jouer un tour.
    % Arret du jeu.
jouer(Plateau, joueur1) :-
    \+peutJouerHorizontal(Plateau, 1, 1),
    writeln("Joueur 1 a perdu !."),
    abort().

jouer(Plateau, joueur2) :-
    \+peutJouerVertical(Plateau, 1, 1),
    writeln("Joueur 2 a perdu !"),
    abort().

    % Jouer en placant un domino.
jouer(Plateau, joueur1) :-
    peutJouerHorizontal(Plateau, 1, 1),
    writeln("Joueur 1 : "),
    lireReponse(X, Y),
    placementHorizontal(o, X, Y, Plateau, NouveauPlateau, joueur1),
    afficherTableau(NouveauPlateau),
    jouer(NouveauPlateau, joueur2).

jouer(Plateau, joueur2) :-
    peutJouerVertical(Plateau, 1, 1),
    writeln("Joueur 2 : "),
    lireReponse(X, Y),
    placementVertical(x, X, Y, Plateau, NouveauPlateau, joueur2),
    afficherTableau(NouveauPlateau),
    jouer(NouveauPlateau, joueur1).

% Place un domino horizontalement sur plateau a la position spacifiee.
placementHorizontal(Pion, X, Y, Plateau, NouveauPlateau, joueur1) :-
    placer(Pion, X, Y, Plateau, PlateauIntermediaire),
    \+colonne(Y),
    suivant(Y, YSuiv),
    placer(Pion, X, YSuiv, PlateauIntermediaire, NouveauPlateau).

placementHorizontal(_, _, _, Plateau, _, joueur1) :-
    writeln("Coup incorrect, veuillez recommencez"),
    afficherTableau(Plateau),
	jouer(Plateau, joueur1).

% Place un domino verticalement sur le plateau a la position spécifiee.
placementVertical(Pion, X, Y, Plateau, NouveauPlateau, joueur2) :-
    placer(Pion, X, Y, Plateau, PlateauIntermediaire),
    \+ligne(X),
    suivant(X, XSuiv),
    placer(Pion, XSuiv, Y, PlateauIntermediaire, NouveauPlateau).

placementVertical(_, _, _, Plateau, _, joueur2) :-
    writeln("Coup incorrect, veuillez recommencez"),
    afficherTableau(Plateau),
	jouer(Plateau, joueur2).

% Verifie si la case a la position indiquee est libre.
libre(X, Y, Plateau) :-
    extraire(X, 1, Plateau, Liste),
    extraire(Y, 1, Liste, -).

% Creer un nouveau plateau avec la case indiquee occupee.
placer(Pion, X, Y, Plateau, NouveauPlateau) :-
    extraire(X, 1, Plateau, ListeX),
    libre(X, Y, Plateau),
    remplacer(Y, 1, ListeX, Pion, NouvelleListeX),
    remplacer(X, 1, Plateau, NouvelleListeX, NouveauPlateau).

% Extrait un element d'une liste a l'index voulu.
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


% Verifie si on peut placer une piece verticale sur le plateau
% a la position indiquee.
emplacementVerticalLibre(Plateau, X, Y) :-
    \+ligne(X),
    suivant(X, XSuiv),
    libre(X, Y, Plateau),
    libre(XSuiv, Y, Plateau).

emplacementHorizontalLibre(Plateau, X, Y) :-
    \+colonne(Y),
    suivant(Y, YSuiv),
    libre(X, Y, Plateau),
    libre(X, YSuiv, Plateau).
% Verifie si on peut mettre une piece verticale
% quelquepart sur le plateau.
peutJouerVertical(Plateau, X, Y) :-
    \+ligne(X),
    emplacementVerticalLibre(Plateau, X, Y).

peutJouerVertical(Plateau, X, Y) :-
    \+ligne(X),
    \+colonne(Y),
    suivant(Y, YSuiv),
    \+emplacementVerticalLibre(Plateau, X, Y),
    peutJouerVertical(Plateau, X, YSuiv).

peutJouerVertical(Plateau, X, Y) :-
    \+ligne(X),
    colonne(Y),
    \+emplacementVerticalLibre(Plateau, X, Y),
    suivant(X, XSuiv),
    peutJouerVertical(Plateau, XSuiv, 1).


% Verifie si on peut mettre une piece horizontale
% quelquepart sur le plateau.
peutJouerHorizontal(Plateau, X, Y) :-
    \+colonne(Y),
    emplacementHorizontalLibre(Plateau, X, Y).

peutJouerHorizontal(Plateau, X, Y) :-
    \+colonne(Y),
    \+ligne(X),
    \+emplacementHorizontalLibre(Plateau, X, Y),
    suivant(X, XSuiv),
    peutJouerHorizontal(Plateau, XSuiv, Y).

peutJouerHorizontal(Plateau, X, Y) :-
    \+colonne(Y),
    ligne(X),
    \+emplacementHorizontalLibre(Plateau, X, Y),
    suivant(Y, YSuiv),
    peutJouerHorizontal(Plateau, 1, YSuiv).
