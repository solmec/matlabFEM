function [ J, invJ, detJ, B ] = matB( elemClass, elemX, xi  )
    dNe = elemClass.dN( xi );
    [ J, invJ, detJ ] = elemClass.J( dNe, elemX );
    dNxe = invJ * dNe';
    B = elemClass.B( dNxe );
end

