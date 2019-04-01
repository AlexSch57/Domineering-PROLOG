joueur(joueur1) .
joueur(joueur2) .


turn(joueur1) .


vertical(joueur1, X, Y) :- turn(joueur1), ligne(X), colonne(Y) .


ligne(5).
colonne(6).

suivant(0, 1).
suivant(1, 2).
suivant(2, 3).
suivant(3, 4).
suivant(4 ,5).
suivant(5, 6).

ajoute_debut(X, L1, [X|L1]).


creerListe([-|_], X) :- ligne(X).
creerListe([-|L], X) :-
    suivant(X, Y),
    \+ligne(X),
    creerListe(L, Y).

%creerListe(L, X) :-
 %   suivant(X, Y),
  %  ajoute_debut(-, L, L),
   % creerListe(L, Y).
