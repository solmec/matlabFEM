function [ Dt ] = tangentD( s, dg, Dmat )

if ( dg == 0 ) 
    Dt = Dmat;
    return;
end    

P = 1/3 * [ 2 -1 0; -1 2 0; 0 0 6];
Em  = inv( inv(Dmat) + dg * P );
n   = Em * P * s;
alpha = 1 / ( s' * P * n );
Dt = Em - alpha * ( n * n' );
end

