function  plotMeshPlastic( nodes, elems, q, elemClass, GPdatas )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


if ( size(q,1) ~= 0  ) 
    scale = plotMeshDeformed( nodes, elems, q );
    deform = nodes + scale * [ q( 1:2:end ) q( 2:2:end ) ];
    ngp   = size(elemClass.gp,2);
    for i=1:size(elems,1)
        enodes = deform( elems(i,:), :);
        for j =1:ngp
            if (  GPdatas(i).dg(j) > 0 )
                N = elemClass.sf( elemClass.gp(:,j) );
                plot( sum( N(:) .* enodes(:,1)) , sum( N(:).*enodes(:,2) ),'r.');
            end
        end
    end
%    plot( deform(:,1), deform(:,2), 'g.');
else
    ngp   = size(elemClass.gp,2);
    for i=1:size(elems,1)
        enodes = nodes( elems(i,:), :);
        for j =1:ngp
            if (  GPdatas(i).dg(j) > 0 )
                N = elemClass.sf( elemClass.gp(:,j) );
                plot( sum( N(:) .* enodes(:,1)) , sum( N(:).*enodes(:,2) ),'r.');
            end
        end
    end
 %   plot( nodes(:,1), nodes(:,2), 'g.');
end
end

