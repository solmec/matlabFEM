function [ scale ] =  plotMesh( nodes, elems )

clf
plot( nodes(:,1), nodes(:,2), '.'), axis off, hold on
%for i=1:size(nodes,1), text( nodes( i,1 ), nodes(i,2) , num2str(i) ); end
for i =1:size(elems,1) 
        fill( ...
            [nodes(elems(i,1),1), nodes(elems(i,2),1), nodes(elems(i,3),1), nodes(elems(i,4),1), nodes(elems(i,1),1)],...
            [nodes(elems(i,1),2), nodes(elems(i,2),2), nodes(elems(i,3),2), nodes(elems(i,4),2), nodes(elems(i,1),2)],...
            'b:'), 
end

axis image, axis off

end

