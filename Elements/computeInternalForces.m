function [ f ] = computeInternalForces( elemX, elemClass, stress )
    
    for i=1:size(elemClass.gp,2)
        [ ~, ~, detJ, B ] = matB( elemClass, elemX, elemClass.gp(:,i) );
        if ( i==1 )
            f = elemClass.gw(i) * elemClass.dksi * abs(detJ) * B' * stress(:,i);    
        else 
            f = f + elemClass.gw(i) * elemClass.dksi * abs(detJ) * B' * stress(:,i);    
        end
    end
    
end

