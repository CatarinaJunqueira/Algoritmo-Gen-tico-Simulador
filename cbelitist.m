%/*****************************************************************/
%/* Elistist function: The best member of the previous generation */
%/* is stored as the last in the array. If the best member of     */
%/* the current generation is worse then the best member of the   */
%/* previous generation, the latter one would replace the worst   */
%/* member of the current population                              */
%/*****************************************************************/

function population = cbelitist(POPSIZE,NVARS,population)
   
   best = population(1).fitness;
   best_mem = 1;
   worst = population(1).fitness;
   worst_mem = 1;
   for i=2:POPSIZE
%     if ((population(i).fitness > population(i+1).fitness)&(population(i).unfitness == 0))
      if (population(i).fitness > population(i+1).fitness)
       if (population(i).fitness >= best)                                 
         best = population(i).fitness;
         best_mem = i;                                 
       end
       if (population(i+1).fitness <= worst)
         worst = population(i+1).fitness;
         worst_mem = i + 1;                                    
       end    
     else    
       if (population(i).fitness <= worst)
         worst = population(i).fitness;
         worst_mem = i;                                   
       end      
       %if (population(i+1).fitness >= best)&(population(i+1).unfitness == 0)
       if (population(i+1).fitness >= best)
         best = population(i+1).fitness;
         best_mem = i + 1;                                    
       end
     end
   end
   
   
% %    % Primeiro grupo G1: Individuo infactivel e com o pior fitness.
% %    % Tentando verificar se existe alguém do grupo G1.
% %    worst_mem = -1;
% %    for i=1:POPSIZE
% %      if (population(i).unfitness > 0)
% %        if (worst_mem == -1)  
% %          worst = population(i).fitness;
% %          worst_mem = i;                                 
% %        else
% %          if (population(i).fitness < worst)  
% %            worst = population(i).fitness;
% %            worst_mem = i;                                              
% %          end    
% %        end    
% %      end    
% %    end  
% %    
% %    % Teste para ver se é necessário usar algum candidato do grupo G2.
% %    if (worst_mem == -1)
% %      fprintf(1,'Grupo 2 \n');
% %      % Segundo grupo G2: Individuo infactivel com o pior fitness.
% %      % Tentando verificar se existe alguém do grupo G2.
% %      worst_mem = -1;
% %      for i=1:POPSIZE
% %        if (population(i).unfitness > 0)
% %          if (worst_mem == -1)  
% %            worst = population(i).fitness;
% %            worst_mem = i;                                 
% %          else
% %            if (population(i).fitness >= worst)  
% %              worst = population(i).fitness;
% %              worst_mem = i;                                              
% %            end    
% %          end    
% %        end    
% %      end  
% %    end
% % 
% %    % Teste para ver se é necessário usar algum candidato do grupo G3.
% %    if (worst_mem == -1)
% %      fprintf(1,'Grupo 3 \n');
% %      % Terceiro grupo G3: Individuo factivel com o pior fitness.
% %      % Tentando verificar se existe alguém do grupo G2.
% %      worst_mem = -1;
% %      for i=1:POPSIZE
% %       if (population(i).unfitness == 0)
% %          if (worst_mem == -1)  
% %            worst = population(i).fitness;
% %            worst_mem = i;                                 
% %          else
% %            if (population(i).fitness < worst)  
% %              worst = population(i).fitness;
% %              worst_mem = i;                                              
% %            end    
% %          end    
% %       end    
% %      end  
% %    end
% %    
% %    % Teste para ver se é necessário usar algum candidato do grupo G4.
% %    if (worst_mem == -1)
% %        fprintf(1,'Grupo 4 \n');
% %        % Tentando extrair da populacao quatro indivíduos.
% %        % Primeiro grupo G4: Individuo factivel com o melhor fitness.
% %        % Tentando verificar se existe alguém do grupo G4.
% %        worst_mem = -1;
% %        for i=1:POPSIZE
% %          if (population(i).unfitness == 0)
% %            if (worst_mem == -1)  
% %              worst = population(i).fitness;
% %              worst_mem = i;                                 
% %            else
% %              if (population(i).fitness >= worst)  
% %               worst = population(i).fitness;
% %               worst_mem = i;                                              
% %              end    
% %            end    
% %          end    
% %        end  
% %        
% %    end    

