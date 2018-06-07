function [ Ke, Me ] = stifnessAndMassMatrix( elemX, elemClass, Dmat, Mmat )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

  ngp  = size( elemClass.gp, 2 );
  for i=1:ngp
    xi = elemClass.gp(:,i);  
    Ne = matN2D( xi, elemClass );
    [ ~, ~, detJ, B ] = matB( elemClass, elemX, xi );
    dK = elemClass.gw(i) * elemClass.dksi * abs(detJ) * ( B'  * Dmat * B );
    dM = elemClass.gw(i) * elemClass.dksi * abs(detJ) * ( Ne' * Mmat * Ne );
    if ( i == 1 ) 
        Ke = dK;
        Me = dM;
    else
        Ke = Ke + dK;
        Me = Me + dM;
    end
  end

end

