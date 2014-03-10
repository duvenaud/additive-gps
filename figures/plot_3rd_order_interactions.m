function plot_3rd_order_interactions( X, y, hyp, covfunc, meanfunc, likfunc, inference, d1, d2, d3 )
% Generate some plots showing 1st-order interactions and data.
%
% David Duvenaud
% April 2011
% ===============

%addpath(genpath([pwd '/../']))
%addpath('../../utils/');


% View the 1-D functions.
% make additive predictions.
% generate a grid

granularity = 15;

%covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel

[N,D] = size(X);
       
minx1 = min(X(:,d1));
maxx1 = max(X(:,d1));
minx2 = min(X(:,d2));
maxx2 = max(X(:,d2));
minx3 = min(X(:,d3));
maxx3 = max(X(:,d3));        
range1 = linspace( minx1, maxx1, granularity );
range2 = linspace( minx2, maxx2, granularity );
range3 = linspace( minx3, maxx3, granularity );

% Make a dataset that only varies along two dimensions.
[A,B,C] = meshgrid(range1, range2, range3 );
xstar = Inf(length(A(:)),D);
xstar( :, d1 ) = A(:);
xstar( :, d2 ) = B(:);
xstar( :, d3 ) = C(:);

predictions_add = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, xstar);
predictions_add = reshape(predictions_add, granularity, granularity, granularity);
plot_3d_density( predictions_add, range1, range2, range3 ); hold on;
%surf( A, B, reshape(predictions_add, length( range1), length( range2) ) ); hold on;
%plot3( X(:,d1), X(:,d2), y, 'r.' ); hold on;
%title(sprintf('d%d vs d%d', d1, d2 ));

% for each datapoint, find out how much the other dimension contributed.
xstar2 = X;
xstar2( :, d1 ) = Inf( size(X,1), 1);
xstar2( :, d2 ) = Inf( size(X,1), 1);
xstar2( :, d3 ) = Inf( size(X,1), 1);
data_minus_2nd_d = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, xstar2);
%plot( X(:,1), y - data_minus_2nd_d + mean, 'b.' ); hold on;
plot3( X(:,d1), X(:, d2), y - data_minus_2nd_d, 'bo' ); hold on;

%save2pdf('1st_order_censored_d1.pdf', gcf, 600, true );


%[a,b] = meshgrid(range, range);
