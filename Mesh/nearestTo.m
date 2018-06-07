function [ fixed_dofs ] = nearestTo( nodes, pt, fdofs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

dim=size(fdofs,2);
nn = closestNode(nodes, pt);
fixed_dofs = [];
for i=1:dim
    if ( fdofs( i ) == 1 ) 
        fixed_dofs = [ fixed_dofs dim * nn-dim+i ];
    end
end
end

