function [mov_total,Navio] = mover_Novo_Genetico_Descarregamento(patio,l_navio,vzio,RegraCarregamento,Navio)

%-------------------------------------------------------------%
% identificando a regra de carregamento que vai ser utilizada % 
Rc = strcat('Rc',int2str(RegraCarregamento));

if (RegraCarregamento == 2) || (RegraCarregamento == 4) % se a regra Rc é a Rc2 ou a Rc4
   [~,n]=size(Navio);
   altura_max = ceil((length(l_navio) + length(find(Navio ~= 0)))/n);
end
%-------------------------------------------------------------%

mov_total = 0;  %gerando dados iniciais 
%u=isempty(l_navio);
u=0;

  while u~=1
       [bool] = topo(patio,l_navio(1,:)); % verifica se eh topo ou nao
       %------------------------------------------------------------------%
       % Primeiro verifica-se se existem contêineres que estão na lista l_navio que estão no topo de suas colunas e podem ser retirados sem remanejamento 
       if (bool == 1) % Está no topo(1), ou seja, não é necessário mais que uma movimentacao de conteiner
           conteiner=l_navio(1,:);
           conteiner=patio(conteiner(1),conteiner(2));
           [patio] = remover(patio,l_navio(1,:)); %tira do patio
           
           if (RegraCarregamento == 2) || (RegraCarregamento == 4) % Carrega no navio
               [Navio] = feval(Rc,Navio,conteiner,altura_max); %chamando a regra de carregamento no navio
           else
               [Navio] = feval(Rc,Navio,conteiner); %chamando a regra de carregamento no navio                       
           end

       else

       acima = quem_acima(patio,l_navio(1,:));  % Se o contêiner não é topo, então vejo quem está acima dele
       contador=1;

        for k = (1:size(acima,1)) % de 1 até quantidade de conteineres que devem ser remanejados
                                  % Começo a remanejar os
                                  % contêineres que estão acima do
                                  % target contêiner
            if (acima(contador)~=0)
                    [vazio] = feval(vzio,patio,l_navio(1,:)); % Encontro as posições vazias para as quais eu posso colocar os contêineres de remanejamento
                    [patio] = trocar(patio,acima(contador,:),vazio(1,:)); % troque por essa posição do vazio - remaneje.                                                                                        
                    mov_total = mov_total + 1; %Soma o custo da movimentacao total ( custo de remanejamento)
                    acima(contador,:)=0; %transforma o valor em 0, indica que ja foi visto
                    contador=contador+1;                                        

                if sum(sum(acima))==0
                    break  % quando já não houverem contêineres para serem remanejados, saia.
                end

            end                            
        end
          % Termina de mover quem estava acima
          %---------------------------------------%
          % Agora pode retirar o conteiner objetivo

        conteiner=l_navio(1,:);
        conteiner=patio(conteiner(1),conteiner(2));
        [patio] = remover(patio,l_navio(1,:)); %tira do patio
           if (RegraCarregamento == 2) || (RegraCarregamento == 4) % Carrega no navio
               [Navio] = feval(Rc,Navio,conteiner,altura_max); %chamando a regra de carregamento no navio
           else
               [Navio] = feval(Rc,Navio,conteiner); %chamando a regra de carregamento no navio                       
           end
       end
       
uu=unique(patio);
a=size(uu,1);
if a==1 
    if uu==0 % se o patio esta zerado, entao sair
       u=1;
       break
    end
end
    [l_navio] = encontraCasertaDescarregamento(patio);
    %u=isempty(l_navio);
  end
end