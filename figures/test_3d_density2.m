function test_3d_density
% Make figures of additive kernels in 3 dimensions
%
% April 2011
% =================

% To be run from the figures/ directory.
%cd( 'figures/' );
addpath(genpath([pwd '/../']))
addpath('../../utils/');

clear all
close all

dpi = 200;

% X,Y,Z iz the meshgrid and V is my function evaluated at each meshpoint
range = -1:.05:1;
range = range .* 6;
[X,Y,Z] = meshgrid(range, range, range );
xstar = [X(:) Y(:) Z(:)];

a = .9;

first_order_variance = 1.07;
second_order_variance = 1000000;
third_order_variance = .001;

figure(1);  
%covfunc = {'covADD',{[1,2,3],'covSEiso'}};
%hyp.cov = log([1,1,1,1,1,1,first_order_variance, second_order_variance, third_order_variance]);
covfunc = {'covADD',{[2,3],'covSEiso'}};
hyp.cov = log([1,1,1,1,1,1, second_order_variance, third_order_variance]);

V = feval(covfunc{:}, hyp.cov, xstar, [0,0,0]);
V = min(V, 0.2*max(V(:)));
V = reshape(V, length(range),length(range),length(range));


%for a = 0.001:.01:1;
%    draw_isosurface( X, Y, Z, V, a, range); hold on;
%end

dx = range(2) - range(1);
cmap = colormap;

% normalize V to be between 0 and 1;
maxV = max(V(:));
minV = min(V(:));
V = V - minV;
V = V ./ ( maxV - minV);

figure(1);
hist(V(:));

figure(2);
for i = 1:length(range)
    for j = 1:length(range)
        for k = 1:length(range)     
            cur_val = V(i,j,k);
            cur_color = cmap(floor(cur_val * (length(cmap) - 1) + 1),:);
            voxel( [range(i), range(j), range(k)], [dx dx dx], cur_color, cur_val/10);
        end
    end
end
view(3); daspect([1 1 1]); %axis tight;
axis( [ min(range), max(range),min(range), max(range),min(range), max(range)]);

end

function draw_isosurface( X, Y, Z, V, a, range)
    cmap = colormap;
    cur_color = cmap(ceil(a * length(cmap)),:);
    p = patch(isosurface(X,Y,Z,V,a / max(V(:)))); % isosurfaces at max(V)/a
    isonormals(X,Y,Z,V,p); % plot the surfaces
    set(p,'FaceColor',cur_color,'EdgeColor','none'); % set colors
    camlight; camlight(-80,-10); lighting gouraud; 
    alpha(.1); % set the transparency for the isosurfaces
    view(3); daspect([1 1 1]); %axis tight;
    axis( [ min(range), max(range),min(range), max(range),min(range), max(range)]);
    %axis off;
    
    
end
