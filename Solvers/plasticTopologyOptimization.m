function [ xret ] = plasticTopologyOptimization( taskname, nodes, elems, elemClass, P, material, profile, supports, x, lx, ly, nx, ny, fpen, rmin, nRemoved, maxais )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

V0 = lx * ly * profile.h;

erased_elems = false( size(elems,1), 1 );


% solving elastoplastic problem
%[ ~, ~, c ] = planeStressPlasticAnalysisCapacity( elemClass, nodes, elems, P, material, profile, supports, x )
c = 1;

iter = 0;
fig = figure;
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
    plotMap('top',iter,x,nx,ny,V,V0,nRemoved,fpen,rmin);
    saveas( gcf,[ taskname, '_top.png'] );
    savefig([taskname '_top']);
    figure;
    plotMap('stress',iter,ais,nx,ny,V,V0,nRemoved,fpen,rmin);
    saveas( gcf,[ taskname, '_stress.png'] );
    savefig([taskname '_stress']);
    er_elems = 1:size(elems,1);
    er_elems( erased_elems ) = [];
    [ enodes, eelems, nodes_list ] = eraseElems( nodes, elems, elem_list );
    
    disp(['Analysis finished correctly.' ]);
  
    save( taskname );
  
    xret = x;
    return
    
else
    
    xPrev       = x;
    erasedPrev  = erased_elems;
    GPdatasPrev = GPdatas;
    
end

[ elem_list, erased_elems, ais ] = elem2del3( nx, ny, erased_elems, GPdatas, material, nRemoved, x, rmin );
x( elem_list ) = max( 0.01*profile.h, x( elem_list ).*ais( elem_list ).^fpen); % 1.5 is perfect!!!!
V = lx*ly*profile.h*sum(x)/nx/ny;
%x( erased_elems ) = 0.01*profile.h;

plotMap('top',iter,x,nx,ny,V,V0,nRemoved,fpen,rmin);

%saveas(gcf,['plasticBeam2_', num2str(iter),'.png'] );


pause(1e-6);

end

