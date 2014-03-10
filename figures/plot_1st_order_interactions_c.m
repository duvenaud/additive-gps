function plot_1st_order_interactions( X, y, hyp, covfunc, meanfunc, likfunc, inference )
% Generate some plots showing 1st-order interactions and data.
%
% David Duvenaud
% April 2011
% ===============

granularity = 100;
[N,D] = size(X);
mean = feval( meanfunc{:}, hyp.mean, X );

for d = 1:D
    subplot(ceil(sqrt(D)), ceil(sqrt(D)), d )
    
    % generate a grid
    minx = min(X(:,d));
    maxx = max(X(:,d));
    range = linspace( minx, maxx, granularity );
    
    % Make a dataset that only varies along one dimension.
    xstar = Inf(granularity,D);
    xstar( :, d ) = range';
    
    [ymu ys2 fmu fs2 lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, xstar);
    predictions_add = ymu;
    
    %plot( range, sin(range.*2 + 1), 'g-' ); hold on;
    plot( range, predictions_add, 'g-' ); hold on;
    plot( X(:,d), y, 'r.' ); hold on;
    %title(sprintf('d%d', d));
    
    % for each datapoint, find out how much the other dimensions contributed.
    xstar2 = X;
    xstar2( :, d ) = Inf( size(X,1), 1);
    [ymu ys2 fmu fs2 lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, xstar2);    
    other_d_pred = (1+erf(fmu/sqrt(2)))/2;
    %plot( X(:,d), y - other_d_pred, 'b.' ); hold on;
    plot( X(:,d), y - other_d_pred, 'b.' ); hold on;
    
    % for each datapoint, find out how much the other dimensions and orders contributed.
    if 0
        xstar2 = X;
        xstar2( :, d ) = Inf( size(X,1), 1);
        hyp2 = hyp;
        hyp2.cov(end-D+2:end) = -Inf;
        [ymu ys2 fmu fs2 lp] = gp(hyp2, inference, meanfunc, covfunc, likfunc, X, y, xstar2);    
        other_d_same_order_pred = fmu;
        xstar2 = X;
        %xstar2( :, d ) = Inf( size(X,1), 1);
        hyp2 = hyp;
        hyp2.cov(end-D+1) = -Inf;
        [ymu ys2 fmu fs2 lp] = gp(hyp2, inference, meanfunc, covfunc, likfunc, X, y, xstar2);            
        other_order_pred = fmu
        plot( X(:,d), y - other_d_same_order_pred - other_order_pred, 'g.' ); hold on;        
    end
end

legend({'Posterior mean', 'data', 'controlling for other dimensions'}, 'Location', 'Best')
%save2pdf('1st_order_censored_d1.pdf', gcf, 600, true );

