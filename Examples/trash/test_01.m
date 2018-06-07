% FEM test file

mat.E   = 34.474E+09;  % [Pa]
mat.nu  = 0.11;
mat.rho = 568.7; % [kg/m^3]
mat.sy  = 210E+06; % [Pa]

profile.h = 0.2286; % [m]

elemX = [ 0 0; 2 0; 2 2; 0 2 ];

addpath ("./Elements/")
addpath ("./Mesh/")
addpath ("./Elements/Plane")

K = Kplane( elemX, matDplaneIzo( mat.E, mat.nu, profile.h ), @gradL4 );

pattern = elemPattern('L4');

[ nodes, elems ] = rectMesh2D( 8, 2, 0, 0, 63, 15, pattern );
nodes

nodes( elems(2,:), : )

for k=1:size(elems,1)
  Kplane( nodes( elems(k,:), : ), matDplaneIzo( mat.E, mat.nu, profile.h ), @gradL4 )
end  

