function [ ec ] = elemClassNew( name )

    if ( name == 'IzoparamL4' ) 
      Wo = 0;
      Wa = 1 - Wo / 4;
      alpha =  1 / sqrt( ( 3 * Wa ) );
      ec.gw  = ones(4,1);
      ec.gp  = [ -alpha alpha alpha -alpha; -alpha -alpha alpha alpha ];
      ec.sf  = shapeFNL4New( ec.gp );
      ec.dN  = gradL4New( ec.gp );
      ec.B   = @matB_2DNew;
      ec.J   = @jacobiPlane2DNew;
      ec.dksi = 1;
      return;
    end
    if ( name == 'IzoparamL9' ) 
      
      w1 = 5.0/9.0;
      w2 = 8.0/9.0;
      w3 = 5.0/9.0;
      
      x1 = -0.774596669241483;
      x2 =  0.0;              
      x3 =  0.774596669241483;
      
     
      ec.gw  = [ w1*w1; w2*w1; w3*w1; w1*w2; w2*w2; w3*w2; w1*w3; w2*w3; w3*w3  ];
      ec.gp  = [ x1 x2 x3 x1 x2 x3 x1 x2 x3; x1 x1 x1 x2 x2 x2 x3 x3 x3 ];
      
      ec.sf  = zeros(1,9,9);
      ec.sf(:,:,1:9)  = shapeFNL9( ec.gp(1:9) );
      ec.dN     = zeros(2,9,9);
      ec.dN(:,:,1:9)  = gradL4( ec, gp(1:9) );
      
      ec.sf  = @shapeFNL9;
      ec.dN  = @gradL9;
      ec.B   = @matB_2DNew;
      ec.J   = @jacobiPlane2DNew;
      ec.dksi = 1;
      return;
    end
end