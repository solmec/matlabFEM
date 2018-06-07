function [ J, invJ, detJ ] = jacobiPlane2DNew( dN, elemX )

npg = size(dN,3);

x = elemX(:,1);
y = elemX(:,2);


x = elemX(:,1);
y = elemX(:,2);

dNr = dN(:,1);
dNs = dN(:,2);
J    = zeros(2,2,npg);
invJ = zeros(2,2,npg);
detJ = zeros(1,npg);

for i=1:npg
  
  dNr = dN(:,1,i);
  dNs = dN(:,2,i);
  
  J11 = dNr' * x;  J12 = dNr' * y;
  J21 = dNs' * x;  J22 = dNs' * y;

  J(:,:,i) = [ J11 J12; J21 J22 ];

  detJ(i) = J11 * J22 - J12 * J21;

  invJ(:,:,i) = 1 / detJ(i) * [ J22 -J21; -J12  J11 ]; 
end

end

