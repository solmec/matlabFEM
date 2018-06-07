%% Copyright (C) 2017 Piotrek
%% 
%% This program is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 3 of the License, or
%% (at your option) any later version.
%% 
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%% 
%% You should have received a copy of the GNU General Public License
%% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*- 
%% @deftypefn {} {@var{retval} =} dStifnessMatrix (@var{input1}, @var{input2})
%%
%% @seealso{}
%% @end deftypefn
%%
%% Tangent matrix function for Stress Dependent problems with small deformation
%%
%% Author: Piotrek <piotrek@Cosmos>
%% Created: 2017-07-27

function [ Kt ] = tangentMatrixSD( elemX, elemClass, Dmat, Dtop, GPdata )
  ngp  = size( elemClass.gp, 2 );
  for i=1:ngp
    [ ~, ~, detJ, B ] = matB( elemClass, elemX, elemClass.gp(:,i) );
    Dt = Dtop( GPdata.stress(:,i), GPdata.dg(i), Dmat );
    dK = elemClass.gw(i) * elemClass.dksi * abs(detJ) * ( B' * Dt * B );

    if ( i == 1 ) 
        Kt = dK;
    else
        Kt = Kt + dK;
    end;
    
  end;
 
end
