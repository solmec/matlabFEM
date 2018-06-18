function plotMap( type, iter, x, nx, ny, V, V0, nRemoved, fpen, rmin )
%PLOTMAP Summary of this function goes here
%   Detailed explanation goes here

    if strcmp(type,'top')
        colormap(gray), imagesc( -reshape(x,nx,ny)'), axis image, axis tight, axis off
        title(makeTitle(iter, nRemoved, V, V0, fpen, rmin));
    elseif  strcmp(type,'stress')
         colormap(jet), imagesc( reshape(x,nx,ny)'), axis image, axis tight, axis off, colorbar
         title(makeTitle(iter, nRemoved, V, V0, fpen, rmin));
    elseif  strcmp(type,'stress_cut')
            minx = min(x);
            plotX = zeros(size(x,1),1);

            for k=1:size(x,1)
                if  abs(x(k)-minx) > 0.08 
                    plotX(k) = ais(k);
                end
            end

            plotX = ais;

            map = [ 1 1 1; jet ];
            colormap(map), imagesc( -reshape( plotX, nx, ny )'), axis image, axis tight, axis off, colorbar
            title(makeTitle( iter, nRemoved, V, V0, fpen, rmin) );
    end

end

