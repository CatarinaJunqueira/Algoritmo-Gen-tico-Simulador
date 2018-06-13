%----------------------------------------------------%
%----------------------------------------------------%
% Elaboração da Regra R3 de Carregamento.            %
%----------------------------------------------------%
%----------------------------------------------------%
% Procedimento de preenchimento:                     %
%----------------------------------------------------%
%  (1) Esta regra é o espelho da regra Rc1. No porto p,
%  a matriz de ocupação B será preenchida por linha, da
%  direita para a esquerda, colocando na parte inferior
%  da linha, as cargas cujo destino é mais distante.  
%      m ^
%        |6 5 4 
%        |3 2 1
%      1 -----> 
%        1    n
%
%  (2) Coloca um contêiner de cada vez, conforme
%      eles vão sendo retirados do pátio.
%
%  (3) Retorna a matrix que representa o navio, preenchida
%      de acordo com a regra de carregamento Rc3.
%----------------------------------------------------%
function [Navio] = Rc3(Navio,conteiner) 

[linha,coluna]=size(Navio);

if  length(find(Navio(1,:)~=0)) == coluna     
    msg = 'Problema na função Rc3 !! Não foi possível carregar todos os containeres!! Espaco insufiente !! \n ';
    error(msg)
end

% Ordem que vai percorrer
    for i = (linha:-1:1) %corrigindo a ordem de verificação.
         for k = (coluna:-1:1)   
             if Navio(i,k) == 0
                Navio(i,k) = conteiner; 
%                      for u=1:length(lista_descarregamento)
%                          if lista_descarregamento(u)==0
%                              lista_descarregamento(u,1)=conteiner;
%                              [~,col]=find(porto(2,:)==conteiner);
%                              lista_descarregamento(u,2)=porto(1,col);
%                            %  lista_descarregamento(u,3)=i;
%                            %  lista_descarregamento(u,4)=k;
%                              break
%                          end
%                      end
                conteiner=0;
                break
             end
         end
         if conteiner == 0
            break
         end
    end
 
end

