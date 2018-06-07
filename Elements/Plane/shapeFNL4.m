function [sf] = shapeFNL4( xi )
r = xi(1);
s = xi(2);
sf = zeros(4,1);
sf(1) = (1-r)*(1-s)/4;
sf(2) = (1+r)*(1-s)/4;
sf(3) = (1+r)*(1+s)/4;
sf(4) = (1-r)*(1+s)/4;
end

