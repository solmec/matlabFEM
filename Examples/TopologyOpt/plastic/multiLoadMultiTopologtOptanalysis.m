function [ cenv ] = multiLoadMultiTopologtOptanalysis( titlename, nodes, elems, elemClass, mP, material, profile, supports, x, lx, ly, nx, ny, lf, fpen, rmin  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

nlcases = size(mP,2);
ne      = size(x,1);

[xtop, cm] = plasticTopologyOptimizationMulti( strcat(titlename,'_Multi'), nodes, elems, elemClass, mP, material, profile, supports, x, lx, ly, nx, ny, lf, fpen, rmin );

xres=zeros(ne,nlcases);
parfor k=1:nlcases
        xres(:,k) = plasticTopologyOptimization( strcat(titlename,int2str(k)), nodes, elems, elemClass, lf * cm * mP(:,k), material, profile, supports, x, lx, ly, nx, ny, fpen, rmin );
end

xenv = x;

for k=1:ne
    xenv(k)=0;
    for l=1:nlcases
        xenv(k)=max(xenv(k),xres(k,l));
    end
end

Venv = lx*ly*profile.h*sum(xenv)/nx/ny;

colormap(gray), imagesc( flipud(-reshape(xenv,nx,ny)')), axis image, axis tight, axis off
title(['Envelope, Volume: ' num2str(Venv), ' m^3']);
saveas( gcf,strcat(titlename,'_envelope.png' ) );
savefig(strcat(titlename,'_envelope'));

cenv   = zeros(nlcases,1);
cmulti = zeros(nlcases,1);

parfor i=1:nlcases
        [ ~, ~, cenv(i) ] = planeStressPlasticAnalysisCapacity( elemClass, nodes, elems, lf * cm * mP(:,i), material, profile, supports, xenv );
end

parfor i=1:nlcases
        [ ~, ~, cmulti(i) ] = planeStressPlasticAnalysisCapacity( elemClass, nodes, elems, lf * cm * mP(:,i), material, profile, supports, xtop );
end

cenv
cmulti

end

