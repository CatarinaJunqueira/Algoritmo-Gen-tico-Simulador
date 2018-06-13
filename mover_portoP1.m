
function [mov_total,patio,Navio,lista_descarregamento] = mover_portoP1(patio,l_navio,vzio,Navio,RegraCarregamento,porto,lista_descarregamento,localiza,navio)

%Distancia=0;
qtd_cont = length(l_navio); %quantidade de cont�ineres que v�o sair
mov_total = 0;  %gerando dados iniciais

%--------------------------------------------------------------------------------------------------------------%
% id_porto = unique(porto); % Criando um D inicial com valores 0. Tamanho dele � = ao n�mero de portos percorridos
% t=length(id_porto);
% t2=id_porto(t);
% D=zeros(1,t2);
%--------------------------------------------------------------------------------------------------------------%

%-------------------------------------------------------------%
% identificando a regra de carregamento que vai ser utilizada % 
Rc = strcat('Rc',int2str(RegraCarregamento));

if (RegraCarregamento == 2) || (RegraCarregamento == 4) % se a regra Rc � a Rc2 ou a Rc4
   [m,n]=size(Navio);
   altura_max = ceil((length(l_navio) + length(find(Navio ~= 0)))/n);
end
%-------------------------------------------------------------%
for 
end
         while sum(sum(l_navio))~=0
              for n_cont = (1:qtd_cont)   
                if (l_navio(n_cont) ~= 0)
                    [bool] = topo(patio,l_navio(n_cont,:)); % verifica se eh topo ou nao

                    if (bool == 1) % Est� no topo(1), ou seja, n�o � necess�rio mais que uma movimentacao de conteiner

                      % [D] = inserirD(D,patio,l_navio(n_cont,:),porto); %inserir no Dnavio o porto de destino daquele cont�iner

                       [patio,conteiner] = remover(patio,l_navio(n_cont,:)); %tira do patio
                       [col]=find(navio(2,:)==conteiner);
                       navio(:,col)=[];
                       [l_navio] = feval(localiza,porto,patio,navio,1);
                       l_navio(n_cont,:)=0; %transforma o valor em 0, indica que ja foi visto

                       mov_total = mov_total + 1; %Soma o custo da movimentacao total

                           if (RegraCarregamento == 2) || (RegraCarregamento == 4)
                               [Navio,lista_descarregamento] = feval(Rc,Navio,conteiner,altura_max,lista_descarregamento,porto); %chamando a regra de carregamento no navio
                           else
                               [Navio,lista_descarregamento] = feval(Rc,Navio,conteiner,lista_descarregamento,porto); %chamando a regra de carregamento no navio                       
                           end

                       mov_total = mov_total + 1; %Soma o custo da movimentacao total

                    else
                         acima = quem_acima(patio,l_navio(n_cont,:)); %vejo quem est� acima dessa posi��o
                         [vazio] = feval(vzio,patio,l_navio(n_cont,:)); %retorna uma lista das posi��es vazias
                         tam_vazio = size(vazio,1); %quantidade de posi��es vazias
                         contador=1;

                        for k = (1:tam_vazio) % de 1 at� quantidade de posi��es vazias

                            if (acima(contador)~=0)
                               [vazio] = feval(vzio,patio,l_navio(n_cont,:)); %atualiza a lista de vazios
                               [patio] = trocar(patio,acima(contador,:),vazio(1,:)); % troque por essa posi��o do vazio.                                                                                        
                               [l_navio] = feval(localiza,porto,patio,navio,1);
                               mov_total = mov_total + 1; %Soma o custo da movimentacao total
                               %[distancia] = dist(acima(contador,2),vazio(1,2));
                               %Distancia=Distancia+distancia;
                               acima(contador,:)=0; %transforma o valor em 0, indica que ja foi visto
                               contador=contador+1;                                        

                                if sum(sum(acima))==0
                                    break
                                end

                            end                            
                        end

                        [patio,conteiner] = remover(patio,l_navio(n_cont,:)); %tira do patio
                        [col]=find(navio(2,:)==conteiner);
                        navio(:,col)=[];
                        [l_navio] = feval(localiza,porto,patio,navio,1);
                        mov_total = mov_total + 1; %Soma o custo da movimentacao total do remanejamento
                        l_navio(n_cont,:)=0; %transforma o valor em 0, indica que ja foi visto

                           if (RegraCarregamento == 2) || (RegraCarregamento == 4)
                               [Navio,lista_descarregamento] = feval(Rc,Navio,conteiner,altura_max,lista_descarregamento,porto); %chamando a regra de carregamento no navio
                           else
                               [Navio,lista_descarregamento] = feval(Rc,Navio,conteiner,lista_descarregamento,porto); %chamando a regra de carregamento no navio                       
                           end
                        mov_total = mov_total + 1; %Soma o custo da movimentacao total do carregamento

                    end
                end               
              end 
         end
  
