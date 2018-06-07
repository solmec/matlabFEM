function [ disp, GPdatas, acc ] = planeStressPlasticAnalysisCapacity( elemClass, nodes, elems, Fext, mat, pr, supports, x )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

a = 1;

[  disp, GPdatas, corr ] = incrementalPlaneStressPlasticAnalysis( elemClass, nodes, elems, Fext, mat, pr, supports, x );

if ( corr == true )
    b = a;
    while ( corr == true ) 
        b = b * 2;
        [ disp, GPdatas, corr ] = incrementalPlaneStressPlasticAnalysis( elemClass, nodes, elems, Fext*b, mat, pr, supports, x );
    end
else
    b = a;
    while ( corr == false ) 
        a = a / 2;
        [  disp, GPdatas, corr ] = incrementalPlaneStressPlasticAnalysis( elemClass, nodes, elems, Fext*a, mat, pr, supports, x );
    end
end

while ( (b-a > 0.02) )
    c = (b + a) / 2;
    [  disp, GPdatas, corr ] = incrementalPlaneStressPlasticAnalysis( elemClass, nodes, elems, Fext*c, mat, pr, supports, x );
    if ( corr == true )
        a = c;
    else
        b = c;
    end
    interval = b-a
end
    if ( corr == true )
        acc = c;
    else
        acc = a;
    end

end

