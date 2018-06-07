function [ Bc ] = matB_2DNew( dN )

    ndofs = 2 * size(dN,3); 
    npg   = size(dN,3); 
    Bc    = zeros( 3, ndofs, npg );
    
    for i=1:npg
      Bc(1, 1:2:ndofs-1,i) = dN(1,:,i);
      Bc(2, 2:2:ndofs,i)   = dN(2,:,i);
      Bc(3, 1:2:ndofs-1,i) = dN(2,:,i);
      Bc(3, 2:2:ndofs,i)   = dN(1,:,i);
    end;
    
end

