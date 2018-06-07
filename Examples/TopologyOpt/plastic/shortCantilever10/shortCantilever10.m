% Cantilever in plane stress example.
clc
clear
%addpath ('Elements/');
%addpath ("./Elements/Plane");
%addpath ("./Mesh/");
%addpath ("./Solvers/");

material.E   = 34.474E+09;  % [kPa]
material.nu  = 0.11;
material.rho = 568.7; % [kg/m^3]
material.sy  = 210E+06; % [kPa]

profile.h = 0.2286; % [m]

lx=15; 
ly=15;


nx = 20;
ny = 20;

dx = lx/nx;
dy = ly/ny;

mats(1:5) = material;

elemClassL4 = elemClass('IzoparamL4');
elemClassL4.dksi = profile.h;

% Rectangular mesh generation
[ nodes, elems ] = rectMesh2D( nx, ny, 0, 0, lx, ly, elemPattern('L4') );

x = ones( size(elems, 1), 1 ); % thickness density
erased_elems = false( size(elems,1), 1 );
change = 1;

iter = 0;
c    = 0.3;

V = lx*ly*profile.h*sum(x)/nx/ny;
nRemoved = 20;

    
nelem = size(elems,1);

supports  = [   nearestTo( nodes, [ 0,    ly        ], [ 1 1 ] ) ...
                nearestTo( nodes, [ 0,    ly-dx     ], [ 1 1 ] ) ...
                nearestTo( nodes, [ 0,    ly-2*dx   ], [ 1 1 ] )...
                nearestTo( nodes, [ 0,    ly-3*dx   ], [ 1 1 ] )...
                nearestTo( nodes, [ 0,   3*dy ], [ 1 0 ] ) ...
                nearestTo( nodes, [ 0,   2*dy ], [ 1 0 ] ) ...
                nearestTo( nodes, [ 0,     dy ], [ 1 0 ] )...
                nearestTo( nodes, [ 0,      0 ], [ 1 0 ] ) ];


q = 5000; % [N]
Pq = q * ly * profile.h / 4; 

Pmu = 0.0;
Psd = 0.5;
R = 0.9999;

Plim =  1 * norminv( (1+R)/2 ,Pmu, Psd )

nlcases = 3;

P = zeros( 2 * size( nodes,1), 1 );


mP = [];
mc = zeros(nlcases,1);
u = zeros(nlcases,1);

% Probabilistic approach 

Pmu = 0.0;
Psd = 3;
R = 0.9999;

al0 =  Psd * norminv( (1+R)/2 ,Pmu,Psd )

nlcases = 3;

P = zeros( 2 * size( nodes,1), 1 );


mP = [];
mc = zeros(nlcases,1);
u = zeros(nlcases,1);



%P( 2 * closestNode( nodes, [ lx ly   ] ) -1 ) = -  Pq; % [N]
%P( 2 * closestNode( nodes, [ lx ly/2 ] ) -1 ) = -2*Pq; % [N]
%P( 2 * closestNode( nodes, [ lx 0    ] ) -1 ) = -  Pq; % [N]

P0 = -20.0E+06;

Px = P0 * sin( al0 / 180.0 * pi );
Py = P0 * cos( al0 / 180.0 * pi );


P( 2 * closestNode( nodes, [ lx/2 - dx    ly ] ) -1 ) = Px; % [N]
P( 2 * closestNode( nodes, [ lx/2 - 2*dx  ly ] ) -1 ) = Px; % [N]
P( 2 * closestNode( nodes, [ lx/2 - 3*dx  ly ] ) -1 ) = Px; % [N]

P( 2 * closestNode( nodes, [ lx/2 - dx    ly ] )  ) = Py; % [N]
P( 2 * closestNode( nodes, [ lx/2 - 2*dx  ly ] )  ) = Py; % [N]
P( 2 * closestNode( nodes, [ lx/2 - 3*dx  ly ] )  ) = Py; % [N]

mP = [mP P];

P( 2 * closestNode( nodes, [ lx/2 - dx    ly ] ) -1 ) = -Px; % [N]
P( 2 * closestNode( nodes, [ lx/2 - 2*dx  ly ] ) -1 ) = -Px; % [N]
P( 2 * closestNode( nodes, [ lx/2 - 3*dx  ly ] ) -1 ) = -Px; % [N]

mP = [mP P];

P( 2 * closestNode( nodes, [ lx/2 - dx    ly ] ) -1 ) = 0; % [N]
P( 2 * closestNode( nodes, [ lx/2 - 2*dx  ly ] ) -1 ) = 0; % [N]
P( 2 * closestNode( nodes, [ lx/2 - 3*dx  ly ] ) -1 ) = 0; % [N]


P( 2 * closestNode( nodes, [ lx/2 - dx    ly ] )  ) = P0; % [N]
P( 2 * closestNode( nodes, [ lx/2 - 2*dx  ly ] )  ) = P0; % [N]
P( 2 * closestNode( nodes, [ lx/2 - 3*dx  ly ] )  ) = P0; % [N]


mP = [mP P];

tic

cenv = threeLoadMultiTopologtOptanalysis( 'shortCantilever10', nodes, elems, elemClassL4, mP, material, profile, supports, x, lx, ly, nx, ny );

cenv

toc
