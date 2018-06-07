function [ sf ] = elemPattern( name )

    if ( name == 'L4' ) 
      sf = [ 0 1 1 0; 0 0 1 1 ];
    end
    if ( name == 'L9' ) 
      sf = [ 0 2 2 0 1 2 1 0 1; 0 0 2 2 0 1 2 1 1 ];
    end
end