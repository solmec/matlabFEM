function [ nitems ] = readTex( filename )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
close all;
fid = fopen( filename );
cmd = '[\\][a-z]*';
nmb = '[+-]?([0-9]*[.])?[0-9]+';

cpoint=[ 0 0 ];
ppoint=[ 0 0 ];

figure, hold on, axis image, axis off

X = [];

first_path = true;

bind  = [ ];
npt   = 0;

tline = fgets( fid );
while ischar( tline );
    command = regexp(tline,cmd,'match');
    numbers = regexp(tline,nmb,'match');
    params  = cellfun(@str2num,numbers);
    if ( ( size( command, 2 ) == 1 )  )
        if ( strcmp(command{1},'\lineto') )
            plot( [cpoint(1) params(1)], [cpoint(2) params(2)], 'r-');
            cpoint = params;
            X = [X; params];
            npt = npt + 1;
        end
        if ( strcmp(command{1},'\moveto') )
            cpoint = params;
            ppoint = params;
            X = [X; params];
            npt = npt + 1;
            bind = [bind npt];
        end
        if ( strcmp(command{1},'\curveto') )
            x = [ cpoint(1,1) params(1:2:5) ];
            y = [ cpoint(1,2) params(2:2:6) ];
            B = bernsteinMatrix( 3, 0:1/4:1);
            bezierPnt = B*[x' y'];
            
            cpoint=[ params(1,5) params(1,6) ];
            plot( bezierPnt(:,1), bezierPnt(:,2), 'b.-');
            X = [X; bezierPnt];
            npt = npt + size(bezierPnt,1);
            %plot( x, y, 'ro'), % control point ploting
        end
        if ( strcmp(command{1},'\closepath') )
                %ployt( [cpoint(1) ppoint(1)], [cpoint(2) ppoint(2)], 'r-');
            %disp('closepath'); % ...
        end
    end
    tline = fgets(fid);
end

fclose(fid);
bind = [bind size(X,1)];
Cbind = [];
for k=2:size(bind,2)-1
    for l=bind(k):bind(k+1)-2
        Cbind = [ Cbind; [ l l+1 ] ];
    end
    Cbind = [ Cbind; [ bind(k+1)-1 bind(k) ] ];
end

plot ( X(bind,1), X(bind,2),'r*');
figure, hold on, axis off; 

dt = delaunayTriangulation(X, Cbind)
inside = not(dt.isInterior());
% Construct a triangulation to represent the domain triangles.
tr = triangulation(dt(inside, :), dt.Points);
CC = incenter(tr);
triplot( tr );
plot ( CC(:,1), CC(:,2),'r.');


NP = [ dt.Points(); CC ];
tr2 =  delaunayTriangulation( NP, Cbind );
figure, hold on, axis off; 
triplot( tr2 );

model = createpde(1);
geometryFromMesh(model,X,Cbind);
generateMesh(model);
pdeplot(model);

end

