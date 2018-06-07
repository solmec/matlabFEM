function [ elem_list, ais ] = elem2delGround( nodes, elems, nx, ny, GPdatas, material, limit )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nelems =  size(GPdatas,2);
ais    = zeros(nelems,1);
ais2   = zeros(nx/2*ny/2,1);

elem_list = [];

for i=1:nelems
    ais(i) = averageIntensity( GPdatas(i), material );
end

minav = 2;

for i=1:nx/2
    for j=1:ny/2
        ielem1 = 2 * i - 1 + nx * ( 2 * j - 1 - 1 );
        ielem2 = 2 * i - 0 + nx * ( 2 * j - 1 - 1 );
        ielem3 = 2 * i - 0 + nx * ( 2 * j - 0 - 1 );
        ielem4 = 2 * i - 1 + nx * ( 2 * j - 0 - 1 );
    end
    av = ( ais(ielem1) + ais(ielem2) + ais(ielem3) + ais(ielem4) ) / 4;
    if ( av < minav ) 
        elem_list = [ ielem1 ielem2 ielem3 ielem4 ];
    end
end

end


