% Cantilever in plane stress example.
%cl
clc
clear

%addpath ("./Elements/");
%addpath ("./Elements/Plane");
%addpath ("./Mesh/");
%addpath ("./Solvers/");
%addpath ("./Graph/");

%warning ("off", "Octave:divide-by-zero");
%warning ("off", "Octave:singular-matrix");

material.E   = 34.474E+09;  % [kPa]
material.nu  = 0.11;
material.rho = 568.7; % [kg/m^3]
material.sy  = 210E+06; % [kPa]

profile.h = 0.2286; % [m]

Dmat  = matDplaneIzo( material.E, material.nu );

lx = 60.96; 
ly = 15.24;

nx = 320;
ny = 120;

dx = lx/nx;
dy = ly/ny;

mats(1:5) = material;

elemClassL4 = elemClass('IzoparamL4');
elemClassL4. dksi = profile.h;

% Rectangular mesh generation
[ nodes, elems ] = rectMesh2D( nx, ny, 0, 0, lx, ly, elemPattern('L4') );
    
nelem = size(elems,1);

supports  = atLine( nodes, 1, 0.0, [1 1] );

q = 5000; % [N]
Pq = q * ly * profile.h / 4; 

P = zeros( 2 * size( nodes,1), 1 );
%P( 2 * closestNode( nodes, [ lx ly   ] ) -1 ) = -  Pq; % [N]
%P( 2 * closestNode( nodes, [ lx ly/2 ] ) -1 ) = -2*Pq; % [N]
%P( 2 * closestNode( nodes, [ lx 0    ] ) -1 ) = -  Pq; % [N]

P0 = -20.0E+06;

P( 2 * closestNode( nodes, [ lx ly/2-dy ] ) ) = P0; % [N]
P( 2 * closestNode( nodes, [ lx ly/2 ] ) )    = P0; % [N]
P( 2 * closestNode( nodes, [ lx ly/2+dy ] ) ) = P0; % [N]

% solving elastoplastic problem
%[ ~, ~, c ] = planeStressPlasticAnalysisCapacity( elemClassL4, nodes, elems, P, material, profile, supports, x );
q       = linearElasticAnalysis( elemClassL4, nodes, elems, 2, Dmat, P, material, profile, supports );
%GPdatas = compStrainStress( elems, nodes, elemClassL4, Dmat, q );
%plotMesh( nodes, elems, q );

