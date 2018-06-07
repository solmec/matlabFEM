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

lx=30.00; 
ly=15.24;

nx = 80;
ny = 40;

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
c    = 0.5;

V = lx*ly*profile.h*sum(x)/nx/ny;
nRemoved = 20;

while true

    iter = iter+1;
    
nelem = size(elems,1);

 supports  = [ atLine( nodes, 1, 0.0, [1 0] ) nearestTo( nodes, [ lx, 0 ], [ 0 1 ] ) ...
                                              nearestTo( nodes, [ lx-dx, 0 ], [ 0 1 ] ) ...
                                              nearestTo( nodes, [ lx-2*dx, 0 ], [ 0 1 ] )...
                                              nearestTo( nodes, [ lx-3*dx, 0 ], [ 0 1 ] )...
                                              nearestTo( nodes, [ lx-4*dx, 0 ], [ 0 1 ] )...
                                              nearestTo( nodes, [ lx-5*dx, 0 ], [ 0 1 ] )...
                                              nearestTo( nodes, [ lx-6*dx, 0 ], [ 0 1 ] )...
                                              nearestTo( nodes, [ lx-7*dx, 0 ], [ 0 1 ] )...
                                              nearestTo( nodes, [ lx-8*dx, 0 ], [ 0 1 ] )...
                                              nearestTo( nodes, [ lx-9*dx, 0 ], [ 0 1 ] )];


% supports  = [ atLine( nodes, 1, 0.0, [1 0] ) atLine( nodes, 1, lx, [0 1] ) ];

q = 5000; % [N]
Pq = q * ly * profile.h / 4; 

P = zeros( 2 * size( nodes,1), 1 );
%P( 2 * closestNode( nodes, [ lx ly   ] ) -1 ) = -  Pq; % [N]
%P( 2 * closestNode( nodes, [ lx ly/2 ] ) -1 ) = -2*Pq; % [N]
%P( 2 * closestNode( nodes, [ lx 0    ] ) -1 ) = -  Pq; % [N]

P0 = -20.0E+06;

P( 2 * closestNode( nodes, [ 0    ly ] ) ) = P0; % [N]
P( 2 * closestNode( nodes, [ dx   ly ] ) ) = P0; % [N]
P( 2 * closestNode( nodes, [ 2*dx ly ] ) ) = P0; % [N]

% solving elastoplastic problem
%[ ~, ~, c ] = planeStressPlasticAnalysisCapacity( elemClassL4, nodes, elems, P, material, profile, supports, x )


[ u, GPdatas, corr ] = incrementalPlaneStressPlasticAnalysis( elemClassL4, nodes, elems, c*P, material, profile, supports, x );

%figure, plotMeshPlastic( nodes, elems, u, elemClassL4, GPdatas );
%title(['Iter: ', num2str(iter),', Load capacity: ', num2str(c) ]);

%return;

if ( corr == false )
    x            = xPrev;
    erased_elems = erasedPrev;
    GPdatas      = GPdatasPrev;
    disp(['Analysis finished correctly.' ]);
    return
else
    xPrev       = x;
    erasedPrev  = erased_elems;
    GPdatasPrev = GPdatas;
end
% nRemoved = round(0.01*(nelem - sum( erased_elems)));
% if mod( nRemoved,2)==1
%     nRemoved = nRemoved+1;
% end

% GPdatas = GPdatasnew;

% Counting plastic gauss point
% nPlastGP = 0;
% for i=1:nelem
%     nPlastGP = nPlastGP + sum(GPdatas(i).dg>0);
% end
% nRemoved = round(100*(4*nelem-nPlastGP)/(4*nelem))

% Bisection of power two
% if ( corr == false )
%     x = xPrev;
%     erased_elems = erasedPrev;
%     GPdatas = GPdatasPrev;
%     if nRemoved <1
%         disp(['Analysis finished correctly.' ]);
%         return;
%     else
%        nRemoved = nRemoved / 2;
%     end
% else
%     if (nRemoved < 2)
%         disp(['Analysis finished correctly.' ]);
%         return;
%     end
%     xPrev = x;
%     erasedPrev = erased_elems;
%     GPdatasPrev = GPdatas;
% end

[ elem_list, erased_elems, ais ] = elem2del3( nx, ny, erased_elems, GPdatas, material, nRemoved, x );

% On-off approach
%x( elem_list ) = 0.0001*profile.h;
% Proportional approach
x( elem_list ) = max( 0.01*profile.h, x( elem_list ).*ais( elem_list).^2.0); % 1.5 is perfect!!!!
V = lx*ly*profile.h*sum(x)/nx/ny;

% % ------ Removing selected elements ------
% [ nodes, elems, nodes_list ] = eraseElems( nodes, elems, elem_list );
% GPdatas( elem_list ) = [];

% figure, plot( nodes(:,1), nodes(:,2),'.'), hold on, axis image
% for i=1:size( elems, 1), 
%     fill( nodes( elems(i, :), 1), nodes( elems(i, :), 2), 1e5*ais(i)), 
% end

%figure, plotMeshPlastic( nodes, elems, u, elemClassL4, GPdatas );
%title(['Iter: ', num2str(iter),', Load capacity: ', num2str(c) ]);

%figure, surf( reshape(ais, nx, ny)', 'LineStyle','none'), 
%view(2), axis image, axis off, colorbar
%title(['Iter: ', num2str(iter),', Stress distribution']);

%contour( reshape(ais,nx,ny)', 'ShowText', 'on'),
subplot(1,2,1), colormap('default'), imagesc(reshape(ais, nx, ny)'), 
view(2), axis image, axis off, colorbar
%title(['Iter: ', num2str(iter),', Stress distribution']);

%contour( reshape(ais,nx,ny)', 'ShowText', 'on'),
subplot(1,2,2), colormap(gray), imagesc( -reshape(x,nx,ny)'), axis image, axis tight, axis off
%title(['Iter: ', num2str(iter),', nr: ', num2str(nRemoved),', Volume: ' num2str(V), ' m^3']);
pause(1e-6);

end
