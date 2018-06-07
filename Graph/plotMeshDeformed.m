function [ scale ] =  plotMeshDeformed( nodes, elems, q )

clf
plot( nodes(:,1), nodes(:,2), '.'), axis off, hold on
%for i=1:size(nodes,1), text( nodes( i,1 ), nodes(i,2) , num2str(i) ); end
for i =1:size(elems,1) 
        fill( ...
            [nodes(elems(i,1),1), nodes(elems(i,2),1), nodes(elems(i,3),1), nodes(elems(i,4),1), nodes(elems(i,1),1)],...
            [nodes(elems(i,1),2), nodes(elems(i,2),2), nodes(elems(i,3),2), nodes(elems(i,4),2), nodes(elems(i,1),2)],...
            'b:'), 
end



% static deform
if ( size(q,1) ~= 0  ) 
    qmax = max( abs( q ) );
    scale = 15 / qmax;
    deform = nodes + scale * [ q( 1:2:end ) q( 2:2:end ) ];
else
    return
end


for i =1:size(elems,1) 
        plot( ...
            [deform(elems(i,1),1), deform(elems(i,2),1), deform(elems(i,3),1), deform(elems(i,4),1), deform(elems(i,1),1)],...
            [deform(elems(i,1),2), deform(elems(i,2),2), deform(elems(i,3),2), deform(elems(i,4),2), deform(elems(i,1),2)],...
            'b'), 
end
axis image, axis off

end

