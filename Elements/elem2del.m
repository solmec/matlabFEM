function [ elem_list, ais ] = elem2del( GPdatas, material, limit )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nelems =  size(GPdatas,2);
ais = zeros(nelems,1);

elem_list = [];

for i=1:nelems
    ais(i) = averageIntensity( GPdatas(i), material );
    if ( ais( i ) < limit ) 
        elem_list = [ elem_list; i ];
    end
end

end

