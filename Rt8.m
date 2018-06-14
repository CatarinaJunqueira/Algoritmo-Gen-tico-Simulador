% P=[0 0 0; 0 0 0; 0 0 0; 9 4 5; 7 3 8; 6 1 2];
function [move_counter,Navio] = Rt8(P,Navio,RegraCarregamento) %Heuristica LA-N Pettering e Hussein- 2013
%-------------------------------------------------------------%
% identificando a regra de carregamento que vai ser utilizada % 
Rc = strcat('Rc',int2str(RegraCarregamento));

if (RegraCarregamento == 2) || (RegraCarregamento == 4) % se a regra Rc é a Rc2 ou a Rc4
   [~,n]=size(Navio);
   altura_max = ceil((length(find(P~=0)) + length(find(Navio ~= 0)))/n);
end
%-------------------------------------------------------------%


 %Parametros do problema:
 
Mov_Limpeza=2; % numero permitido de movimentos de limpeza
N=max(max(P));
move_counter=0; % contador do numero de remanejamentos

o=unique(P)';
if o(1)==0
    o(1)=[];
end

for i=1:size(o,2)
    n=o(i); % n eh o numero do conteiner objetivo
    [row_n,col_n] = find(P==n); % linha e coluna onde está o contêiner objetivo y
    if ((row_n-1 == 0) || (P(row_n-1,col_n) == 0)) % se n está no topo ou se a posição acima é vazia.         
           
    else  
        %-----------------------------------------------------------------%
        %PRIMEIRO, VERIFICAR A POSSIBILIDADE DE FAZER MOVIMENTOS DE LIMPEZA
        [Linha,Stacks] = find(P==o(i+1)); %encontrando a coluna do proximo conteiner a ser retirado  
        if ((Linha-1 == 0) || (P(Linha-1,Stacks) == 0)) % se o proximo conteiner a ser retirado esta no topo da coluna dele. 
            %break % entao saia, nao havera movimentos de limpeza
        else % Se nao estiver no topo, entao continuar com as verificacoes           
            if Stacks ~= col_n % se o proximo conteiner a ser retirado nao estah na mesma coluna do conteiner n, 
               R = quem_acima_Heuristica_Caserta(P,o(i+1)); % Definindo a quantidade de blocos acima do proximo conteiner a ser retirado.
               if size(R,1)<Mov_Limpeza
                   Mov_Limpeza=size(R,1);               
               end
               for j=1:Mov_Limpeza % começando a movimentação dos blocos que devem ser remanejados.
                    r=R(j); % bloco a ser movido de acordo com a política LIFO.
                    [linha_r,coluna_r]=find(P==r);
                    prioridade=zeros(1,size(P,2));
                    for k=1:size(P,2) %Para k de 1 até o número de colunas.
                        TF=isempty(find(P(:,k)==0, 1));
                        if TF==0 && k~=col_n % só meço a prioridade das colunas não cheias e das colunas diferentes da coluna onde o bloco n está.
                            if k~=Stacks % e das colunas diferentes da coluna onde o proximo bloco.
                                X=P(:,k);    
                                x=min(X(X>0));
                                if  isempty(x) % se a coluna está vazia, min(i)=N+1
                                    prioridade(1,k)=N+1;
                                   % prioridade(2,k)=k;
                                else
                                    prioridade(1,k)=x; % valor do menor contêiner da coluna k
                                  %  prioridade(2,k)=k;
                                end
                            end
                        end
                    end
                    min_i=sort(prioridade); %ordenando as prioridades da menor para a maior
                    for h=1:size(prioridade,2)
                        if min_i(h)>r && min_i(h)~=0 % se satisfeita a condição, então colocar r nessa coluna não vai gerar nenhum movimento adicional.
                           [~,col] = find(prioridade==min_i(h));
                           col=col(1);
                           [P] = trocar_Heuristica_Caserta(P,col,r,linha_r,coluna_r); % Remanejar o conteiner Topo
                           move_counter=move_counter+1;
                           break
                        end 
                    end                   
               end
            end % --> if  Stacks ~= row_n        
        end
        %-----------------------------------------------------------------%
        %Terminados os movimentos de limpeza disponíveis, continuar com a
        %movimentacao do conteiner que deve sair
        R = quem_acima_Heuristica_Caserta(P,n); % Definindo a quantidade de blocos acima de o.
        for j=1:length(R) % começando a movimentação dos blocos que devem ser remanejados.
            r=R(j); % bloco a ser movido de acordo com a política LIFO.
            [linha_r,coluna_r]=find(P==r);
            % Para determinar onde r deve ser realocado, é feita uma medida de
            % atratividade de cada coluna
            prioridade=zeros(1,size(P,2));
            for k=1:size(P,2) %Para k de 1 até o número de colunas.
                TF=isempty(find(P(:,k)==0, 1));
                if TF==0 && k~=col_n % só meço a prioridade das colunas não cheias e das colunas diferentes da coluna onde o bloco n está.
                    X=P(:,k);    
                    x=min(X(X>0));
                    if  isempty(x) % se a coluna está vazia, min(i)=N+1
                        prioridade(1,k)=N+1;
                       % prioridade(2,k)=k;
                    else
                        prioridade(1,k)=x; % valor do menor contêiner da coluna k
                      %  prioridade(2,k)=k;
                    end
                end
            end
            min_i=sort(prioridade);
            max_i=max(prioridade);
            for h=1:size(prioridade,2)
                %min_i=min(prioridade(prioridade>0));
                if min_i(h)>r && min_i(h)~=0 % se satisfeita a condição, então colocar r nessa coluna não vai gerar nenhum movimento adicional.
                   [~,col] = find(prioridade==min_i(h));
                   col=col(1);
                   [P] = trocar_Heuristica_Caserta(P,col,r,linha_r,coluna_r); % Remanejar r
                   move_counter=move_counter+1;
                   break
                end 
            end
            % caso em que nenhuma das prioridades eh maior do que r. Escolher a menos pior. 
            [~,col]=find(P==r);                
             if col==col_n %Quero saber se o conteiner r (que deve ser remanejado) ainda estah em cima de n (que deve sair)
                [~,col] = find(prioridade==max_i);
                col=col(1);
                [P] = trocar_Heuristica_Caserta(P,col,r,linha_r,coluna_r); % Remanejar r
                move_counter=move_counter+1;
             end
        end     
    end   
    P(row_n,col_n)=0; % Tira do patio
    if (RegraCarregamento == 2) || (RegraCarregamento == 4) % Carrega no navio
       [Navio] = feval(Rc,Navio,n,altura_max); %chamando a regra de carregamento no navio
    else
      [Navio] = feval(Rc,Navio,n); %chamando a regra de carregamento no navio                       
    end
