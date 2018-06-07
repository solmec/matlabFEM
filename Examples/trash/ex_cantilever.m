% Cantilever in plane stress example.
%clear

material.E   = 34.474E+09;  % [Pa]
material.nu  = 0.11;
material.rho = 568.7; % [kg/m^3]
material.sy  = 210E+06; % [Pa]

profile.h = 0.2286; % [m]

Dmat  = matDplaneIzo( material.E, material.nu );
Mmat  = [ material.rho 0; 0 material.rho]; 

lx=60.96; 
ly=15.24;

nx = 32;
ny = 8;

dx = lx/nx;
dy = ly/ny;

mats(1:5) = material;

elemClassL4 = elemClass('IzoparamL4');
elemClassL4.dksi = profile.h;

% Rectangular mesh generation
%[ nodes, elems ] = rectMesh2D( nx, ny, 0, 0, lx, ly, elemPattern('L4') );
[ nodes, elems ] = polMesh2D( 40, 80, 0, 0, 10, 0, 10, pi/2, elemPattern('L4') );

supports  = atLine( nodes, 1, 0.0, [1 1] );
%supports = [ 1 1 1; 10 1 0; 19 1 0 ];
%

q = 5000; % [N]
Pq = q * ly * profile.h / 4; 

P = zeros( 2 * size( nodes,1), 1 );
%P( 2 * closestNode( nodes, [ lx ly   ] ) -1 ) = -  Pq; % [N]
%P( 2 * closestNode( nodes, [ lx ly/2 ] ) -1 ) = -2*Pq; % [N]
%P( 2 * closestNode( nodes, [ lx 0    ] ) -1 ) = -  Pq; % [N]

P( 2 * closestNode( nodes, [ lx ly/2 ] ) ) = -48.8E+06; % [N]


% Solving equations
          
 [K, M] = fem_plane_model( nodes, elems, elemClassL4, Dmat, Mmat, supports );
 Ks = sparse(K);
 Ms = sparse(M);
 [V, D] = eigs( K, M, 10, 'SM' );
 %[Dsort, Dindx] = sort( diag( D ) );
 %Vsort = V(:,Dindx);
 Vsort = V;
 Dsort = diag( D );
 
 omega = sqrt(Dsort)/2/pi; 
 omega(1:10)
 
 q = Ks \ P;


clf
plot( nodes(:,1), nodes(:,2), '.'), axis image, axis off, hold on
%for i=1:size(nodes,1), text( nodes( i,1 ), nodes(i,2) , num2str(i) ); end
for i =1:size(elems,1) 
    plot( ...
        [nodes(elems(i,1),1), nodes(elems(i,2),1), nodes(elems(i,3),1), nodes(elems(i,4),1), nodes(elems(i,1),1)],...
        [nodes(elems(i,1),2), nodes(elems(i,2),2), nodes(elems(i,3),2), nodes(elems(i,4),2), nodes(elems(i,1),2)],...
        'b:'), 
end


scale = 100;

% static deform
% deform = nodes + scale * [ q( 1:2:end ) q( 2:2:end ) ];

% eigen modes
mode = 4;
deform = nodes + scale * [ Vsort( 1:2:end, mode ) Vsort( 2:2:end, mode ) ];


for i =1:size(elems,1) 
    plot( ...
        [deform(elems(i,1),1), deform(elems(i,2),1), deform(elems(i,3),1), deform(elems(i,4),1), deform(elems(i,1),1)],...
        [deform(elems(i,1),2), deform(elems(i,2),2), deform(elems(i,3),2), deform(elems(i,4),2), deform(elems(i,1),2)],...
        'b'), 
end

plot( deform(:,1), deform(:,2), 'g.');

axis image


