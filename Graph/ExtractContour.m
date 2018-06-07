function [ levels, contours ] = ExtractContour( contour )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

done = false;
ind = 1;
ncontours = 0;

while ind > size( contour, 2 )
    lsize = contour(2,ind);
    lev   = contour(1,ind);
    
    ncontours = ncontours + 1;
    ind = ind + lsize + 1;
end

levels = zeros( 1, ncontours );


end

