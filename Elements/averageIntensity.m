function [ ai ] = averageIntensity( GPdatas, mat )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    ngp = size( GPdatas.dg, 2 );


    ai=0;
    for i=1:ngp 
        s11 = GPdatas.stress(1,i);
        s22 = GPdatas.stress(2,i);
        s12 = GPdatas.stress(3,i);
    
        ai = ai + sqrt( s11^2 - s11*s22 + s22^2 + 3*s12^2 );
       
    end
    
    ai = ai / ngp / mat.sy;

end

