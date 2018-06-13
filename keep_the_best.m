%/***************************************************************/
%/* Keep_the_best function: This function keeps track of the    */
%/* best member of the population. Note that the last entry in  */
%/* the array Population holds a copy of the best individual    */
%/***************************************************************/
function population = keep_the_best(POPSIZE,np,population)

   cur_best = 0;
   
   for mem=1:POPSIZE
     if (population(mem).fitness >= population(POPSIZE+1).fitness)
       cur_best = mem;
       population(POPSIZE+1).fitness = population(mem).fitness;                              
     end     
   end

   %no better one found keep existing one
   if (cur_best ~= 0)
   
       % Once the best member in the population is found, copy genes.
       for i=1:(np)
         population(POPSIZE+1).gene(i) = population(cur_best).gene(i);
       end
   
   end
end
