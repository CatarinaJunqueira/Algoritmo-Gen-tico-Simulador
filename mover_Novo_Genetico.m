function [mov_total,Navio] = mover_Novo_Genetico(patio,l_navio,vzio,RegraCarregamento,Navio)

%-------------------------------------------------------------%
% identificando a regra de carregamento que vai ser utilizada % 
Rc = strcat('Rc',int2str(RegraCarregamento));

if (RegraCarregamento == 2) || (RegraCarregamento == 4) % se a regra Rc � a Rc2 ou a Rc4
   [~,n]=size(Navio);
   altura_max = ceil((length(l_navio) + length(find(Navio ~= 0)))/n);
end
%-------------------------------------------------------------%

%N=max(max(patio));
%mov_P=cell(1,N);
%mov_P=1;
% pp=cell(1,nnz(patio)+1);
% pp{1,1}=patio;
mov_total = 0;  %gerando dados iniciais 
u=isempty(l_navio);
n=1;
  while u~=1
     %for n_cont = (1:qtd_cont);   
     %if (l_navio(n_cont) ~= 0)
     %  mov_P{n}=patio; --> descomentar!!!
       n=n+1;
       [bool] = topo(patio,l_navio(1,:)); % verifica se eh topo ou nao
       %------------------------------------------------------------------%
       % Primeiro verifica-se se existem cont�ineres que est�o na lista l_navio que est�o no topo de suas colunas e podem ser retirados sem remanejamento 
       if (bool == 1) % Est� no topo(1), ou seja, n�o � necess�rio mais que uma movimentacao de conteiner
           conteiner=l_navio(1,:);
           conteiner=patio(conteiner(1),conteiner(2));
           [patio] = remover(patio,l_navio(1,:)); %tira do patio
           
           if (RegraCarregamento == 2) || (RegraCarregamento == 4) % Carrega no navio
               [Navio] = feval(Rc,Navio,conteiner,altura_max); %chamando a regra de carregamento no navio
           else
               [Navio] = feval(Rc,Navio,conteiner); %chamando a regra de carregamento no navio                       
           end

       else

       acima = quem_acima(patio,l_navio(1,:));  % Se o cont�iner n�o � topo, ent�o vejo quem est� acima dele
       contador=1;

        for k = (1:size(acima,1)) % de 1 at� quantidade de conteineres que devem ser remanejados
                                  % Come�o a remanejar os
                                  % cont�ineres que est�o acima do
                                  % target cont�iner
            if (acima(contador)~=0)
                    [vazio] = feval(vzio,patio,l_navio(1,:)); % Encontro as posi��es vazias para as quais eu posso colocar os cont�ineres de remanejamento
                    [patio] = trocar(patio,acima(contador,:),vazio(1,:)); % troque por essa posi��o do vazio - remaneje.                                                                                        
                    mov_total = mov_total + 1; %Soma o custo da movimentacao total ( custo de remanejamento)
                    acima(contador,:)=0; %transforma o valor em 0, indica que ja foi visto
                    contador=contador+1;                                        

                if sum(sum(acima))==0
                    break  % quando j� n�o houverem cont�ineres para serem remanejados, saia.
                end

            end                            
        end
          % Termina de mover quem estava acima
          %---------------------------------------%
          % Agora pode retirar o conteiner objetivo
      %  pp{1,patio(l_navio(1,1),l_navio(1,2))+1}=patio;
        conteiner=l_navio(1,:);
        conteiner=patio(conteiner(1),conteiner(2));
        [patio] = remover(patio,l_navio(1,:)); %tira do patio
       % mov_total = mov_total + 1; %Soma o custo da movimentacao total
       % l_navio(n_cont,:)=0; %transforma o valor em 0, indica que ja foi visto
           if (RegraCarregamento == 2) || (RegraCarregamento == 4) % Carrega no navio
               [Navio] = feval(Rc,Navio,conteiner,altura_max); %chamando a regra de carregamento no navio
           else
               [Navio] = feval(Rc,Navio,conteiner); %chamando a regra de carregamento no navio                       
           end
       end
   % end
   %  end
    [l_navio] = encontraCaserta(patio);
    u=isempty(l_navio);
  end
end