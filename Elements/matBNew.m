function [ J, invJ, detJ, B ] = matBNew( elemClass, elemX )
    [ J, invJ, detJ ] = elemClass.J( elemClass.dN, elemX );
    ngp = size(elemClass.gw,1);
    dNxe = zeros(2,4,ngp);
    for i=1:ngp
      dNxe(:,:,i) = invJ(:,:,i) * elemClass.dN(:,:,i)';
    end
    B = elemClass.B( dNxe );
end

