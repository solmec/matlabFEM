function [ Ke ] = stifnessMatrixNew( elemX, elemClass, Dmat )

   [ ~, ~, detJ, B ] = matBNew( elemClass, elemX );
   ngp = size(B,3);
   dKe = zeros( size(B,2), size(B,2), ngp );
   
   for i=1:ngp
    dKe(:,:,i) = elemClass.gw(i) .* elemClass.dksi .* abs(detJ(i) ) .* ( B(:,:,i)' * Dmat * B(:,:,i) );   
   end
   
   Ke  = sum( dKe, 3 );
  
end
