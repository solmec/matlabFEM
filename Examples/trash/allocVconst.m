function [valloc] = allocVconst( ndof, elem )
  ned = ndof * size( elem, 2 );
  valloc = zeros( 1, ndof * size( elem,2 ) );
  for k=1:ndof
    valloc([ k:ndof:ned ]) = ndof * elem + k - ndof;
  end  
end
