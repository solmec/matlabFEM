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

lx=60.96; 
ly=15.24;

%nx = 160;
%ny = 60;

nx = 90;
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

V  = lx*ly*profile.h*sum(x)/nx/ny;
v0 = V;
nRemoved = 20;

    
nelem = size(elems,1);

supports  = atLine( nodes, 1, 0.0, [1 1] );

q = 5000; % [N]
Pq = q * ly * profile.h / 4; 

Pmu = 0.0;
Psd = 2;
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


P = zeros( 2 * size( nodes,1), 1 );
%P( 2 * closestNode( nodes, [ lx ly   ] ) -1 ) = -  Pq; % [N]
%P( 2 * closestNode( nodes, [ lx ly/2 ] ) -1 ) = -2*Pq; % [N]
%P( 2 * closestNode( nodes, [ lx 0    ] ) -1 ) = -  Pq; % [N]

P0 = -20.0E+06;

P( 2 * closestNode( nodes, [ lx ly/2-dy ] ) -1 ) = Px; % [N]
P( 2 * closestNode( nodes, [ lx ly/2 ] ) -1 )    = Px; % [N]
P( 2 * closestNode( nodes, [ lx ly/2+dy ] ) -1 ) = Px; % [N]

P( 2 * closestNode( nodes, [ lx ly/2-dy ] ) ) = Py; % [N]
P( 2 * closestNode( nodes, [ lx ly/2 ] ) )    = Py; % [N]
P( 2 * closestNode( nodes, [ lx ly/2+dy ] ) ) = Py; % [N]

mP = [mP P];

P( 2 * closestNode( nodes, [ lx ly/2-dy ] ) -1 ) = -Px; % [N]
P( 2 * closestNode( nodes, [ lx ly/2 ] ) -1 )    = -Px; % [N]
P( 2 * closestNode( nodes, [ lx ly/2+dy ] ) -1 ) = -Px; % [N]

mP = [mP P];

P( 2 * closestNode( nodes, [ lx ly/2-dy ] ) -1 ) = 0; % [N]
P( 2 * closestNode( nodes, [ lx ly/2 ] ) -1 )    = 0; % [N]
P( 2 * closestNode( nodes, [ lx ly/2+dy ] ) -1 ) = 0; % [N]

P( 2 * closestNode( nodes, [ lx ly/2-dy ] ) ) = P0; % [N]
P( 2 * closestNode( nodes, [ lx ly/2 ] ) )    = P0; % [N]
P( 2 * closestNode( nodes, [ lx ly/2+dy ] ) ) = P0; % [N]

mP = [mP P];

tic

%cenv = multiLoadMultiTopologtOptanalysis( 'plasticCantilever', nodes, elems, elemClassL4, mP, material, profile, supports, x, lx, ly, nx, ny );

%[ ~, ~, c ] = planeStressPlasticAnalysisCapacity( elemClassL4, nodes, elems, mP(:,3), material, profile, supports, x )

c = 0.8125;

parfor k=1:4
    if k==1
        x07 = plasticTopologyOptimizationD( 'densityTest_07_2_80', nodes, elems, elemClassL4, 0.8 * c * mP(:,3), material, profile, supports, x, lx, ly, nx, ny, 0.7, 2, 10 , 0.002 );
    end
    if k==2
        x1  = plasticTopologyOptimizationD( 'densityTest_10_2_10', nodes, elems, elemClassL4, 0.8 * c * mP(:,3), material, profile, supports, x, lx, ly, nx, ny, 1.0, 2, 10 , 0.002 );
    end
    if k==3
        x2  = plasticTopologyOptimizationD( 'densityTest_12_2_10', nodes, elems, elemClassL4, 0.8 * c * mP(:,3), material, profile, supports, x, lx, ly, nx, ny, 1.2, 2, 10 , 0.002 );
    end
    if k==4
        x5  = plasticTopologyOptimizationD( 'densityTest_15_2_10', nodes, elems, elemClassL4, 0.8 * c * mP(:,3), material, profile, supports, x, lx, ly, nx, ny, 1.5, 2, 10 , 0.002 );
    end
end

toc

