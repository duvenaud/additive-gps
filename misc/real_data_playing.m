% demo script for regression with HKL
clear all
%addpath(genpath(pwd))

% fixing the seed of the random generators
seed=0;
randn('state',seed);
rand('state',seed);


load data/regression/housing

n = length(X);

Y = y;
proptrain = .5;     % proportion of data kept for training (the rest is used for testing)

% normalize to unit standard deviation
Y = Y / std(Y);

% split data in two groups
ntrain = round(n*proptrain);
ntest = n - ntrain;
rp = randperm(n);
trainset = rp(1:ntrain);
testset  = rp(ntrain+1:end);

test_size = ntest;

X_all = X;
y_all = Y;


% split into training and test
X_test = X_all(end-test_size+1:end,:);
y_test = y_all(end-test_size+1:end);
X = X_all(1:end-test_size,:);
y = y_all(1:end-test_size);

[N,D] = size(X);



% Instead of restarting all the covariance parameters, just keep the
% old set and add one new parameter, also initialized to its previous
% value.
%hyp.cov = [hyp.cov hyp.cov(end)];


likfunc = 'likGauss'; sn = 0.1; hyp.lik = log(sn);
inference = @infExact;
meanfunc = {'meanConst'}; hyp.mean = 0;

% R = D;  
% covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel
% hyp.cov = [ log(1*ones(1,2*D)), log(ones(1,R))];    % Set hyperparameters.
% hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);
% [predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);
% 
% hyp_add = hyp;
% [lengthscales, variances, scaled_order_variances] = sort_additive_hypers( D, hyp.cov )
% error_add = mean((predictions - y_test).^2)
% logprob_add = mean(lp)

% R = 4;
% hyp.cov = [ log(1*ones(1,2*D)) zeros(1,R)];    % Set hyperparameters.
% covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel
% hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);
% [predictions, ~, ~, ~, lp1] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);
% 
% hyp.cov = [ log(1*ones(1,2*D)) zeros(1,R)];    % Set hyperparameters.
% covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel
% hyp2 = minimize2(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);
% [predictions, ~, ~, ~, lp2] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);




for r = 1:2
    R = r;  
    covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel
    hyp.cov = [ hyp.cov log(1) ];    % Set hyperparameters.
    hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);
    [predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);

    hyp_add = hyp;
    [lengthscales, variances, scaled_order_variances] = sort_additive_hypers( D, hyp.cov )
    error_add = mean((predictions - y_test).^2)
    logprob_add = mean(lp)
end

good_cov = hyp.cov;





hyp.cov = good_cov;
% generate a grid
range = -4:.1:4;
[a,b] = meshgrid(range, range);
xstar = [a(:) -b(:)];

%K = feval(covfunc{:}, hyp.cov, xstar, [0,0]);
covfunc = { 'covADD',{1:2,'covSEiso'} };  % Construct an additive kernel
%hyp.cov(2*D+3:end) = []
K = [];
for i = 1:length(xstar)    
    hyp.cov(5:6) = xstar(i,:);
    K(i) = -gp(hyp, inference, meanfunc, covfunc, likfunc, X, y);
end
figure;
h = surf(a,b,reshape(exp(K), length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
figure;
contour(a,b,reshape(K, length( range), length( range) ));


% hyp.cov(9:12) = [-Inf 100 -Inf -Inf];
% hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);
% [predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);
% hyp_add = hyp;
% [lengthscales, variances, scaled_order_variances] = sort_additive_hypers( D, hyp.cov )
% error_add = mean((predictions - y_test).^2)
% logprob_add = mean(lp)



covfunc = { 'covSEard' };  % Construct an additive kernel
hyp.cov = [ log(ones(1,D)), log(1)];    % Set hyperparameters.
hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);
[predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);

exp(hyp.cov)
error = mean((predictions - y_test).^2)
logprob = mean(lp)


