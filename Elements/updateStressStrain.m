function [ GPnew ] = updateStressStrain( GPdata, de, mat )
    GPnew = GPdata;
    for i=1:size( GPdata.dg, 2 ) 
       [ GPnew.stress(:,i), GPnew.strain(:,i), GPnew.strainp(:,i), GPnew.dg(i) ] = returnMapping( GPdata.strain(:,i), GPdata.strainp(:,i), de(:,i), mat );
    end
    
end

