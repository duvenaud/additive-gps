function draw_3d_kernels
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
range = -17:.3:17;
[X,Y,Z] = meshgrid(range, range, range );
xstar = [X(:) Y(:) Z(:)];

a = .9;

first_order_variance = 1.07;
second_order_variance = 25;
third_order_variance = 1000009;

covfunc = {'covADD',{[1,2,3],'covSEiso'}};
hyp.cov = log([1,1,1,1,1,1,first_order_variance, second_order_variance, third_order_variance]);
V = feval(covfunc{:}, hyp.cov, xstar, [0,0,0]);
V = reshape(V, length(range),length(range),length(range));
figure(1);  draw_isosurface( X, Y, Z, V, a, range);
save2pdf('3d_add_kernel_321.pdf', gcf, dpi );


covfunc = {'covADD',{[2,3],'covSEiso'}};
hyp.cov = log([1,1,1,1,1,1, second_order_variance, third_order_variance]);
V = feval(covfunc{:}, hyp.cov, xstar, [0,0,0]);
V = reshape(V, length(range),length(range),length(range));
figure(2); draw_isosurface( X, Y, Z, V, a, range);
save2pdf('3d_add_kernel_32.pdf', gcf, dpi );


covfunc = {'covADD',{[3],'covSEiso'}};
hyp.cov = log([1,1,1,1,1,1, third_order_variance]);
V = feval(covfunc{:}, hyp.cov, xstar, [0,0,0]);
V = reshape(V, length(range),length(range),length(range));
figure(3); draw_isosurface( X, Y, Z, V, a, range);
save2pdf('3d_add_kernel_3.pdf', gcf, dpi );

covfunc = {'covADD',{[2],'covSEiso'}};
hyp.cov = log([1,1,1,1,1,1, 25]);
V = feval(covfunc{:}, hyp.cov, xstar, [0,0,0]);
V = reshape(V, length(range),length(range),length(range));
figure(4); draw_isosurface( X, Y, Z, V, a, range);
save2pdf('3d_add_kernel_2.pdf', gcf, dpi );

covfunc = {'covADD',{[1],'covSEiso'}};
hyp.cov = log([1,1,1,1,1,1,first_order_variance]);
V = feval(covfunc{:}, hyp.cov, xstar, [0,0,0]);
V = reshape(V, length(range),length(range),length(range));
figure(5); draw_isosurface( X, Y, Z, V, a, range);
save2pdf('3d_add_kernel_1.pdf', gcf, dpi );


% Crop the figures.
system('pdfcrop --bbox ''75 25 375 325'' --verbose 3d_add_kernel_1.pdf 3d_add_kernel_1.pdf');
system('pdfcrop --bbox ''75 25 375 325'' --verbose 3d_add_kernel_2.pdf 3d_add_kernel_2.pdf');
system('pdfcrop --bbox ''75 25 375 325'' --verbose 3d_add_kernel_3.pdf 3d_add_kernel_3.pdf');
system('pdfcrop --bbox ''75 25 375 325'' --verbose 3d_add_kernel_32.pdf 3d_add_kernel_32.pdf');
system('pdfcrop --bbox ''75 25 375 325'' --verbose 3d_add_kernel_321.pdf 3d_add_kernel_321.pdf');

end

function draw_isosurface( X, Y, Z, V, a, range)
    p = patch(isosurface(X,Y,Z,V,a)); % isosurfaces at max(V)/a
    isonormals(X,Y,Z,V,p); % plot the surfaces
    set(p,'FaceColor','red','EdgeColor','none'); % set colors
    camlight; camlight(-80,-10); lighting gouraud; 
    %alpha(.1); % set the transparency for the isosurfaces
    view(3); daspect([1 1 1]); %axis tight;
    axis( [ min(range), max(range),min(range), max(range),min(range), max(range)]);
    %axis off;
end
