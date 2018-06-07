function [ cenv ] = threeLoadMultiTopologtOptanalysis( titlename, nodes, elems, elemClass, mP, material, profile, supports, x, lx, ly, nx, ny )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


cm = plasticTopologyOptimizationMulti( strcat(titlename,'_Multi'), nodes, elems, elemClass, mP, material, profile, supports, x, lx, ly, nx, ny );

xres=[x x x];
parfor k=1:3
    if k==1 
        xres(:,k) = plasticTopologyOptimization( strcat(titlename,'_Plus'), nodes, elems, elemClass, cm * mP(:,1), material, profile, supports, x, lx, ly, nx, ny );
    end
    if k==2
        xres(:,k) = plasticTopologyOptimization( strcat(titlename,'_Minus'), nodes, elems, elemClass, cm * mP(:,2), material, profile, supports, x, lx, ly, nx, ny );
    end    
    if k==3
        xres(:,k) = plasticTopologyOptimization( strcat(titlename,'_Vert'), nodes, elems, elemClass, cm * mP(:,3), material, profile, supports, x, lx, ly, nx, ny );
    end
end

xenv = max( max( xres(:,1), xres(:,2) ) , xres(:,3) );
Venv = lx*ly*profile.h*sum(xenv)/nx/ny;

colormap(gray), imagesc( flipud(-reshape(xenv,nx,ny)')), axis image, axis tight, axis off
title(['Envelope, Volume: ' num2str(Venv), ' m^3']);
saveas( gcf,strcat(titlename,'_envelope.png' ) );
savefig(strcat(titlename,'_envelope'));

%cenv = zeros(3,1);

parfor i=1:3
     if i==1
        [ ~, ~, cenv(i) ] = planeStressPlasticAnalysisCapacity( elemClass, nodes, elems, cm*mP(:,1), material, profile, supports, xenv );
     end
     if i==2
        [ ~, ~, cenv(i) ] = planeStressPlasticAnalysisCapacity( elemClass, nodes, elems, cm*mP(:,2), material, profile, supports, xenv );
     end
     if i==3
        [ ~, ~, cenv(i) ] = planeStressPlasticAnalysisCapacity( elemClass, nodes, elems, mP(:,3), material, profile, supports, xenv );
     end
end



end

