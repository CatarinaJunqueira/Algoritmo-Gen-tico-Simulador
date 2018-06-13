
function [mov_total,patio,Navio,lista_descarregamento] = mover_navio(patio,l_navio,vzio,Navio,RegraCarregamento,porto,lista_descarregamento,navio,localiza)

navio2=navio;
porto2=porto;
mov_total = 0;  %gerando dados iniciais

%-------------------------------------------------------------%
% identificando a regra de carregamento que vai ser utilizada % 
Rc = strcat('Rc',int2str(RegraCarregamento));

if (RegraCarregamento == 2) || (RegraCarregamento == 4) % se a regra Rc é a Rc2 ou a Rc4
   [m,n]=size(Navio);
   altura_max = ceil((length(l_navio) + length(find(Navio ~= 0)))/n);
end
%-------------------------------------------------------------%

%----------------------------------------------------------------------------------------------------------------------------------------------%
% Primeiro verifica-se se existem contêineres que estão na lista l_navio que estão no topo de suas filas e podem ser retirados sem remanejamento 
u=isempty(l_navio);

     while u~=1        
         
           [bool] = topo(patio,l_navio(1,:)); % verifica se eh topo ou nao

            if (bool == 1) % Está no topo(1), ou seja, não é necessário mais que uma movimentacao de conteiner

               [patio,conteiner] = remover(patio,l_navio(1,:)); %tira do patio
               
                mov_total = mov_total + 1; %Soma o custo da movimentacao total
                
                [~,col]=find((navio2(2,:)==conteiner));
                
                navio2(:,col)=[];
                
                porto2(:,col)=[];                

               if (RegraCarregamento == 2) || (RegraCarregamento == 4)
                   [Navio,lista_descarregamento] = feval(Rc,Navio,conteiner,altura_max,lista_descarregamento,porto); %chamando a regra de carregamento no navio
               else
                   [Navio,lista_descarregamento] = feval(Rc,Navio,conteiner,lista_descarregamento,porto); %chamando a regra de carregamento no navio                       
               end

               mov_total = mov_total + 1; %Soma o custo da movimentacao total
               
            else
               acima = quem_acima(patio,l_navio(1,:)); %vejo quem está acima dessa posição
               contador=1;
                      
                for k = (1:size(acima,1)) % de 1 até quantidade de conteineres que devem ser remanejados

                    if (acima(contador)~=0)
                       [vazio] = feval(vzio,patio,l_navio(1,:)); %atualiza a lista de vazios
                       [patio] = trocar(patio,acima(contador,:),vazio(1,:)); % troque por essa posição do vazio.                                                                                        
                       mov_total = mov_total + 1; %Soma o custo da movimentacao total
                       acima(contador,:)=0; %transforma o valor em 0, indica que ja foi visto
                       contador=contador+1;                                        

                        if sum(sum(acima))==0
                            break
                        end

                    end                            
                end

               [patio,conteiner] = remover(patio,l_navio(1,:)); %tira do patio
                mov_total = mov_total + 1; %Soma o custo da movimentacao total
               [~,col]=find((navio2(2,:)==conteiner));   
                navio2(:,col)=[];             
                porto2(:,col)=[]; 

               if (RegraCarregamento == 2) || (RegraCarregamento == 4) % Carrega no navio
                   [Navio,lista_descarregamento] = feval(Rc,Navio,conteiner,altura_max,lista_descarregamento,porto); %chamando a regra de carregamento no navio
               else
                   [Navio,lista_descarregamento] = feval(Rc,Navio,conteiner,lista_descarregamento,porto); %chamando a regra de carregamento no navio                       
               end
               
               mov_total = mov_total + 1; %Soma o custo da movimentacao total
            end
        [l_navio] = feval(localiza,patio,navio,1);
        u=isempty(find(l_navio~=0, 1));

     end
end