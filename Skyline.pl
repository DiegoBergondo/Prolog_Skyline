% Predicado edificioAskyline, lo único que hace es recibir los tres valores de un edificio individA1l
% y devuelve su linea de horizonte.
edificioAskyline(ed(X,Y,Z), [c(X,Z),c(Y,0)]).

% Predicado divide, que recibe una lista y la divide a la mitad para devolver la tupla de listas
% de edificios ya divididas, si es impar habrá como máximo una diferencia de uno entre ambas.
% El modo de conseguirlo es dividir la longitud de la lista entre dos con div ya que devuelve un
% valor entero y con ese valor se separa la primera parte de la lista, de la segunda.
divide(X, Y, Z):- length(X, T), Half is T div 2, length(Y, Half), length(Z, _), append(Y, Z, X).

% Predicado combina, a la que se le pasan dos lineas de horizonte y devuelve una linea de horizonte calculada
% desde las otras dos, para esto se utilizará un predicado auxiliar (combinaAux) y se valorarán los casos
% posibles, actA1lizando el valor en caso de ser necesario.
combina(LH1,LH1).
combina(LH1,LH2,X):- combinaAux(LH1,LH2,X,0,0,0).
combinaAux([],[],[],_,_,_).
combinaAux([c(X1,H1)|R1],[],[c(X1,Z)|X],_,A3,A1):-
(val_max(H1,A3,Z),A1 =\= Z, combinaAux(R1,[],X,H1,A3,Z)).
combinaAux([c(_,H1)|R1],[],X,_,A3,A1):-
(val_max(H1,A3,Z),A1 == Z, combinaAux(R1,[],X,H1,A3,Z)).
combinaAux([],[c(X2,H2)|R2],[c(X2,Z)|X],A2,_,A1):-
(val_max(A2,H2,Z),A1 =\= Z, combinaAux([],R2,X,A2,H2,Z)).
combinaAux([],[c(_,H2)|R2],X,A2,_,A1):-
(val_max(A2,H2,Z),A1 == Z, combinaAux([],R2,X,A2,H2,Z)).
combinaAux([c(X1,H1)|R1],[c(X2,H2)|R2],[c(X1,Z)|X],_,A3,A1):-
(X1<X2,val_max(H1,A3,Z),A1 =\= Z, combinaAux(R1,[c(X2,H2)|R2],X,H1,A3,Z)).
combinaAux([c(X1,H1)|R1],[c(X2,H2)|R2],X,_,A3,A1):-
(X1<X2,val_max(H1,A3,Z),A1 == Z, combinaAux(R1,[c(X2,H2)|R2],X,H1,A3,Z)).
combinaAux([c(X1,H1)|R1],[c(X2,H2)|R2],[c(X1,Z)|X],_,_,A1):-
(X1 == X2, val_max(H1,H2,Z),A1 =\= Z, combinaAux(R1,R2,X,H1,H2,Z)).
combinaAux([c(X1,H1)|R1],[c(X2,H2)|R2],X,_,_,A1):-
(X1 == X2,val_max(H1,H2,Z),A1 ==Z, combinaAux(R1,R2,X,H1,H2,A1)).
combinaAux([c(X1,H1)|R1],[c(X2,H2)|R2],[c(X2,Z)|X],A2,_,A1):-
(X1>X2,val_max(A2,H2,Z),A1 =\= Z, combinaAux([c(X1,H1)|R1],R2,X,A2,H2,Z)).
combinaAux([c(X1,H1)|R1],[c(X2,H2)|R2],X,A2,_,A1):-
(X1>X2,val_max(A2,H2,Z),A1 == Z, combinaAux([c(X1,H1)|R1],R2,X,A2,H2,Z)).
% Predicado auxiliar utilizado en combina para determinar el mayor de dos valores.
val_max(X,Y,Z):-X<Y,Z is Y,!.
val_max(X,Y,Z):-X>=Y,Z is X,!.

% Predicado resuelveSkyline, predicado principal que recibe la lista de edificios y devuelve el skyline final, para
% ello se realizará recursivamente la combinación de cada una de las divisiónes de las listas de dos edificios 
% hasta que quede el skyline final que será lo que se devuelva. 
resuelveSkyline([],[]).
resuelveSkyline([ed(X1,X2,HX)],X):-edificioAskyline(ed(X1,X2,HX),X),!.
resuelveSkyline([ed(X1,X2,HX),ed(Y1,Y2,HY)|XY],X):-divide([ed(X1,X2,HX),ed(Y1,Y2,HY)|XY],Y,Z),resuelveSkyline(Y,T),resuelveSkyline(Z,U),combina(T,U,X),!.