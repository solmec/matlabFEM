function [ Ke ] = stifnessMatrixNumerical( elemX, elemClass, Dmat )
  
  ngp  = size( elemClass.gp, 2 );
  for i=1:ngp
    [ ~, ~, detJ, B ] = matB( elemClass, elemX, elemClass.gp(:,i) );
    dK = elemClass.gw(i) * elemClass.dksi * abs(detJ) * ( B' * Dmat * B );
    if ( i == 1 ) 
        Ke = dK;
    else
        Ke = Ke + dK;
    end
  end
  
end
