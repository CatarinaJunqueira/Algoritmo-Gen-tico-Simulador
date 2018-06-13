%
% Nome: quem_acima
% Objetivo: gerar lista de quem esta acima do conteiner, para remanejamento
%
function acima = quem_acima(patio, posicao_navio) %Quem está acima que não é vazio.

linha = posicao_navio(1,1); %posição 
coluna = posicao_navio(1,2);
c_lista = 1;  %começo na posição 1.
b=sum(patio(:,coluna) ~= 0);
acima=zeros(b-1,2);

    for a_cont = (1:linha-1) 
       
        if (patio(a_cont,coluna) ~= 0)  %verificando se tem espaco vazio na altura
           acima(c_lista,1) = a_cont;
           acima(c_lista,2) = coluna;
           c_lista = c_lista + 1;  % Depois que insiro na posição 1, passo p/ a próxima. Mover na lista.
        end
    end
    T=acima(:,1);
    [row]=find(T==0);
    acima(row,:)=[];
    
end
                
  