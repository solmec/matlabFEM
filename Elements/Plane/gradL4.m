function [sf] = gradL4( xi )

    r = xi(1);
    s = xi(2);
    
    sf = zeros(4,2);

    sf(1,1) = -(1-s)/4;
    sf(2,1) =  (1-s)/4;
    sf(3,1) =  (1+s)/4;
    sf(4,1) = -(1+s)/4;

    sf(1,2) = -(1-r)/4;
    sf(2,2) = -(1+r)/4;
    sf(3,2) =  (1+r)/4;
    sf(4,2) =  (1-r)/4;

end

