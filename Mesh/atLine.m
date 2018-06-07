function [ fixed_dofs ] = atLine( nodes, coord, cval, fdofs  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

dim=size(fdofs,2);
fixed_dofs = [];
for i=1:size(nodes,1)
    if ( abs(nodes(i,coord) - cval) < 1e-6 )
        for j=1:dim
            if ( fdofs( j ) == 1 ) 
              fixed_dofs = [ fixed_dofs dim*i-dim+j ];
            end
        end
    end
end
end

