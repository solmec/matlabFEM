function [ elem_list, ais ] = elem2del2( nodes, elems, GPdatas, material, limit )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nelems =  size(GPdatas,2);
ais = zeros(nelems,1);

elem_list = [];

for i=1:nelems
    ais(i) = averageIntensity( GPdatas(i), material );
end

am = ais;
rmin = 4;
am = designFilter( nodes, elems, rmin, ais );
for i=1:limit
    [ ~, ix ] = min( am );
    elem_list = [ elem_list ix ];
    am( ix ) = [];
end

end

