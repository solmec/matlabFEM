% Cantilever in plane stress example.
%cl
clc
clear
%addpath ('Elements/');
%addpath ("./Elements/Plane");
%addpath ("./Mesh/");
%addpath ("./Solvers/");

%warning ("off", "Octave:divide-by-zero");
%warning ("off", "Octave:singular-matrix");

material.E   = 34.474E+09;  % [kPa]
material.nu  = 0.11;
material.rho = 568.7; % [kg/m^3]
material.sy  = 210E+06; % [kPa]

profile.h = 0.2286; % [m]

lx=60.96; 
ly=15.24;

nx = 80;
ny = 20;

dx = lx/nx;
dy = ly/ny;

mats(1:5) = material;

elemClassL4 = elemClass('IzoparamL4');
elemClassL4.dksi = profile.h;

% Rectangular mesh generation
[ nodes, elems ] = rectMesh2D( nx, ny, 0, 0, lx, ly, elemPattern('L4') );

supports  = [ nearestTo( nodes, [ 0.0, 0.0 ], [1 1] ) ...
              nearestTo( nodes, [ dx, 0.0 ], [1 1] )...
              nearestTo( nodes, [ 2*dx, 0.0 ], [1 1] )... 
              nearestTo( nodes, [ lx, 0.0], [0 1] )...
              nearestTo( nodes, [ lx-dx, 0.0], [0 1] )...
              nearestTo( nodes, [ lx-2*dx, 0.0], [0 1] ) ];
%supports = [ 1 1 1; 10 1 0; 19 1 0 ];
%

q = 5000; % [N]
Pq = q * ly * profile.h / 4; 

%Pcant = -63.0E+06;

Pcant = -10.0E+06;

P = zeros( 2 * size( nodes,1), 1 );

% Load at the bottom
%P( 2 * closestNode( nodes, [ lx/2-dx 0 ] ) ) = -40.0E+06; % N]
%P( 2 * closestNode( nodes, [ lx/2 0 ] ) )    = -40.0E+06; % [N]
%P( 2 * closestNode( nodes, [ lx/2+dx 0 ] ) ) = -40.0E+06; % [N]

% Load at the top
%P( 2 * closestNode( nodes, [ lx/2-dx ly ] ) ) = Pcant; % [N]
%P( 2 * closestNode( nodes, [ lx/2 ly ] ) )    = Pcant; % [N]
%P( 2 * closestNode( nodes, [ lx/2+dx ly ] ) ) = Pcant; % [N]

% Load in the middle
P( 2 * closestNode( nodes, [ lx/2-dx ly/2 ] ) ) = Pcant; % N]
P( 2 * closestNode( nodes, [ lx/2 ly/2 ] ) )    = Pcant; % [N]
P( 2 * closestNode( nodes, [ lx/2+dx ly/2 ] ) ) = Pcant; % [N]

% solving nonlinear elasto plastic problem


tic;
[ u, GPdatas, c ] = planeStressPlasticAnalysisCapacity( elemClassL4, nodes, elems, P, material, profile, supports );

c

[ u, GPdatas, corr ] = incrementalPlaneStressPlasticAnalysis( elemClassL4, nodes, elems, P*c, material, profile, supports );
toc;

plotMeshPlastic( nodes, elems, u, elemClassL4, GPdatas );




