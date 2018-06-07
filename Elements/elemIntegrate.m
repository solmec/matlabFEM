function [ Ke ] = elemIntegrate( gw, dK, J, detJ )

    np = size( gp, 2 );
    Ke = gw(1) * dK(:,:,1) * abs( detJ(1) );
    for i=2:np)
        Ke = Ke + gw(i) * dK(:,:,i) * abs( detJ(i) );
    end
end

