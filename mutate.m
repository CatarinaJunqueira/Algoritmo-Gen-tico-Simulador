%/***************************************************************/
%/* Mutation: Random uniform mutation. A variable selected for  */
%/* mutation is replaced by a random value between lower and    */
%/* upper bounds of this variable                               */
%/***************************************************************/

function population = mutate(POPSIZE, NVARS, PMUTATION, population)
  
  Maxf = max([population.fitness]);
  Meanf = mean([population.fitness]);  
  
  for i=1:POPSIZE
    for j=1:NVARS
      x = rand();
      %PMUTATION = 0.5*(Maxf - population(i).fitness)/(Maxf - Meanf);  
      if (x < PMUTATION)
         % find the bounds of the variable to be mutated
         lbound = population(i).lower(j);   
         hbound = population(i).upper(j);
         population(i).gene(j) = randval(lbound, hbound);
      end
    end  
  end 
      
  
  