% % % % Final da verifica��o de cont�ineres 'topos'
% % % %----------------------------------------------------------------------------------------------------------------------------------------------%
% % % 
% % % %----------------------------------------------------------------------------------------------------------------------------------------------%
% % % %Casos que nao estao no topo.
% % % for i = 1:length(l_navio)
% % %     if (l_navio(i)~=0)
% % %         [vazio] = feval(vzio,patio,l_navio(i,:)); %retorna uma lista das posi��es vazias
% % %         break
% % %     end
% % %     
% % % end
% % % 
% % %     for n_cont = (1:qtd_cont)
% % % 
% % %           if (l_navio(n_cont)~=0) % Se a lista de navio na posi��o indicada n�o for 0,
% % % 
% % %             acima = quem_acima(patio,l_navio(n_cont,:)); %vejo quem est� acima dessa posi��o
% % %             qtde_troca = 1;
% % %             trocas =0;
% % % 
% % %             while(qtde_troca > 0)
% % %                 qtde_troca = 0; %Condicao de parada
% % %                 max_acima = size(acima,1);
% % % 
% % %                     if (trocas == max_acima) 
% % %                         break
% % %                     else
% % %                         trocas = trocas +1;
% % %                     end
% % % 
% % %                        tam_vazio = size(vazio,1); %quantidade de posi��es vazias
% % %                        contador=1;
% % %                       
% % %                         for k = (1:tam_vazio) % de 1 at� quantidade de posi��es vazias
% % %                            
% % %                             if (acima(contador)~=0)
% % %                                [vazio] = feval(vzio,patio,l_navio(n_cont,:)); %atualiza a lista de vazios
% % %                                [patio] = trocar(patio,acima(contador,:),vazio(1,:)); % troque por essa posi��o do vazio.                                                                                        
% % %                                mov_total = mov_total + 1; %Soma o custo da movimentacao total
% % %                                %[distancia] = dist(acima(contador,2),vazio(1,2));
% % %                                %Distancia=Distancia+distancia;
% % %                                acima(contador,:)=0; %transforma o valor em 0, indica que ja foi visto
% % %                                contador=contador+1;                                        
% % %  
% % %                                 if sum(sum(acima))==0
% % %                                     break
% % %                                 end
% % %                                 
% % %                             end                            
% % %                         end
% % % % Termina de mover quem estava acima
% % % %----------------------------------------------------------------------------------------------------------------------------------------------%
% % % % Agora pode retirar o conteiner objetivo  
% % %                        mov_total = mov_total + 1; %Soma o custo da movimentacao total
% % % 
% % %                      %  [D] = inserirD(D,patio,l_navio(n_cont,:),porto); %inserir no Dnavio o porto de destino daquele cont�iner
% % % 
% % %                        [patio,conteiner] = remover(patio,l_navio(n_cont,:)); %tira do patio
% % %                        
% % %                        l_navio(n_cont,:)=0; %transforma o valor em 0, indica que ja foi visto
% % % 
% % %                        if (RegraCarregamento == 2) || (RegraCarregamento == 4)
% % %                            [Navio,lista_descarregamento] = feval(Rc,Navio,conteiner,altura_max,lista_descarregamento,porto); %chamando a regra de carregamento no navio
% % %                        else
% % %                            [Navio,lista_descarregamento] = feval(Rc,Navio,conteiner,lista_descarregamento,porto); %chamando a regra de carregamento no navio                       
% % %                        end
% % % 
% % %                        mov_total = mov_total + 1; %Soma o custo da movimentacao total
% % %  
% % %                      for j_cont = (1:qtd_cont)   % verifica se algu�m virou topo 
% % %                             if (l_navio(j_cont) ~= 0)
% % %                                 [bool] = topo(patio,l_navio(j_cont,:)); % verifica se eh topo ou nao
% % % 
% % %                                     if (bool == 1) % Est� no topo(1), ou seja, n�o � necess�rio mais que uma movimentacao de conteiner
% % % 
% % %                                        mov_total = mov_total + 1; %Soma o custo da movimentacao total
% % % 
% % %                                   %     [D] = inserirD(D,patio,l_navio(j_cont,:),porto); %inserir no Dnavio o porto de destino daquele cont�iner
% % % 
% % %                                        [patio,conteiner] = remover(patio,l_navio(j_cont,:)); %tira do patio
% % %                                        
% % %                                        l_navio(j_cont,:)=0; %transforma o valor em 0, indica que ja foi visto
% % %                                        
% % %                                        if (RegraCarregamento == 2) || (RegraCarregamento == 4)
% % %                                            [Navio,lista_descarregamento] = feval(Rc,Navio,conteiner,altura_max,lista_descarregamento,porto); %chamando a regra de carregamento no navio
% % %                                        else
% % %                                            [Navio,lista_descarregamento] = feval(Rc,Navio,conteiner,lista_descarregamento,porto); %chamando a regra de carregamento no navio                       
% % %                                        end
% % % 
% % %                                        mov_total = mov_total + 1; %Soma o custo da movimentacao total
% % % 
% % %                                        qtde_topo = qtde_topo + 1; %soma o contador de topo, para passar aqui de novo
% % % 
% % %                                     end
% % %                             end
% % %                       end  
% % %             end            
% % %           end          
% % %     end

end