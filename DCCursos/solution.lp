
% ACTIVIDAD 1: Reglas Basicas
%----------------------------------------

% 1.1 Cada curso solo puede tomarse hasta una vez

:-tomar(C,S1),tomar(C,S2),S1!=S2.   

% 1.2 Cada semestre se toman a lo sumo 6 cursos
0 {tomar(Sigla, S):curso(Sigla,_) } 6 :- semestre(S).

% 1.3 Se toman todos los cursos X_necesarios de Plan Comun y Major
tomar(C,S+1):-pc_necesario(C, S),semestre(S+1),curso(C,_). % Ej. pc necesario("MAT1610", 0)
tomar(C,S+1):-major_necesario(C, S),semestre(S+1),curso(C,_).

% 1.4 Solo se puede tomar un curso en un semestre par/impar si es dictado en ese semestre

:-tomar(C,S),curso(C,1),semestre(S),S\2==0.
:-tomar(C,S),curso(C,2),semestre(S),S\2==1.

% 1.5 Para un mismo ID de requisito (definido en X_optativo(C, ID)), se debe tomar al menos uno de los cursos

%1{tomar(C, S+1):major_optativo(C,S)},semestre(S+1).
1{tomar(C, S+1):pc_optativo(C,S)}:-pc_optativo(_,S),semestre(S+1).
1{tomar(C, S+1):major_optativo(C,S)}:-semestre(S+1),major_optativo(_,S).


% ACTIVIDAD 2: Requisitos y Correquisitos
%----------------------------------------

% 2.1 Cumplir el subrequisito 3 de un curso para un cierto IDX1 e IDX2
req3(C1,IDX1,IDX2):-requisito(C1,IDX1,IDX2,_,C2),tomar(C2,S2),S2<S1,tomar(C1,S1).
%si hay un requisito para C1 y que se toma el curso C2 en un semestre antes entonces se cumple req3
req3(C1,IDX1,IDX2):-correquisito(C1,IDX1,IDX2,_,C2),tomar(C2,S2),S2<=S1,tomar(C1,S1).

% 2.2 Cumplir el subrequisito 2 de un curso para un cierto IDX1
req2(C,IDX1):-req3(C,IDX1,IDX2),requisito(C,IDX1,_,_,_).
req2(C,IDX1):-req3(C,IDX1,IDX2),correquisito(C,IDX1,_,_,_).

% 2.3 Cumplir el subrequisito 1 de un curso
1{req1(C):req2(C,_)}.

% 2.4 Si tiene requisitos, se necesita cumplir el subrequisito 1 de un curso para poder tomarlo
:-requisito(C1,_,_,_,_),not req1(C1),tomar(C1,S),semestre(S).


% NO TOCAR!!
%----------------------------------------
% Se definen los semestres usando la constante especificada mediante "-c bound=X"
semestre(1..bound).

% Usado para visualizar la toma final de cursos
#show tomar/2.

% Esta linea permite minimizar el numero total de cursos tomados en total, no tocar
total_courses(T) :- T = #count {C : tomar(C, _)}.
#minimize{T : total_courses(T)}.

% Definimos predicados presentes en los test para evitar errores
#defined pc_necesario/2.
#defined major_necesario/2.
#defined pc_optativo/2.
#defined major_optativo/2.
#defined requisito/5.
#defined correquisito/5.
#defined cursos_major/1.
#defined cursos_pc/1.