% % % Analisando todos os individuos que compoem ipopulation.
% % for k=1:POPSIZE
% % 
% %    % Primeiro grupo G1: Pior unfitness e pior fitness 
% %    % tudo em relacao ao individuo novo.
% %    % Tentando verificar se existe alguém do grupo G1.
% %    worst_mem = -1;
% %    i=1;
% %    while ((worst_mem == -1)&(i<=POPSIZE))
% %      if (population(i).fitness <= ipopulation(k).fitness)&(population(i).unfitness >= ipopulation(k).unfitness)
% %         worst_mem = i;                                 
% %      end
% %      i=i+1;
% %    end
% % 
% %    if (worst_mem == -1)
% %      i=1;
% %      while ((worst_mem == -1)&(i<=POPSIZE))
% %        % Segundo grupo G2: Pior unfitness e melhor fitness.
% %        % Tentando verificar se existe alguém do grupo G2.
% %        if (population(i).fitness > ipopulation(k).fitness)&(population(i).unfitness >= ipopulation(k).unfitness)
% %           worst_mem = i;                                 
% %        end         
% %        i=i+1;
% %      end
% %    end
% % 
% %    if (worst_mem == -1)
% %      i=1;
% %      while ((worst_mem == -1)&(i<=POPSIZE))
% %        % Terceiro grupo G3: Melhor unfitness e pior fitness.
% %        % Tentando verificar se existe alguém do grupo G3.
% %        if (population(i).fitness <= ipopulation(k).fitness)&(population(i).unfitness < ipopulation(k).unfitness)
% %           worst_mem = i;                                 
% %        end         
% %        i=i+1;
% %      end
% %    end
% %    
% %    if (worst_mem == -1)
% %      i=1;
% %      while ((worst_mem == -1)&(i<=POPSIZE))
% %        % Quarto grupo G4: Melhor unfitness e melhor fitness.
% %        % Tentando verificar se existe alguém do grupo G4.
% %        if (population(i).fitness > ipopulation(k).fitness)&(population(i).unfitness < ipopulation(k).unfitness)
% %           worst_mem = i;                                 
% %        end         
% %        i=i+1;
% %      end
% %    end  
% %    
% %    % Substituindo o valor encontrado em algum dos GRUPOS G1, G2, G3, G4 
% %    % de population por um individuo de ipopulation.
% %    % population(worst_mem) = ipopulation(k);
% %    % Realizando a substituicao, quando possivel, do pior 
% %    % individuo de population por outro de ipopulation !!
% %    if (worst_mem ~= -1)&(worst_mem ~= best_mem)
% %      for i=1:NVARS
% %        population(worst_mem).gene(i) = ipopulation(k).gene(i);
% %      end  
% %      population(worst_mem).fitness = ipopulation(k).fitness;                    
% %      population(worst_mem).unfitness = ipopulation(k).unfitness;                    
% %    end  
% % 
% %    
% % end
   
   %/* if best individual from the new population is better than */
   %/* the best individual from the previous population, then    */
   %/* copy the best from the new population; else replace the   */
   %/* worst individual from the current population with the     */
   %/* best one from the previous generation                     */ 
   
   if (best >= population(POPSIZE+1).fitness)
     for i=1:NVARS
       population(POPSIZE+1).gene(i) = population(best_mem).gene(i);
     end  
     population(POPSIZE+1).realfitness = population(best_mem).realfitness;
     population(POPSIZE+1).fitness = population(best_mem).fitness;          
     %population(POPSIZE+1).unfitness = population(best_mem).unfitness;          
     %fprintf(1,'Fitness: %8.4f | Unfitness: %8.4f \n',population(best_mem).fitness,population(best_mem).unfitness)
   end  
   
   
   