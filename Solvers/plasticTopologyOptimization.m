function [ xret ] = plasticTopologyOptimization( taskname, nodes, elems, elemClass, P, material, profile, supports, x, lx, ly, nx, ny )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nRemoved = 20;
erased_elems = false( size(elems,1), 1 );


% solving elastoplastic problem
%[ ~, ~, c ] = planeStressPlasticAnalysisCapacity( elemClass, nodes, elems, P, material, profile, supports, x )
c = 1;

iter = 0;
fig = figure;

penf = 2.0;

while true

    iter = iter+1;
    
    [ u, GPdatas, corr ] = incrementalPlaneStressPlasticAnalysis( elemClass, nodes, elems, P, material, profile, supports, x );

%figure, plotMeshPlastic( nodes, elems, u, elemClassL4, GPdatas );
%title(['Iter: ', num2str(iter),', Load capacity: ', num2str(c) ]);

%return;

if ( corr == false )
    
    x            = xPrev;
    erased_elems = erasedPrev;
    GPdatas      = GPdatasPrev;
    
    V = lx*ly*profile.h*sum(x)/nx/ny;
    colormap(gray), imagesc( flipud(-reshape(x,nx,ny)')), axis image, axis tight, axis off
    title(['Iter: ', num2str(iter),', nr: ', num2str(nRemoved),', Volume: ' num2str(V), ' m^3']);

    
    disp(['Analysis finished correctly.' ]);
    saveas( gcf,[ taskname, '.png'] );
    save( taskname );
    savefig(taskname);
    xret = x;
    return
    
else
    
    xPrev       = x;
    erasedPrev  = erased_elems;
    GPdatasPrev = GPdatas;
    
end


[ elem_list, erased_elems, ais ] = elem2del3( nx, ny, erased_elems, GPdatas, material, nRemoved, x );

x( elem_list ) = max( 0.01*profile.h, x( elem_list ).*ais( elem_list).^penf); % 1.5 is perfect!!!!
V = lx*ly*profile.h*sum(x)/nx/ny;

colormap(gray), imagesc( flipud(-reshape(x,nx,ny)')), axis image, axis tight, axis off
title(['Iter: ', num2str(iter),', nr: ', num2str(nRemoved),', Volume: ' num2str(V), ' m^3']);

%saveas(gcf,['plasticBeam2_', num2str(iter),'.png'] );


pause(1e-6);

end

