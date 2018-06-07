function [ J, invJ, detJ ] = jacobiPlane2D( dN, elemX )

x = elemX(:,1);
y = elemX(:,2);

dNr = dN(:,1);
dNs = dN(:,2);

J11 = dNr' * x;  J12 = dNr' * y;
J21 = dNs' * x;  J22 = dNs' * y;

J = [ J11 J12; J21 J22 ];

detJ = J11 * J22 - J12 * J21;

invJ = 1 / detJ * [ J22 -J21; -J12  J11 ]; 

end

