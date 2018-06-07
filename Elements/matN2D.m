function [ Ne ] = matN2D( xi, elemClass )
    N = elemClass.sf( xi );
    ndofs = 2*size(N,1);
    Ne=zeros( 2, ndofs );
    Ne( 1, 1:2:ndofs-1  ) = N(:);
    Ne( 2, 2:2:ndofs    ) = N(:);
end

