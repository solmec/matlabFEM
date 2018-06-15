function [ xret, ais ] = plasticTopologyOptimization2( taskname, nodes, elems, elemClass, P, material, profile, supports, x, lx, ly, nx, ny, fpen, rmin  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nRemoved = 10;
rmBegin  = 1;
erased_elems = false( size(elems,1), 1 );


% solving elastoplastic problem
[ ~, ~, c ] = planeStressPlasticAnalysisCapacity( elemClass, nodes, elems, P, material, profile, supports, x )
%c = 1;

iter = 0;
fig = figure;
V0 = lx*ly*profile.h;
done = false;
while true

    iter = iter+1;
    
    [ u, GPdatas, corr ] = incrementalPlaneStressPlasticAnalysis( elemClass, nodes, elems, 0.8 * c * P, material, profile, supports, x );

if ( corr == false )
    rmBegin = rmBegin + nRemoved
    x            = xPrev;
    erased_elems = erasedPrev;
    GPdatas      = GPdatasPrev;
else
    xPrev       = x;
    erasedPrev  = erased_elems;
    GPdatasPrev = GPdatas;
    rmBegin = 1
end

[ elem_list, erased_elems, ais, done ] = elem2del4( nx, ny, erased_elems, GPdatas, material, nRemoved, rmBegin, x, rmin );

if done == true
    x           = xPrev;
    erased_elems = erasedPrev;
    GPdatas      = GPdatasPrev;
    
    V = lx*ly*profile.h*sum(x)/nx/ny;
    subplot(2,1,1),
    colormap(jet), imagesc( -reshape(ais,nx,ny)'), axis image, axis tight, axis off, colorbar
    title(['Iter: ', num2str(iter),', nr: ', num2str(nRemoved),', Volume: ' num2str(V/V0*100.0), ' %']);
    subplot(2,1,2),
    colormap(gray), contourf( -reshape(x,nx,ny)'), axis image, axis tight, axis off, colorbar
    title(['Iter: ', num2str(iter),', nr: ', num2str(nRemoved),', Volume: ' num2str(V/V0*100.0), ' %']);
    
    disp(['Analysis finished correctly.' ]);
    saveas( gcf,[ taskname, '.png'] );
    save( taskname );
    savefig(taskname);
    xret = x;
    return
else
    x( elem_list ) = max( 0.01 * profile.h, x( elem_list ).*ais( elem_list ).^fpen); % 1.5 is perfect!!!!
    x( erased_elems ) = 0.01 * profile.h;
    V = lx*ly*profile.h*sum(x)/nx/ny;
    subplot(2,1,1),
    colormap(jet), imagesc( -reshape(ais,nx,ny)'), axis image, axis tight, axis off, colorbar
    title(['Iter: ', num2str(iter),', nr: ', num2str(nRemoved),', Volume: ' num2str(V/V0*100.0), ' %']);
    subplot(2,1,2),
    colormap(gray), contourf( -reshape(x,nx,ny)'), axis image, axis tight, axis off, colorbar
    title(['Iter: ', num2str(iter),', nr: ', num2str(nRemoved),', Volume: ' num2str(V/V0*100.0), ' %']);
end    

%saveas(gcf,['plasticBeam2_', num2str(iter),'.png'] );


pause(1e-6);

end

