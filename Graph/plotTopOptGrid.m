function  plotTopOptGrid(ais,x,nx,ny, nodes, elems ) %#ok<*FNDEF>
%PLOTTOPOPT Summary of this function goes here
%   Detailed explanation goes here
minx = min(x);
plotX = zeros(size(x,1),1);

for k=1:size(x,1)
    if  abs(x(k)-minx) > 0.08 
        plotX(k) = ais(k);
    end
end

plotX = ais;

map = [ 1 1 1; jet ];

colormap(map), imagesc(reshape(plotX,nx,ny)'), axis image, axis tight, axis off, colorbar

end

