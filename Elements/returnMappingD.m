function [ s, e, ep, dg ] = returnMappingD( en, epn, de, mat, x  )

% (i) elastic predictor

    G    = mat.E / 2 / ( 1 + mat.nu );
    D    = matDplaneIzo( mat.E, mat.nu );
    eTr  = en  + de; % trial strain
    epTr = epn; % permanent plastic strain
    sTr  =  D * eTr; % tral stress

% (iI) plasticity condition
    a1 = ( sTr(1) + sTr(2) )^ 2;
    a2 = ( sTr(2) - sTr(1) )^ 2;
    a3 = ( sTr(3) )^ 2;
    
    ksiTr = a1/6 + a2/2 + 2*a3;
    FiTr  = ksiTr/2 - mat.sy^2/3;
    
    if ( FiTr <= 0 )
        s     = sTr;
        e     = eTr;
        ep    = epTr;
        dg    = 0;
        ep(:) = 0;
    else
        [ dg, ksi ] = NR4RetMapD( sTr, FiTr, mat,x );
        A11 = 3 * (1-mat.nu) / (3*(1-mat.nu)+ mat.E*dg);
        A22 = 1 / (1+2*G*dg);
        A33 = A22;
        A   = [ 0.5*(A11+A22) 0.5*(A11-A22) 0; 0.5*(A11-A22) 0.5*(A11+A22) 0; 0 0 A33];
        s   = A * sTr;
        e   = inv( D ) * s;
        ep  = epTr + dg * sqrt( 2/3 * ksi ); 
        
    end
   
    
end

