function [ ec ] = elemClass( name )

    if ( name == 'IzoparamL4' ) 
      Wo = 0;
      Wa = 1 - Wo / 4;
      alpha =  1 / sqrt( ( 3 * Wa ) );
      
      ec.gw  = ones(4,1);
      ec.gp  = [ -alpha alpha alpha -alpha; -alpha -alpha alpha alpha ];
      ec.sf  = @shapeFNL4;
      ec.dN  = @gradL4;
      ec.dNx = @dNx;
      ec.B   = @matB_2D;
      ec.J   = @jacobiPlane2D;
      ec.dksi = 1;
      return;
    end
    if ( name == 'L9' ) 
      sf = [ 0 2 2 0 1 2 1 0 1; 0 0 2 2 0 1 2 1 1 ];
    end
end