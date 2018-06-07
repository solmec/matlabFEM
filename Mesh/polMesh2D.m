function [ nodes_pol, elems ] = polMesh2D( nx, ny, xs, ys, x0, y0, dx, dy, pattern )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[ nodes, elems ] = rectMesh2D( nx, ny, x0, y0, dx, dy, pattern );

nodes_pol = nodes;
nnodes    = size(nodes,1);

nodes_pol(1:nnodes,1)=xs+nodes(1:nnodes,1).*sin(nodes(1:nnodes,2));
nodes_pol(1:nnodes,2)=ys+nodes(1:nnodes,1).*cos(nodes(1:nnodes,2));


end

