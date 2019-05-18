%
% Pour lancer le jeu, executer : lancerJeu.
% Dimensions maximales du plateau : 8x8.
% 


% 
% BASE DE FAITS
%
joueur(joueur1).
joueur(joueur2).

ligne(8).		% Nombre de lignes composant le plateau.
colonne(8).		% Nombre de colonnes composant le plateau.

suivant(0, 1).
suivant(1, 2).
suivant(2, 3).
suivant(3, 4).
suivant(4 ,5).
suivant(5, 6).
suivant(6, 7).
suivant(7, 8).
suivant(8, 9).



%
% FONCTIONS / REGLES
%

% Initialise une liste vide. Il s'agit d'une ligne dans un plateau.
initLigne(['_'], X) :-
    ligne(X).
initLigne(['_'|L], X) :-
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
    afficherTableau(0, L).

% Affichage des numeros des colonnes
afficherPremiereLigne(N) :-
    colonne(N),
    writeln(N).
afficherPremiereLigne(N) :-
    write(N), write("_"),
    suivant(N, NSuiv),
    afficherPremiereLigne(NSuiv).

% Afficher le plateau de jeu
afficherTableau(_, []) :-
    writeln("").
afficherTableau(0, L) :-
    afficherPremiereLigne(0),
    afficherTableau(1, L).
afficherTableau(N, [X|L]) :-
    write(N), write(" "),
    writeln(X),
    suivant(N, NSuiv),
    afficherTableau(NSuiv, L).

% Description du jeu. Doit se lancer au debut du jeu pour expliquer aux joueurs
% le fonctionnement de la partie.
description :-
    writeln("Description du jeu :"),
    writeln("Chaque joueur, l'un après l'autre, va sélectionner un numéro de ligne et un numéro de colonne."),
    writeln("Ce numéro marquera la coordonnée du premier point qui sera marqué, un deuxième point sera marqué, respectivement pour le joueur 1 et 2 la colonne +1 et la ligne +1."),
    writeln("Exemple : si le joueur 1 marque la case (1, 1), les cases (1, 1 ) et (1, 2) seront marquées"),
    writeln("Ainsi, le joueur 1 va jouer en ligne, et le joueur 2 en colonne, dès qu'un des deux joueurs se retrouve dans l'incapacité de jouer, il perd.").

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
    read(Y),
    X \== end_of_file,
    Y \== end_of_file.

% Pour jouer un tour.
    % Arret du jeu.
jouer(Plateau, joueur1) :-
    \+peutJouerHorizontal(Plateau, 1, 1),
    write("Joueur 1 a perdu ! Le joueur 2 remporte la partie."),
    abort().

jouer(Plateau, joueur2) :-
    \+peutJouerVertical(Plateau, 1, 1),
    writeln("Joueur 2 a perdu ! Le joureur 1 remporte la partie."),
    abort().

    % Jouer en placant un domino.
jouer(Plateau, joueur1) :-
    peutJouerHorizontal(Plateau, 1, 1),
    writeln("Joueur 1 : "),
    lireReponse(X, Y),
    placementHorizontal(o, X, Y, Plateau, NouveauPlateau, joueur1),
    afficherTableau(0, NouveauPlateau),
    jouer(NouveauPlateau, joueur2).

jouer(Plateau, joueur2) :-
    peutJouerVertical(Plateau, 1, 1),
    writeln("Joueur 2 : "),
    lireReponse(X, Y),
    placementVertical(d, X, Y, Plateau, NouveauPlateau, joueur2),
    afficherTableau(0, NouveauPlateau),
    jouer(NouveauPlateau, joueur1).

% Place un domino horizontalement sur plateau a la position spacifiee.
placementHorizontal(Pion, X, Y, Plateau, NouveauPlateau, joueur1) :-
    placer(Pion, X, Y, Plateau, PlateauIntermediaire),
    \+colonne(Y),
    suivant(Y, YSuiv),
    placer(Pion, X, YSuiv, PlateauIntermediaire, NouveauPlateau).

placementHorizontal(_, _, _, Plateau, _, joueur1) :-
    writeln("Coup incorrect, veuillez recommencez"),
    afficherTableau(0, Plateau),
	jouer(Plateau, joueur1).

% Place un domino verticalement sur le plateau a la position spécifiee.
placementVertical(Pion, X, Y, Plateau, NouveauPlateau, joueur2) :-
    placer(Pion, X, Y, Plateau, PlateauIntermediaire),
    \+ligne(X),
    suivant(X, XSuiv),
    placer(Pion, XSuiv, Y, PlateauIntermediaire, NouveauPlateau).

placementVertical(_, _, _, Plateau, _, joueur2) :-
    writeln("Coup incorrect, veuillez recommencez"),
    afficherTableau(0, Plateau),
	jouer(Plateau, joueur2).

% Verifie si la case a la position indiquee est libre.
libre(X, Y, Plateau) :-
    extraire(X, 1, Plateau, Liste),
    extraire(Y, 1, Liste, '_').

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
