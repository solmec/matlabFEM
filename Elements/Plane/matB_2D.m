function [ Bc ] = matB_2D( dNx )
    ndofs = 2*size(dNx,2); 
    Bc    = zeros( 3, ndofs );
    Bc(1, 1:2:ndofs-1) = dNx(1,:);
    Bc(2, 2:2:ndofs)   = dNx(2,:);
    Bc(3, 1:2:ndofs-1) = dNx(2,:);
    Bc(3, 2:2:ndofs)   = dNx(1,:);
end

