function plot_1st_order_interactions( X, y, hyp, covfunc, meanfunc, likfunc, inference, d )
% Generate some plots showing 1st-order interactions and data.
%
% David Duvenaud
% April 2011
% ===============

granularity = 200;
[N,D] = size(X);
%mean = feval( meanfunc{:}, hyp.mean, X );

%for d = 1:D
%    subplot(ceil(sqrt(D)), ceil(sqrt(D)), d )
    
    % generate a grid
    minx = min(X(:,d));
    maxx = max(X(:,d));
    range = linspace( minx, maxx, granularity );
    
    % Make a dataset that only varies along one dimension.
    xstar = Inf(granularity,D);
    xstar( :, d ) = range';
    
    plot( X(:,d), y, 'o', 'Marker', 'o', 'MarkerSize', 5, 'MarkerEdgeColor' , 'none', 'MarkerFaceColor' , [0 1 0 ] ); hold on;
        
    %title(sprintf('d%d', d));
    
    % for each datapoint, find out how much the other dimensions contributed.
    xstar2 = X;
    xstar2( :, d ) = Inf( size(X,1), 1);
    other_d_pred = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, xstar2);    
    plot( X(:,d), y - other_d_pred, 'o', 'Marker', 'o', 'MarkerSize', 5, 'MarkerEdgeColor' , 'none', 'MarkerFaceColor' , [0 0 1 ] ); hold on;

    
    [predictions_add ys2 fmu fs2] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, xstar);
        
    % Shift the mean line so that it agrees with the data.
    % This transformation is not meaningful, but it makes the
    % visualizations more interpretable to a casual observer.
    xstar_data = Inf(size(X));
    xstar_data( :, d ) = X(:,d);
    [pred_data ys2_data fmu fs2] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, xstar_data);
    offset = sum((y - other_d_pred - pred_data)./ys2_data)/sum(1./ys2_data);
    predictions_add = predictions_add + offset;
    
    plot( range, predictions_add, 'k-', 'Linewidth', 2 ); hold on;
    plot( range, predictions_add + ys2, 'b-' ); hold on;
    plot( range, predictions_add - ys2, 'b-' ); hold on;    
    
    % for each datapoint, find out how much the other dimensions and orders contributed.
    if 0
        xstar2 = X;
        xstar2( :, d ) = Inf( size(X,1), 1);
        hyp2 = hyp;
        hyp2.cov(end-D+2:end) = -Inf;
        other_d_same_order_pred = gp(hyp2, inference, meanfunc, covfunc, likfunc, X, y, xstar2);    
        xstar2 = X;
        %xstar2( :, d ) = Inf( size(X,1), 1);
        hyp2 = hyp;
        hyp2.cov(end-D+1) = -Inf;
        other_order_pred = gp(hyp2, inference, meanfunc, covfunc, likfunc, X, y, xstar2);            
        plot( X(:,d), y - other_d_same_order_pred - other_order_pred, 'g.' ); hold on;        
    end
%end

%legend('data', 'controlling for other dimensions', {'Posterior mean'}, 'Location', 'Best')
%save2pdf('1st_order_censored_d1.pdf', gcf, 600, true );

