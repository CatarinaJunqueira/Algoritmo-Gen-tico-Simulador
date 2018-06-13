% Nome: Regra de Descarregamento 2 - Rd2 

%---------------------------------------------------------------------%
%              Regra de Descarregamento do Navio (Rd2)                %
%---------------------------------------------------------------------%
% Retira todos os contêineres do Navio para carregá-los posteriormente
% usando alguma regra de carregamento.

function [MovGeral, Navio] = Rd2(Navio,NPorto,porto,RegraRetirada,RegraCarregamento)

y=length(find(Navio~=0)); % quantidade total de conteineres no navio
kk=length(find(porto(1,:)==NPorto)); %quantidade de conteineres que tem como destino o porto atual
MovGeral=y-kk; %quantidade de conteineres remanejados
patio_transb=zeros(ceil(sqrt(abs(y-kk)*0.8)),ceil(sqrt(abs(y-kk))*2)); % área reservada para os contêineres de transbordo

[linha,coluna]=size(Navio);
for i=1:linha
    for j=1:coluna
        if Navio(i,j)~=0 % se a posição é diferente de zero
           [row]=find(porto(2,:)==Navio(i,j));            
            if porto(1,row)== NPorto % se este eh o destino final do conteiner
               Navio(i,j)=0; % entao retira do navio
            else % se o contêiner não vai ficar no porto em que o navio está
                 % retira e coloca na área de transbordo para depois colocar
                 % de volta no navio
               [patio_transb] = Rc_Imp(patio_transb,Navio(i,j)); 
               Navio(i,j)=0;
            end
        end
    end   
end
    
% Terminado o descarregamento
%-------------------------------------------------------------------------%
% Agora é necessário carregar de volta os contêineres que foram
% descarregados, mas que não tinham como destino final este porto.
 if RegraRetirada ~= 7
    [MovGeralTransbordo,Navio] = Rt_descarregamento(patio_transb,RegraRetirada,Navio,RegraCarregamento);
    MovGeral=MovGeral+MovGeralTransbordo; 
else
    [MovGeralTransbordo,Navio] = Rt7(patio_transb,Navio,RegraCarregamento);
    MovGeral=MovGeral+MovGeralTransbordo; 
 end

end