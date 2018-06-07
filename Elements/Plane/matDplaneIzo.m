function [ D ] = matDplaneIzo( E, nu )

D = E/(1-nu*nu)*[1 nu 0; nu 1 0; 0 0 (1-nu)/2];

end

