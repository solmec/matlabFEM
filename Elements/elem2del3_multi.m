function [ elem_list, erased_elems, ais ] = elem2del3_multi( nx, ny, erased_elems, GPdatas, material, limit, x, rmin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nelems =  size(GPdatas,2);
ais = zeros(nelems,1);

elem_list = [];

for i=1:nelems
    ncase = size( GPdatas, 1 );
    ais_lc = zeros(ncase,1);
    for j=1:ncase
        ais_lc(j) = averageIntensity( GPdatas(j,i), material );
    end
    ais(i) = max(ais_lc);
end

%am = ais;


%am = designFilter( nodes, elems, rmin, ais, x );

%am = designFilter( nx, ny, rmin, reshape(x, nx, ny)', reshape(ais, nx, ny)');
%am = reshape(am', nx*ny,1);

am = designFilter( nx, ny, rmin, reshape(x, nx, ny)', reshape(ais, nx, ny)');
am = reshape(am', nx*ny,1);
 
% ix=1;
% while( size( elem_list, 1 ) < limit )
%     if ( erased_elems( ix ) == false ) 
%         [ ~, ix ] = min( am );
%         elem_list = [ elem_list ix ];
%         erased_elems( ix ) = true;
%     end
%     ix = ix + 1;
% end
% end


notErasedID = find( not( erased_elems));
[sortVal, sortID] = sort( am( notErasedID));
elem_list = notErasedID( sortID( 1:limit));
erased_elems( elem_list) = true;
