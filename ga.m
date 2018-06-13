% % Esta funcao emprega algoritmos geneticos para 
% % resolver o problema de alocacao de containeres
% % em navios.
% NOVIDADE:::::::  TODOS OS CONTÊINERES DO PATIO SAO RETIRADOS
% % Navio  % matriz de ocupacao B, do navio. É uma matriz de zeros
% % navio  % vetor que guarda a informacao sobre qual eh o navio de destino
% %          de cada conteiner
% % porto  % vetor que guarda a informacao sobre qual eh o porto de destino
% %          de cada conteiner
% % np     % numero de portos percorridos
% % patio  % matriz de ocupacao T, do patio
% % lbound % limite inferior da quantidade de regras % lbound = 1
% % ubound % limite superior da quantidade de regras % ubound = 48
% % TESTE:
% % [patio,navio,porto,Navio,np] = gera_cenario(7,10,6,4)
% % [X,fit,tempo]=ga(Navio,navio,porto,patio,4,1,48)

function [X,fit]=ga(Navio,porto,patio,np,lbound,ubound)
    
  %  NomeInstancia = input('Nomeie a instancia de teste como = Instancia + Numero -> ');
    
%     myCluster = parcluster('local');
%     myCluster.NumWorkers = 4;  % 'Modified' property now TRUE
%     saveProfile(myCluster);    % 'local' profile now updated,
%     parpool(4)
     % Declaração de valores importantes 
     % e que serão utilizados ao longo do
     % programa.
     elapsedtime= tic;
     POPSIZE = 10;       % Pop. Size.
     MAXGENS = 200;      % Max number of generations.
     ITERSHOW = 10;      % Max number of iterations without graphics.
     PXOVER = 0.8;       % Probability of crossover.
     PMUTATION = 0.15;   % Probability of mutation.    %0.15.
     TCONSTRAINT = 1.0;  % Constraint violation penalization factor.
     generation = 0;     % Initial number of generations.
     NVARS = np - 1;     % Number of variables.
    % map = [1 0 0; 0 1 0; 0 0 1; 0.5 0 0.5];
    % kind = 1;
     melhores = zeros(1,MAXGENS);
     xrep=zeros(MAXGENS,3);
     ultima_geracao = 0;
          
     % Chamadas as funções auxiliares.
     population = initialize(POPSIZE,NVARS,lbound,ubound);      
     population = evaluate(POPSIZE,population,Navio,porto,patio,MAXGENS,generation); 
     population = keep_the_best(POPSIZE,NVARS,population);
     melhores(1) = population(POPSIZE+1).fitness;
     while (generation < MAXGENS)
       generation = generation + 1;
       ipopulation = select(POPSIZE,population);
       
       %------------------------------------------------%

       %------------------------------------------------%
       ipopulation = crossover(POPSIZE, PXOVER, NVARS, population);
       ipopulation = mutate(POPSIZE, NVARS, PMUTATION, ipopulation);
       population = cbelitist(POPSIZE,NVARS,ipopulation);       
       population = evaluate(POPSIZE,population,Navio,porto,patio,MAXGENS,generation);
       population = keep_the_best(POPSIZE,NVARS,population);
       melhores(generation+1) = population(POPSIZE+1).fitness;
       xrep(generation,:) = report(POPSIZE, population);
       fprintf(1,'Geracao: %4d -> Best Fitness: %8.4f  \n',generation,1/xrep(generation,1)-1);
      
     end
      p = gcp;
      delete(p)
     % Copiando informações das soluções da última geração
     % para uma matriz X.
     for i=1:POPSIZE+1
         X(i,:) = population(i).gene;
     end  
     
     % Copiando a informação de fitness dos individuos para
     % um vetor de fitness.
     for i=1:POPSIZE+1
       fit(i) = (1.0/(population(i).fitness)-1.0);     
     end       
     
   % tempo = toc;
    toc(elapsedtime)
    XREP=1./xrep(:,1)-1;
    plot(XREP)
   % save(NomeInstancia, 'X','fit');
end
     