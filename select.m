%/***************************************************************/
%/* Selection function: Standard proportional selection for     */
%/* maximization problems incorporating elitist model - makes   */
%/* sure that the best member survives                          */
%/***************************************************************/
function newpopulation = select(POPSIZE,population)
    
    
    % Find total fitness of the population
    sum = 0;
    for mem=1:POPSIZE
      sum = sum + population(mem).fitness;  
    end
    
    % Calculate relative fitness
    for mem=1:POPSIZE
      population(mem).rfitness = population(mem).fitness/sum;  
    end
    
    
    % Calculate cumulative fitness
    population(1).cfitness = population(1).rfitness;
    for mem=2:POPSIZE
      population(mem).cfitness = population(mem-1).cfitness + population(mem).rfitness;  
    end
    
    % Finally select survivors using cumulative fitness.
    for i=1:POPSIZE
      p = rand();
      if (p < population(1).cfitness)
        newpopulation(i) = population(1);
      else
        for j=1:POPSIZE
          if ((p >= population(j).cfitness) && (p < population(j+1).cfitness))
            newpopulation(i) = population(j+1);  
          end 
        end
      end  
    end
    
%     % Finally select 2 parents to generate a new cromossome 
%     % using Maximum Compability Selection where if the first 
%     % cromossome is feasible, then we use again the cumulative 
%     % fitness to select the second. If the first is not feasible, 
%     % then the second is selected as a diferent cromossome can 
%     % be feasible or not.
%     
%     % Selecting the first parent.
%     p = rand();
%     if (p < population(1).cfitness)
%       newpopulation(1) = population(1);
%     else
%       for j=1:POPSIZE
%         if ((p >= population(j).cfitness) && (p < population(j+1).cfitness))
%           newpopulation(1) = population(j+1);  
%         end 
%       end      
%     end  
%     
%     % Selecting the second parent.
%     % If is feasible then applied cumulative fitness
%     % to select the second parent.
%     if (newpopulation(1).unfitness == 0)    
%         
%       % Using cumulative fitness.  
%       p = rand();
%       if (p < population(2).cfitness)
%         newpopulation(2) = population(2);
%       else
%         for j=1:POPSIZE
%           if ((p >= population(j).cfitness) && (p < population(j+1).cfitness))
%             newpopulation(2) = population(j+1);  
%           end 
%         end      
%       end  
%         
%     else
%         
%       % Verifying is it enough diferent from parent 1.  
%       
%         
%     end    
    
        
    % once a new population is created, copy it back.
    for i=1:POPSIZE
      population(i) = newpopulation(i);   
    end
end
