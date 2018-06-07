function [ nodes, elems, nodes_list ] = eraseElems( nd, el, elem_list )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

nnodes = size( nd, 1 );
elems  = el;
elems( elem_list, : ) = [];
dim   = size( elems, 2 );
todel = false( nnodes, 1 );
nelems = size( elems, 1);

for i=1:dim
    todel( elems(:,i) ) = true;
end

nnum = zeros(nnodes,1);
counter = 1;
nodes_list = [];

for i=1:nnodes
    if ( todel( i ) == false )
        nodes_list = [nodes_list i];
    else        
        nnum(i) = counter;
        counter = counter+1;
    end
end

for i=1:nelems
    for j=1:dim
        elems(i,j) = nnum( elems(i,j) );
    end
end

nodes = nd;
nodes( nodes_list, : ) = [];

end

