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
range = -17:.6:17;
[X,Y,Z] = meshgrid(range, range, range );
xstar = [X(:) Y(:) Z(:)];

a = .9;

first_order_variance = 1.07;
second_order_variance = 25;
third_order_variance = 1000009;

figure(1);  
%covfunc = {'covADD',{[1,2,3],'covSEiso'}};
%hyp.cov = log([1,1,1,1,1,1,first_order_variance, second_order_variance, third_order_variance]);
covfunc = {'covADD',{[2,3],'covSEiso'}};
hyp.cov = log([1,1,1,1,1,1, second_order_variance, third_order_variance]);

V = feval(covfunc{:}, hyp.cov, xstar, [0,0,0]);
V = reshape(V, length(range),length(range),length(range));


for a = 0.001:.01:1;
    draw_isosurface( X, Y, Z, V, a, range); hold on;
end
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
