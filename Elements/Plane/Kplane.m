## Copyright (C) 2017 Piotrek
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} Kplane (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Piotrek <piotrek@Cosmos>
## Created: 2017-07-27

function [ Ke ] = Kplane( elemX, D )

  Wo = 0;
  Wa = 1 - Wo / 4;
  alpha =  1 / sqrt( ( 3 * Wa ) );

  gw = ones(4,1);
  gp = [ -alpha alpha alpha -alpha; -alpha -alpha alpha alpha ];

  Ke = stifnessMatrixNumerical( elemX, gp, gw, @gradL4, @jacobiPlane2D, @matB_2D, D );
  
end
