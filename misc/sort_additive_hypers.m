function [lengthscales, variances, scaled_order_variances] = sort_additive_hypers( D, log_cov )
% Take a vector of additive hyperparameters, and sort them into the various
% types.
%
% Assumes that the additive kernel is using a SE kernel with two
% parameters:  signal variance and lengthscale.
%
% Assumes that everything is in log.
%
% Assumes that the orders start at 1.
%
% Returns everything in normal units (not log space)
%
% David Duvenaud
% March 2011
% =============================

%cov = exp(log_cov);
lengthscales = exp(log_cov( 1:2:(2*D)));
variances = exp( 2.*log_cov( 2:2:(2*D)));
raw_order_variance = exp( 2.* log_cov( 2*D + 1:end));

nr = length(log_cov) - 2*D;   % Number of orders
for d = 1:nr    
    % Compute the sum of all the cross terms at a given order.  This tells
    % us the magnitude of the contribution of each order before scaling by
    % the order variance terms.
    scaling_factors(d) = covADD({d,'covSEiso'}, [log_cov(1:2*D), log(1)], zeros(1,D));
 end

% Rescale so their sum is equivalent to the ARD variance hyperparameter.
scaled_order_variances = raw_order_variance.*scaling_factors;
