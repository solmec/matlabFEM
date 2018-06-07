% function [M, K] = fem_plane_model( material, profile, node, elem, support)
%
% Finite element model of 3D frame structure
%
% output:
% M  - mass matrix
% K - elastic stiffness matrix
%
% input:
% material: structure 
%  E    - Young modulus, 
%  nu   - shear modulus, 
%  rho  - mass density
% profile: structure 
%  h    - mass density
% node: matrix (Nn,3)
% elem: matrix (Ne,4) [node1 node2 profileID theta]
% support: matrix (Ns, 7) [nodeID ux uy uz rotx roty rotz]
%
function [K, M] = fem_plane_model( node, elem, elemClass, Dmat, Mmat, support )

    nelem   = size( elem, 1);
    nnode   = size( node, 1);
    

% Calculation of element matrices

    K      = zeros( 2*nnode, 2*nnode );
    M      = zeros( 2*nnode, 2*nnode );

    for i=1:nelem
        [Ke, Me] = stifnessAndMassMatrix( node( elem(i,:), :), elemClass, Dmat, Mmat );

% Assembling of global stiffness matrix
        av = allocVconst( 2, elem( i, : ) );
        K( av , av ) =  K( av, av ) + Ke;
        M( av , av ) =  M( av, av ) + Me;
  
    end

    maxMaxK = max(max(K));
    for i=1:max(size(support))
        K( support(i), support(i)) = maxMaxK + 1e10;
    end

end