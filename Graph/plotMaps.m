function  plotMaps(iter,ais,x,nx,ny,V,V0,nRemoved,fpen,rmin)
%PLOTMAP Summary of this function goes here
%   Detailed explanation goes here

subplot(2,1,1),
colormap(jet), imagesc( -reshape(ais,nx,ny)'), axis image, axis tight, axis off, colorbar
title(makeTitle(iter, nRemoved, V, V0, fpen, rmin ));
subplot(2,1,2),
colormap(gray), imagesc( -reshape(x,nx,ny)'), axis image, axis tight, axis off, colorbar
title(makeTitle(iter, nRemoved, V, V0, fpen, rmin ));

end

