% Professores
professor(aline).
professor(luciana).
professor(flavia).
professor(simone).
professor(beatriz).
professor(leonardo).
professor(john).
professor(dante).
professor(luis).
professor(igor).
professor(cristiano).

% disponibilidade de um professor em um horário
disponivel(aline,7).
disponivel(aline,11).
disponivel(luciana,14).
disponivel(luciana,9).
disponivel(flavia,11).
disponivel(simone,9).
disponivel(simone,11).
disponivel(beatriz,9).
disponivel(beatriz,11).
disponivel(leonardo,14).
disponivel(leonardo,16).
disponivel(john,7).
disponivel(john,9).
disponivel(john,11).
disponivel(dante,9).
disponivel(luis,11).
disponivel(luis,16).
disponivel(igor,7).
disponivel(igor,9).
disponivel(cristiano,11).

% turma par (Id,Horário)
turma(1,7). 
turma(2,7). 
turma(3,7).
turma(4,9).
turma(5,9).
turma(6,9).
turma(7,9).
turma(8,9).
turma(9,11).
turma(10,11).
turma(11,11).
turma(12,11).
turma(13,11).
turma(14,14).
turma(15,14).

% Conta ocorrência de um elemento em lista
conta_ocorr([] , _,0). %lista vazia, caso base.
% Contando usando a cabeça da lista
conta_ocorr([H|T] , H, NQtd):-
    conta_ocorr(T, H, VQtd),
    NQtd is VQtd+1.
% Se a cabeça não for o elemento mantem a contagem antiga
conta_ocorr([H|T], H2, Qtd):-
    dif(H,H2),
    conta_ocorr(T, H2, Qtd).

% Conta total ocorrencias de um elemento cabeça de uma lista dentro de outra lista
total_cabeca(El,ListaL, Total) :-
    findall(C, conta_ocorr(ListaL,[El|_],C), L),
    conta_ocorr(L,1,Total).

% Objetivo alocar todas as turmas
objetivo(Turma) :- 
    findall(T, turma(T, _), ListaTurma),
    length(ListaTurma, NTurmas),
    Turma > NTurmas.

% Verifica a disponibilidade de um professor ser alocado a uma turma
cand(P,T,H) :-
    professor(P),
    turma(T,H),
    disponivel(P,H).

% Verifica se é possível alocar um professor de acordo com as restrições
% Um professor não pode ter mais de 2 turmas
% Um professor não pode dar aula para 2 turmas no mesmo horário
% Cada turma só pode ter um professor
valida(Prof,Turma,H,Estado) :-
    not(member([Prof,Turma,H], Estado)),
    not(member([Prof,_,H], Estado)),
    not(member([_,Turma,H], Estado)),
    total_cabeca(Prof, Estado, TurmasProf),
    TurmasProf < 2.

% Algoritmo de busca
profundidade(Estado, Turma, Solucao):-
    objetivo(Turma),
    reverse(Estado,Solucao).

profundidade(Estado, Turma, Solucao):-
    cand(Prof,Turma,H),
    valida(Prof,Turma,H,Estado),
    NovaTurma is Turma+1,
    profundidade([[Prof,Turma,H]|Estado], NovaTurma, Solucao),!.
