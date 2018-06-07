function [ nodes, elems ] = mergeMesh( nodes1, elems1, nodes2, elems2, eps )
    elems  = [elems1; (size(nodes1,1)+elems2)];
    nodes  = [nodes1; nodes2];
    inds   = 1:size(nodes,1);
    ind    = size(nodes1,1)+1;
    
    counter = size(nodes1,1)+1;
    todelete = [];
    
    for k=1:size(nodes2,1)
        deleted = false;
        for l=1:size(nodes1,1)
            if norm(nodes2(k,:)-nodes1(l,:)) < eps 
                deli = l;
                deleted = true;
            end
        end
        if deleted == true
            inds( ind ) = deli;
            todelete = [ todelete size(nodes1,1)+k ];
        else
            inds( ind ) = counter;
            counter = counter + 1;
        end
        ind = ind + 1;
    end
    for k=1:size(elems,1)
        for l=1:size(elems,2)
            elems(k,l) = inds( elems(k,l) );
        end
    end
    nodes( todelete, : ) = [];
end