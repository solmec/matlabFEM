function [ dg, ksi ] = NR4RetMap( sTr, FiTr, mat )


% (1) initial guess
    E  = mat.E;
    nu = mat.nu;
    G  = E / 2 / ( 1 + nu );
    dg  = 0;
    ksi = 0;
    A1 = ( sTr(1) + sTr(2) )^ 2;
    A2 = ( sTr(2) - sTr(1) )^ 2;
    A3 =  sTr(3)^ 2;

% (2) NR iterations

    fi = FiTr;
    while( abs(fi/FiTr) >= 1.0E-8 )
    
      H = 0;
      ksip = - A1 / (9*(1+E*dg/3/(1-nu))^3) * E / (1-nu)  - 2 * G * ( A2 + 4 * A3 ) / ( 1 + 2 * G * dg )^3;
    
      Hb = 0;
    
      Fip = 0.5 * ksip;
    
      dg = dg - fi / Fip;
    
% (3) check for convergence

      ksi =  A1 / 6 /  (1 + E * dg / 3 / (1-nu) )^2 +  ( 0.5 * A2 + 2 * A3 ) / (1+2*G*dg)^2;
      fi = 1/2*ksi - 1/3 * mat.sy^2;

    end;
    
end

