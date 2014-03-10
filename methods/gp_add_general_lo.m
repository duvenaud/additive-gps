function [predictions, log_prob_y, model] = gp_add_general_lo( likfunc, inference, Xtrain, ytrain, Xtest, ytest, max_order )
% Length only, starting with all orders.

sub_kernel = 'covSEiso_length'

hhp = common_gp_parameters();     % Use a common set of hyper-hyper-priors.
[N,D] = size(Xtrain);
if nargin < 7; max_order = hhp.max_order; end

R = min(D, max_order);  % Max allowable degree of interaction.
fprintf('\nOptimizing additive hyperparameters...');
fprintf('\nMaximum interaction order: %d...\n', R );

%meanfunc = {'meanSum',{'meanConst','meanLinear'}};
meanfunc = {'meanConst'};
covfunc = { 'covADD',{1:R,sub_kernel} };

% Randomly draw hyperparameters.
%hyp.mean = [0; ones(D,1)];
hyp.mean = [0];
hyp.lik = ones(1,eval(likfunc())).*log(hhp.noise_scale);    
log_lengthscales = log(hhp.length_scale.*gamrnd(hhp.gamma_a, hhp.gamma_b,1,D));
%log_variances = log(hhp.sd_scale .* gamrnd(hhp.gamma_a, hhp.gamma_b,1,D));

% Combine everything.
hyp.cov = reshape(log_lengthscales,1,D);
% Save intialize hyperparameters.
model.init_hypers = hyp;

% Figure out how many iterations to run.
total_iters = hhp.max_iterations;

scaling_factors = NaN(1,R);
for d = 1:R
    % Compute the sum of all the cross terms at a given order.  This tells
    % us the magnitude of the contribution of each order before scaling by
    % the order variance terms.
    scaling_factors(d) = covADD({d,sub_kernel}, [reshape(log_lengthscales,1,D), log(1)], zeros(1,D));
end

% Initialize the order contributions so that they have a chance.
log_order_variances = [log(ones(1,R) .* gamrnd(hhp.gamma_a, hhp.gamma_b,1,R) ...
                       .* hhp.add_sd_scale ./ scaling_factors)];

% Combine everything.                   
hyp.cov = [ reshape(log_lengthscales,1,D), log_order_variances];
[ lengthscales, scaled_orders] = sort_additive_hypers_lo(D, hyp.cov)

% Save intialize hyperparameters.
model.init_hypers = hyp;

% Fit the model.
[cur_hyp, nlZ] = minimize(hyp, @penalized_gp, -total_iters, ...
               inference, meanfunc, covfunc, likfunc, Xtrain, ytrain);

[ lengthscales, scaled_orders] = sort_additive_hypers_lo(D, cur_hyp.cov)
model.hypers = cur_hyp;
model.hhp = hhp;
model.marginal_log_likelihood_train = -nlZ(end);

% Make predictions.
[ymu, ys2, predictions, fs2, log_prob_y] = ...
    gp(model.hypers, inference, meanfunc, covfunc, likfunc, Xtrain, ytrain, Xtest, ytest);
