function plot_2nd_order_interactions( X, y, hyp, covfunc, meanfunc, likfunc, inference, d1, d2 )
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

granularity = 20;

%covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel

[N,D] = size(X);

mean = feval( meanfunc{:}, hyp.mean, X );

%max_d = D;

%for d1 = 1:max_d
%    for d2 = d1 + 1:max_d
        %subplot(max_d, max_d, ( d1 - 1 ) * max_d + d2);
  %      figure;
        
        minx1 = min(X(:,d1));
        maxx1 = max(X(:,d1));
        minx2 = min(X(:,d2));
        maxx2 = max(X(:,d2));
        range1 = linspace( minx1, maxx1, granularity );
        range2 = linspace( minx2, maxx2, granularity );

        % Make a dataset that only varies along two dimensions.
        [A,B] = meshgrid(range1, range2 );
        xstar = Inf(length(A(:)),D);
        xstar( :, d1 ) = A(:);
        xstar( :, d2 ) = B(:);

        predictions_add = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, xstar);

        surf( A, B, reshape(predictions_add, length( range1), length( range2) ) ); hold on;
        % 'EdgeColor','none','LineStyle','none' ); hold on;
        %plot3( X(:,d1), X(:,d2), y, 'r.' ); hold on;
        %title(sprintf('d%d vs d%d', d1, d2 ));
        
        % for each datapoint, find out how much the other dimension contributed.
        xstar2 = X;
        xstar2( :, d1 ) = Inf( size(X,1), 1);
        xstar2( :, d2 ) = Inf( size(X,1), 1);
        data_minus_2nd_d = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, xstar2);
        %plot( X(:,1), y - data_minus_2nd_d + mean, 'b.' ); hold on;
        plot3( X(:,d1), X(:, d2), y - data_minus_2nd_d, 'b.' ); hold on;
%    end
%end

%save2pdf('1st_order_censored_d1.pdf', gcf, 600, true );


%[a,b] = meshgrid(range, range);
