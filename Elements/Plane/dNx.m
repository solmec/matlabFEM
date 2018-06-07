function [ Bc ] = matBc( r, s, xyCoords )

    dNrs = GradL4( r, s);
    [J, detJ, invJ] = jacobiM( r, s, xyCoords);
    dNxy = invJ*dNrs';
    
    Bc = zeros( 3, 8 );
    Bc(1, 1:2:7) = dNxy(1,:);
    Bc(2, 2:2:8) = dNxy(2,:);
    Bc(3, 1:2:7) = dNxy(2,:);
    Bc(3, 2:2:8) = dNxy(1,:);
end

