function [ xtop, cm ] = plasticTopologyOptimizationMulti( taskname, nodes, elems, elemClass, mP, material, profile, supports, x, lx, ly, nx, ny, lf, fpen, rmin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nelems = size( elems, 1 );
nlcases = size(mP,2);

nRemoved = 20;
erased_elems = false( size(elems,1), 1 );

 GPdataClass.stress  = zeros( 3, 4 );
 GPdataClass.strain  = zeros( 3, 4 );
 GPdataClass.strainp = zeros( 3, 4 );
 GPdataClass.dg      = zeros( 1, 4 );

GPdatas(1:nlcases,1:nelems) = GPdataClass;

c = zeros(1,nlcases);
% solving elastoplastic problem
parfor k=1:nlcases
    [ ~, GPdatas(k,:), c(k) ] = planeStressPlasticAnalysisCapacity( elemClass, nodes, elems, mP(:,k), material, profile, supports, x );
end

cm = min(c);

iter = 0;
       
corr = false(1,nlcases);

while true

    iter = iter+1;

    parfor k=1:nlcases
        [ ~, GPdatas(k,:), corr(k) ] = incrementalPlaneStressPlasticAnalysis( elemClass, nodes, elems, lf * cm * mP(:,k), material, profile, supports, x );
    end
 
    for k=1:nlcases
        if ( corr(k) == false )
            x            = xPrev;
            erased_elems = erasedPrev;
            GPdatas      = GPdatasPrev;
            V = lx*ly*profile.h*sum(x)/nx/ny;
            plotMap('top,'iter,x,nx,ny,V,V0,nRemoved,fpen,rmin);
            plotMap('stress',iter,x,nx,ny,V,V0,nRemoved,fpen,rmin);
            disp(['Analysis finished correctly.' ]);
            saveas( gcf,[ taskname, '.png'] );
            save( taskname );
            savefig(taskname);
            xtop=x;
            return;
        end

    end
    
xPrev       = x;
erasedPrev  = erased_elems;
GPdatasPrev = GPdatas;



[ elem_list, erased_elems, ais ] = elem2del3_multi( nx, ny, erased_elems, GPdatas, material, nRemoved, x, rmin );


x( elem_list ) = max( 0.01*profile.h, x( elem_list ).*ais( elem_list).^fpen); % 1.5 is perfect!!!!
x( erased_elems ) = 0.01*profile.h;
V = lx*ly*profile.h*sum(x)/nx/ny;

plotMap('top',iter,x,nx,ny,V,V0,nRemoved,fpen,rmin);

%saveas(gcf,['plasticBeam2_', num2str(iter),'.png'] );

pause(1e-6);

end

