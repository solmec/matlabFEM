function [ GPnew ] = updateStressStrainD( GPdata, de, mat, x )
    GPnew = GPdata;
    for i=1:size( GPdata.dg, 2 ) 
       [ GPnew.stress(:,i), GPnew.strain(:,i), GPnew.strainp(:,i), GPnew.dg(i) ] = returnMappingD( GPdata.strain(:,i), GPdata.strainp(:,i), de(:,i), mat, x );
    end
    
end

