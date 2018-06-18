function [title] = makeTitle(iter, nRemoved, V, V0, fpen, rmin )
%MAKETITLE Summary of this function goes here
%   Detailed explanation goes here

title = ['V: ' num2str(V/V0*100.0,3), ' %',', pen:' num2str(fpen,2), ', fl:' num2str(rmin), ', del: ', num2str(nRemoved), ', i: ', num2str(iter) ];

end