uu=unique(P);
a=size(uu,1);
if a==1 
    if uu==0 % se o patio esta zerado, entao sair
       break
    end
end

end

end


















































































function [move_counter,Navio] = Rt7(P,Navio,RegraCarregamento) %Heuristica Caserta 2012
%-------------------------------------------------------------%
% identificando a regra de carregamento que vai ser utilizada % 
Rc = strcat('Rc',int2str(RegraCarregamento));

if (RegraCarregamento == 2) || (RegraCarregamento == 4) % se a regra Rc é a Rc2 ou a Rc4
   [~,n]=size(Navio);
   altura_max = ceil((length(find(P~=0)) + length(find(Navio ~= 0)))/n);
end
%-------------------------------------------------------------%

N=max(max(P));
move_counter=0;
n=0;

o=unique(P)';
if o(1)==0
    o(1)=[];
end

    for y=o
        n=n+1;
        [row_n,col_n] = find(P==y); % linha e coluna onde está o contêiner objetivo y
       if ((row_n-1 == 0) || (P(row_n-1,col_n) == 0)) % se y está no topo ou se a posição acima é vazia.         
           
       else
            R = quem_acima_Heuristica_Caserta(P,y); % Definindo a quantidade de blocos acima de n.
            for j=1:length(R) % começando a movimentação dos blocos que devem ser remanejados.
                r=R(j); % bloco a ser movido de acordo com a política LIFO.
                [linha_r,coluna_r]=find(P==r);
                % Para determinar onde r deve ser realocado, é feita uma medida de
                % atratividade de cada coluna
                prioridade=zeros(1,size(P,2));
                for k=1:size(P,2) %Para k de 1 até o número de colunas.
                    TF=isempty(find(P(:,k)==0, 1));
                    if TF==0 && k~=col_n % só meço a prioridade das colunas não cheias e das colunas diferentes da coluna onde o bloco n está.
                        X=P(:,k);    
                        x=min(X(X>0));
                        if  isempty(x) % se a coluna está vazia, min(i)=N+1
                            prioridade(1,k)=N+1;
                           % prioridade(2,k)=k;
                        else
                            prioridade(1,k)=x; % valor do menor contêiner da coluna k
                          %  prioridade(2,k)=k;
                        end
                    end
                end
                min_i=sort(prioridade);
                max_i=max(prioridade);
                for h=1:size(prioridade,2)
                    %min_i=min(prioridade(prioridade>0));
                    if min_i(h)>r && min_i(h)~=0 % se satisfeita a condição, então colocar r nessa coluna não vai gerar nenhum movimento adicional.
                       [~,col] = find(prioridade==min_i(h));
                       col=col(1);
                       [P] = trocar_Heuristica_Caserta(P,col,r,linha_r,coluna_r); % Remanejar r
                       move_counter=move_counter+1;
                       break
                    end 
                end
                % caso em que nenhuma das prioridades eh maior do que r. Escolher a menos pior. 
                [~,col]=find(P==r);                
                 if col==col_n %Quero saber se o conteiner r (que deve ser remanejado) ainda estah em cima de n (que deve sair)
                    [~,col] = find(prioridade==max_i);
                    col=col(1);
                    [P] = trocar_Heuristica_Caserta(P,col,r,linha_r,coluna_r); % Remanejar r
                    move_counter=move_counter+1;
                 end
            end   
        end
        % Depois de realocar todos os contêineres que estavam acima do
        % contêiner n, n pode ser retirado.
           P(row_n,col_n)=0; % Tira do patio
           if (RegraCarregamento == 2) || (RegraCarregamento == 4) % Carrega no navio
               [Navio] = feval(Rc,Navio,y,altura_max); %chamando a regra de carregamento no navio
           else
               [Navio] = feval(Rc,Navio,y); %chamando a regra de carregamento no navio                       
           end
uu=unique(P);
a=size(uu,1);
if a==1 
    if uu==0 % se o patio esta zerado, entao sair
       break
    end
end
          
    end
end