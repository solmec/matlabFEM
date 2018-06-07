% function filtStress = designFilter( nodes, elems, rmin,  ais, x )
% 
% nelems = size( elems, 1);
% 
% elemCenter = zeros( nelems, 2);
% elemCenter(:,1) = 0.5*(nodes( elems(:,1),1)+nodes( elems(:,2),1));
% elemCenter(:,2) = 0.5*(nodes( elems(:,2),2)+nodes( elems(:,3),2));
% dist = zeros( nelems, nelems);
% 
% 
% filtStress = zeros(nelems,1);
% 
% for i=1:nelems
%     for k=1:nelems
%          dist(k,i) = sqrt( (elemCenter(k,1)-elemCenter(i,1))^2 + ...
%                            (elemCenter(k,2)-elemCenter(i,2))^2 );
%     end
%     mind   = find( dist(:,i) <= rmin );
%     weight = mind;
%     for k=1:size(mind,1)
%         weight(k) = 1 - dist( mind(k), i ) / rmin;
%     end
%     filtStress(i) = weight'*ais(mind)*x(mind)/sum(weight(:));
% end


function [dcn] = designFilter( nelx, nely, rmin, x, dc)
dcn = zeros( nely, nelx);
for i = 1:nelx
    for j = 1:nely
        sum=0;
        for k = max(i-floor(rmin),1):min(i+floor(rmin),nelx)
            for l = max (j-floor(rmin),1):min(j+floor(rmin),nely)
                fac = rmin-sqrt((i-k)^2+(j-l)^2);
                sum = sum + max(0,fac);
                dcn(j,i) = dcn(j,i) + max(0,fac)*x(l,k)*dc(l,k);
            end
        end
        dcn(j,i) = dcn(j,i)/(x(j,i)*sum);
    end
end
