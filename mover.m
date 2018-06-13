
function [mov_total,patio,Distancia] = mover(patio,l_navio,porto,vzio)

Distancia=0;
qtd_cont = length(l_navio); %quantidade de contêineres que vão sair
mov_total = 0;  %gerando dados iniciais
qtde_topo = 1;
%--------------------------------------------------------------------------------------------------------------%
id_porto = unique(porto); % Criando um D inicial com valores 0. Tamanho dele é = ao número de portos percorridos
t=length(id_porto);
t2=id_porto(t);
D=zeros(1,t2);
%--------------------------------------------------------------------------------------------------------------%

%----------------------------------------------------------------------------------------------------------------------------------------------%
% Primeiro verifica-se se existem contêineres que estão na lista l_navio que estão no topo de suas filas e podem ser retirados sem remanejamento 

     while (qtde_topo > 0)  % Enquanto ainda existirem contêineres no pátio que são topo
         qtde_topo = 0; % Condição de parada: topo = 0         
         
          for n_cont = (1:qtd_cont)   
                if (l_navio(n_cont) ~= 0)
                    [bool] = topo(patio,l_navio(n_cont,:)); % verifica se eh topo ou nao
                    
                        if (bool == 1) % Está no topo(1), ou seja, não é necessário mais que uma movimentacao de conteiner
                            
                           mov_total = mov_total + 1; %Soma o custo da movimentacao total
                            
                           [D] = inserirD(D,patio,l_navio(n_cont,:),porto); %inserir no Dnavio o porto de destino daquele contêiner
                            
                           [patio] = remover(patio,l_navio(n_cont,:)); %tira do patio
                                                                                
                           qtde_topo = qtde_topo + 1; %soma o contador de topo, para passar aqui de novo
                            
                           l_navio(n_cont,:)=0; %transforma o valor em 0, indica que ja foi visto

                        end
                end
               
          end 
                           
     end
% Final da verificação de contêineres 'topos'
%----------------------------------------------------------------------------------------------------------------------------------------------%

%----------------------------------------------------------------------------------------------------------------------------------------------%
%Casos que nao estao no topo.
for i = 1:length(l_navio)
    if (l_navio(i)~=0)
        [vazio] = feval(vzio,patio,l_navio(i,:)); %retorna uma lista das posições vazias
        break
    end
    
end


    for n_cont = (1:qtd_cont)

          if (l_navio(n_cont)~=0) % Se a lista de navio na posição indicada não for 0,

            acima = quem_acima(patio,l_navio(n_cont,:)); %vejo quem está acima dessa posição
            qtde_troca = 1;
            trocas =0;

            while(qtde_troca > 0)
                qtde_troca = 0; %Condicao de parada
                max_acima = size(acima,1);

                    if (trocas == max_acima) 
                        break
                    else
                        trocas = trocas +1;
                    end

                       tam_vazio = size(vazio,1); %quantidade de posições vazias
                       contador=1;
                      
                        for k = (1:tam_vazio) % de 1 até quantidade de posições vazias
                           
                            if (acima(contador)~=0)
                               [vazio] = feval(vzio,patio,l_navio(n_cont,:)); %atualiza a lista de vazios
                               [patio] = trocar(patio,acima(contador,:),vazio(1,:)); % troque por essa posição do vazio.                                                                                        
                               mov_total = mov_total + 1; %Soma o custo da movimentacao total
                               [distancia] = dist(acima(contador,2),vazio(1,2));
                               Distancia=Distancia+distancia;
                               acima(contador,:)=0; %transforma o valor em 0, indica que ja foi visto
                               contador=contador+1;                                        
 
                                if sum(sum(acima))==0
                                    break
                                end
                                
                            end                            
                        end
% Termina de mover quem estava acima
%----------------------------------------------------------------------------------------------------------------------------------------------%
% Agora pode retirar o conteiner objetivo  
                       mov_total = mov_total + 1; %Soma o custo da movimentacao total

                       [D] = inserirD(D,patio,l_navio(n_cont,:),porto); %inserir no Dnavio o porto de destino daquele contêiner

                       [patio] = remover(patio,l_navio(n_cont,:)); %tira do patio
                       
                       l_navio(n_cont,:)=0; %transforma o valor em 0, indica que ja foi visto
 
                     for j_cont = (1:qtd_cont)   % verifica se alguém virou topo 
                            if (l_navio(j_cont) ~= 0)
                                [bool] = topo(patio,l_navio(j_cont,:)); % verifica se eh topo ou nao

                                    if (bool == 1) % Está no topo(1), ou seja, não é necessário mais que uma movimentacao de conteiner

                                       mov_total = mov_total + 1; %Soma o custo da movimentacao total

                                       [D] = inserirD(D,patio,l_navio(j_cont,:),porto); %inserir no Dnavio o porto de destino daquele contêiner

                                       [patio] = remover(patio,l_navio(j_cont,:)); %tira do patio

                                       qtde_topo = qtde_topo + 1; %soma o contador de topo, para passar aqui de novo

                                       l_navio(j_cont,:)=0; %transforma o valor em 0, indica que ja foi visto

                                    end
                            end

                      end 
 
            end            
          end          
    end
end