function [ e ] = compGPstrain( elemX, elemClass, strain, ue )
    
    e = strain;
    for i=1:size(elemClass.gp,2)
        [ ~, ~, ~, B ] = matB( elemClass, elemX, elemClass.gp(:,i) );
        e(:,i) = B * ue;
    end

end

