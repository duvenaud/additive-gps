function [predictions, log_prob_y, model] = gp_ard_general( likfunc, inference, Xtrain, ytrain, Xtest, ytest, hyp )

hhp = common_gp_parameters();     % Use a common set of hyper-hyper-priors.
[N,D] = size(Xtrain);

covfunc = { 'covSEard' };   
%meanfunc = {'meanSum',{'meanConst','meanLinear'}};
meanfunc = {'meanConst'};

if nargin < 7
    % Randomly draw hyperparameters.
    %hyp.mean = [0; ones(D,1)];
    hyp.mean = 0;
    hyp.lik = ones(1,eval(likfunc())).*log(hhp.noise_scale);    
    log_lengthscales = log(hhp.length_scale.*gamrnd(hhp.gamma_a, hhp.gamma_b,1,D));
    log_variance = log(hhp.sd_scale);
    hyp.cov = [ log_lengthscales, log_variance ];
    
    % This is a bit hacky... on the first go around, use more iterations.
    max_iters = hhp.max_ard_init_iterations
else
    % Second time around, use the same as the other methods.
    max_iters = hhp.max_iterations
end


% Save intialize hyperparameters.
model.init_hypers = hyp;        

% Fit the model.
[cur_hyp, nlZ] = minimize(hyp, @penalized_gp, -max_iters, ...
               inference, meanfunc, covfunc, likfunc, Xtrain, ytrain);

model.hypers = cur_hyp;
model.hhp = hhp;
model.marginal_log_likelihood_train = -nlZ(end);
model.marginal_log_likelihood_test = ...
    -gp(model.hypers, inference, meanfunc, covfunc, likfunc, Xtest, ytest);


% Make predictions.
[ymu, ys2, predictions, fs2, log_prob_y] = ...
    gp(model.hypers, inference, meanfunc, covfunc, likfunc, Xtrain, ytrain, Xtest, ytest);
