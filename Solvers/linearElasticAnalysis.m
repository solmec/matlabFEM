function [ u ] = linearElasticAnalysis( elemClass, nodes, elems, nndof, Dmat, Fext, mat, pr, supports )

%(i) set initial guess residual
    dim   = nndof * size( nodes, 1 );
    nelem = size( elems, 1 );
    u     = zeros( dim, 1 );
  
    Ks = sparse( dim, dim );
    av = allocVconst( nndof, elems( 1, : ) );
    eldim = size( av, 2 );
    tic;
    for i=1:nelem
        Kte = stifnessMatrixNumerical( nodes( elems(i,:),:), elemClass, Dmat );
    
% Assembling global tangent matrix
        av = allocVconst( 2, elems( i, : ) );
                %Kt( av , av ) =  Kt( av, av ) + x(i) * Kte;
        Ks( av , av ) =  Ks( av, av ) + sparse( Kte );
    end        
    disp("Stifness matrix aggregation time :");
    toc
    disp("\n")   
    maxMaxK = max(max(Ks));
      
    for i=1:max(size(supports))
%            Kt( irange(i), :)         = 0;
%            Kt( :, irange(i))         = 0;
    Ks( supports(i), supports(i)) = maxMaxK * 1e10;
    end
            
        %Ks = sparse(Kt);
        
% Solving of incremental equilibrium equations system;        
tic
    u = Ks \ Fext;
disp("Solution time :");
toc
disp("\n")         

end

