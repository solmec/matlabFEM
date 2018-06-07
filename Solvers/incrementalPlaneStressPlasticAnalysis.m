function [ disp, GPdatas, corr ] = incrementalPlaneStressPlasticAnalysis( elemClass, nodes, elems, Fext, mat, pr, supports, x )

%(i) set initial guess residual
    nelem = size( elems, 1 );
    u     = zeros( 2*size(nodes,1), 1 );
    Dmat  = matDplaneIzo( mat.E, mat.nu );
    

%  elements gauss points data structure definition

    GPdataClass.stress  = zeros( 3, 4 );
    GPdataClass.strain  = zeros( 3, 4 );
    GPdataClass.strainp = zeros( 3, 4 );
    GPdataClass.dg      = zeros( 1, 4 );

    GPdatas(1:nelem) = GPdataClass;
    
    dP      = Fext;
    Fint    = Fext;
    Fint(:) = 0;
    conv    = 1;
    iteration = 0;
%(2) iterative formula of plastic analysis
    while ( conv > 1.0E-06 )
        iteration = iteration + 1;
%(3) Assembling consistent tangent matrix
        Kt = sparse( 2*size(nodes,1), 2*size(nodes,1) );
        for i=1:nelem
                Kte = tangentMatrixSD( nodes( elems(i,:),:), elemClass, Dmat, @tangentD, GPdatas(i) );
    
% Assembling global tangent matrix
                av = allocVconst( 2, elems( i, : ) );
                Kt( av , av ) =  Kt( av, av ) + x(i) * Kte;
  
        end

        maxMaxK = max(max(Kt));
      
        for i=1:max(size(supports))
%            Kt( irange(i), :)         = 0;
%            Kt( :, irange(i))         = 0;
             Kt( supports(i), supports(i)) = maxMaxK * 1e10;
        end
        Ks = sparse(Kt);
        
% Solving of incremental equilibrium equations system;        
        du = Ks \ dP;
        u  = u + du;
        
% updating strains, stress and other variables;  
        for i=1:nelem
                new_e      = compGPstrain( nodes( elems(i,:),:), elemClass, GPdatas(i).strain, u( allocVconst( 2, elems( i, : ) ) ) );
                de         = new_e - GPdatas(i).strain;
                GPdatas(i) = updateStressStrain( GPdatas(i), de, mat );
        end

        Fint(:) = 0;
        for i=1:nelem
                Fint_e = computeInternalForces( nodes( elems(i,:),:), elemClass, GPdatas(i).stress );
                valloc = allocVconst( 2, elems( i, : ) );
                Fint( valloc ) = Fint( valloc ) + x(i) * Fint_e;
        end
        
        %printMaxMinStrainStress( GPdatas );
        
        dP = Fext - Fint;
        for i=1:max(size(supports))
            dP( supports(i) ) = 0;
        end    
       % plotMesh( nodes, elems, u );
        pconv = conv;
        conv  = norm( dP ) / norm( Fext )
        if ( (conv > 100) || (iteration > 30) )
            corr = false;
            disp = u;
            return;
        end;
            
    end
   % plotMeshPlastic( nodes, elems, u, elemClass, GPdatas );
    disp = u;
    corr = true;
end

