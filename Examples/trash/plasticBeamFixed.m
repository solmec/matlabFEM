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
nelem = size(elems,1);

x = ones( size(elems, 1), 1 ); % thickness density
erased_elems = false( size(elems,1), 1 );
change = 1;

supports  = [ atLine( nodes, 1, 0.0, [1 1] ) atLine( nodes, 1, lx, [1 0] ) ];
              
%supports = [ 1 1 1; 10 1 0; 19 1 0 ];
%

iter = 0;
c    = 0.01;
nRemoved = 20;


q = 5000; % [N]
Pq = q * ly * profile.h / 4; 

%Pcant = -63.0E+06;

Pcant = -10.0E+06;
%Pcant = -2.1703e+06

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
%P( 2 * closestNode( nodes, [ lx/2-dx ly/2 ] ) ) = Pcant; % N]
for i=0:dx:lx
    P( 2 * closestNode( nodes, [ i ly/2 ] ) ) = Pcant; % [N]
end

%P( 2 * closestNode( nodes, [ lx/2+dx ly/2 ] ) ) = Pcant; % [N]

% solving nonlinear elasto plastic problem

% solving elastoplastic problem
%[ ~, ~, c ] = planeStressPlasticAnalysisCapacity( elemClassL4, nodes, elems, P, material, profile, supports, x )
c = 0.2344;
while true
    
iter = iter+1;

[ u, GPdatas, corr ] = incrementalPlaneStressPlasticAnalysis( elemClassL4, nodes, elems, 0.01*c*P, material, profile, supports, x );

%figure, plotMeshPlastic( nodes, elems, u, elemClassL4, GPdatas );
%title(['Iter: ', num2str(iter),', Load capacity: ', num2str(c) ]);

%return;

if ( corr == false )
    x            = xPrev;
    erased_elems = erasedPrev;
    GPdatas      = GPdatasPrev;
    disp(['Analysis finished correctly.' ]);
    
    colormap(gray), imagesc( flipud(-reshape(x,nx,ny)')), axis image, axis tight, axis off
    title(['Iter: ', num2str(iter),', nr: ', num2str(nRemoved),', Volume: ' num2str(V), ' m^3']);
    saveas(gcf,['plasticBeamFixed3_', num2str(iter),'.png'] );
    
%    subplot(2,1,1), colormap('default'), imagesc(flipud(reshape(ais, nx, ny)')), 
%view(2), axis image, axis off, colorbar
%title(['Iter: ', num2str(iter),', Stress distribution']);

%contour( reshape(ais,nx,ny)', 'ShowText', 'on'),
%subplot(2,1,2), colormap(gray), imagesc( -flipud(reshape(x,nx,ny)')), axis image, axis tight, axis off
%title(['Iter: ', num2str(iter),', nr: ', num2str(nRemoved),', Volume: ' num2str(V), ' m^3']);
    
    return;
    
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
x( elem_list ) = max( 0.01*profile.h, x( elem_list ) .* ais( elem_list).^2.0 ); % 1.5 is perfect!!!!
V = lx*ly*profile.h*sum(x)/nx/ny;

% % ------ Removing selected elements ------
% [ nodes, elems, nodes_list ] = eraseElems( nodes, elems, elem_list );
% GPdatas( elem_list ) = [];

% figure, plot( nodes(:,1), nodes(:,2),'.'), hold on, axis image
% for i=1:size( elems, 1), 
%     fill( nodes( elems(i, :), 1), nodes( elems(i, :), 2), 1e5*ais(i)), 
% end

%subplot(1,3,1), plotMeshPlastic( nodes, elems, u, elemClassL4, GPdatas );
%title(['Iter: ', num2str(iter),', Load capacity: ', num2str(c) ]);


%subplot(2,1,1), colormap('default'), imagesc(flipud(reshape(ais, nx, ny)')), 
%view(2), axis image, axis off, colorbar
%title(['Iter: ', num2str(iter),', Stress distribution']);

%contour( reshape(ais,nx,ny)', 'ShowText', 'on'),
%subplot(2,1,2), colormap(gray), imagesc( -flipud(reshape(x,nx,ny)')), axis image, axis tight, axis off
%title(['Iter: ', num2str(iter),', nr: ', num2str(nRemoved),', Volume: ' num2str(V), ' m^3']);

colormap(gray), imagesc( flipud(-reshape(x,nx,ny)')), axis image, axis tight, axis off
title(['Iter: ', num2str(iter),', nr: ', num2str(nRemoved),', Volume: ' num2str(V), ' m^3']);
saveas(gcf,['plasticBeamFixed2_', num2str(iter),'.png'] );

pause(1e-6);



end;