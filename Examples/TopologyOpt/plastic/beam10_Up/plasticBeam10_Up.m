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

lx=60.00; 
ly=15.24;

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


V = lx*ly*profile.h*sum(x)/nx/ny;
nRemoved = 10;

    
nelem = size(elems,1);

%  supports  = [ nearestTo( nodes, [ 0, 0 ], [ 1 1 ] ) ...
%                                               nearestTo( nodes, [ dx, 0 ], [ 1 1 ] ) ...
%                                               nearestTo( nodes, [ 2*dx, 0 ], [ 1 1 ] )...
%                                               nearestTo( nodes, [ 3*dx, 0 ], [ 1 1 ] )...
%                                               nearestTo( nodes, [ 4*dx, 0 ], [ 1 1 ] )...
%                                               nearestTo( nodes, [ 5*dx, 0 ], [ 1 1 ] )...
%                                               nearestTo( nodes, [ 6*dx, 0 ], [ 1 1 ] )...
%                                               nearestTo( nodes, [ 7*dx, 0 ], [ 1 1 ] )...
%                                               nearestTo( nodes, [ 8*dx, 0 ], [ 1 1 ] )...
%                                               nearestTo( nodes, [ 9*dx, 0 ], [ 1 1 ] )...
%                                               nearestTo( nodes, [ lx,   0 ], [ 0 1 ] ) ...
%                                               nearestTo( nodes, [ lx-dx, 0 ], [ 0 1 ] ) ...
%                                               nearestTo( nodes, [ lx-2*dx, 0 ], [ 0 1 ] )...
%                                               nearestTo( nodes, [ lx-3*dx, 0 ], [ 0 1 ] )...
%                                               nearestTo( nodes, [ lx-4*dx, 0 ], [ 0 1 ] )...
%                                               nearestTo( nodes, [ lx-5*dx, 0 ], [ 0 1 ] )...
%                                               nearestTo( nodes, [ lx-6*dx, 0 ], [ 0 1 ] )...
%                                               nearestTo( nodes, [ lx-7*dx, 0 ], [ 0 1 ] )...
%                                               nearestTo( nodes, [ lx-8*dx, 0 ], [ 0 1 ] )...
%                                               nearestTo( nodes, [ lx-9*dx, 0 ], [ 0 1 ] )];


  supports  = [ nearestTo( nodes, [ 0, 0 ], [ 1 1 ] ) ...
                                               nearestTo( nodes, [ dx, 0 ], [ 1 1 ] ) ...
                                               nearestTo( nodes, [ 2*dx, 0 ], [ 1 1 ] )...
                                               nearestTo( nodes, [ 3*dx, 0 ], [ 1 1 ] )...
                                               nearestTo( nodes, [ lx,   0 ], [ 0 1 ] ) ...
                                               nearestTo( nodes, [ lx-dx, 0 ], [ 0 1 ] ) ...
                                               nearestTo( nodes, [ lx-2*dx, 0 ], [ 0 1 ] )...
                                               nearestTo( nodes, [ lx-3*dx, 0 ], [ 0 1 ] ) ];


% supports  = [ atLine( nodes, 1, 0.0, [1 0] ) atLine( nodes, 1, lx, [0 1] ) ];

q = 5000; % [N]
Pq = q * ly * profile.h / 4; 

% Probablistic load definition

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

P( 2 * closestNode( nodes, [ lx / 2    ly ] ) - 1) = Px; % [N]
P( 2 * closestNode( nodes, [ lx / 2 + dx   ly ] )- 1 ) = Px; % [N]
P( 2 * closestNode( nodes, [ lx / 2 - dx   ly ] )- 1 ) = Px; % [N]

P( 2 * closestNode( nodes, [ lx / 2    ly ] ) ) = Py; % [N]
P( 2 * closestNode( nodes, [ lx / 2 + dx   ly ] ) ) = Py; % [N]
P( 2 * closestNode( nodes, [ lx / 2 - dx   ly ] ) ) = Py; % [N]

mP = [mP P];

P( 2 * closestNode( nodes, [ lx / 2    ly ] ) - 1) = -Px; % [N]
P( 2 * closestNode( nodes, [ lx / 2 + dx   ly ] )- 1 ) = -Px; % [N]
P( 2 * closestNode( nodes, [ lx / 2 - dx   ly ] )- 1 ) = -Px; % [N]

mP = [mP P];

P( 2 * closestNode( nodes, [ lx / 2    ly ] ) - 1) = 0; % [N]
P( 2 * closestNode( nodes, [ lx / 2 + dx   ly ] )- 1 ) = 0; % [N]
P( 2 * closestNode( nodes, [ lx / 2 - dx   ly ] )- 1 ) = 0; % [N]

P( 2 * closestNode( nodes, [ lx / 2    ly ] ) ) = P0; % [N]
P( 2 * closestNode( nodes, [ lx / 2 + dx   ly ] ) ) = P0; % [N]
P( 2 * closestNode( nodes, [ lx / 2 - dx   ly ] ) ) = P0; % [N]

mP = [mP P];

tic

params = multiParamsTopologtOptAnalysis( 'plasticBeam10_Up_195', nodes, elems, elemClassL4, mP(:,3), material, profile, supports, x, lx, ly, nx, ny, 0.95, [0.75 1.0 1.25 1.5 2.0], [2 4 6] )


% [ ~, ~, c ] = planeStressPlasticAnalysisCapacity( elemClassL4, nodes, elems, mP(:,3), material, profile, supports, x )
% 
% c = 0.8125;
% 
% parfor k=1:4
%     if k==1
%         x07 = plasticTopologyOptimizationD( 'penalTest_s_07_2_10_095', nodes, elems, elemClassL4, 0.2 * c * mP(:,3), material, profile, supports, x, lx, ly, nx, ny, 0.7, 2, 10 , 0.002 );
%     end
%     if k==2
%         x1  = plasticTopologyOptimizationD( 'penalTest_s_10_2_10_095', nodes, elems, elemClassL4, 0.4 * c * mP(:,3), material, profile, supports, x, lx, ly, nx, ny, 1.0, 2, 10 , 0.002 );
%     end
%     if k==3
%         x2  = plasticTopologyOptimizationD( 'penalTest_s_12_2_10_095', nodes, elems, elemClassL4, 0.6 * c * mP(:,3), material, profile, supports, x, lx, ly, nx, ny, 1.2, 2, 10 , 0.002 );
%     end
%     if k==4
%         x5  = plasticTopologyOptimizationD( 'penalTest_s_15_2_10_095', nodes, elems, elemClassL4, 0.95 * c * mP(:,3), material, profile, supports, x, lx, ly, nx, ny, 1.5, 2, 10 , 0.002 );
%     end
% end

toc

