function [ params ] = multiParamsTopologtOptAnalysis( titlename, nodes, elems, elemClass, mP, material, profile, supports, x, lx, ly, nx, ny, lf, fpens, rmins  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[ ~, ~, c ] = planeStressPlasticAnalysisCapacity( elemClass, nodes, elems, mP, material, profile, supports, x )

nthreads = 4;
params = [];
iparams=0;
for k=1:size(fpens,2)
    for l=1:size(rmins,2)
        params = [params; [ fpens(k) rmins(l) ] ];
        iparams = iparams + 1;
    end
end

ip=1;
while ip < iparams
    parfor k=ip:min( ip + nthreads, iparams )
        plasticTopologyOptimization( strcat( titlename,'_',int2str(k) ), nodes, elems, elemClass, lf * c * mP, material, profile, supports, x, lx, ly, nx, ny, params(k,1), params(k,2) );
    end
    ip = ip + min(nthreads, iparams - ip ); 
end

end

