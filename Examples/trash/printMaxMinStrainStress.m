function [ e ] = printMaxMinStrainStress( GPdatas )

    nelem  = size(GPdatas,2);
    stress = [ GPdatas(1:nelem).stress ];
    strain = [ GPdatas(1:nelem).strain ];
    npg    = size(stress,2) / nelem;
    sdim   = size(stress,1);
    
    stressM = zeros( sdim, 2 );
    strainM = zeros( sdim, 2 );
    stressI = zeros( sdim, 2 );
    strainI = zeros( sdim, 2 );
    for i=1:sdim
        [ strainM(i,1), strainI(i,1) ] = min( strain(i,:) );
        [ strainM(i,2), strainI(i,2) ] = max( strain(i,:) );
        [ stressM(i,1), stressI(i,1) ] = min( stress(i,:) );
        [ stressM(i,2), stressI(i,2) ] = max( stress(i,:) );
    end
      
    
    sprintf('Number of elements %i. Number of gausspoints/element: %i. \n', nelem, npg);
    strainM
%    sprintf('Min elem    Max elem\n');
 %   ceil( strainI ./ npg )
    
    sprintf('Min stress    Max stress    element \n');
    stressM 
%    sprintf('Min elem    Max elem\n');
 %   ceil( stressI ./ npg )

end

