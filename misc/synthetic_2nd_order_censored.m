%function synthetic_1st_order

% demo script for regression with HKL
clear all
%addpath(genpath(pwd))

% fixing the seed of the random generators
%seed=0;
%randn('state',seed);
%rand('state',seed);



bigp = 4

% toy example characteristics
p = 2^bigp;%1024;           % total number of variables (used to generate a Wishart distribution)
psub = 3;          % kept number of variables = dimension of the problem
n = 100;            % number of observations
s = 3;              % number of relevant variables
noise_std = .02;		% standard deviation of noise
proptrain = .5;     % proportion of data kept for training (the rest is used for testing)


% generate random covariance matrix from a Wishart distribution
Sigma_sqrt = randn(p,p);
Sigma = Sigma_sqrt' * Sigma_sqrt;


% normalize to unit trace and sample
diagonal = diag(Sigma);
Sigma = diag( 1./diagonal.^.5) * Sigma * diag( 1./diagonal.^.5);
Sigma_sqrt =   Sigma_sqrt * diag( 1./diagonal.^.5);
X = randn(n,p);% * Sigma_sqrt;

X = X(:,1:psub);
p=psub;

% generate nonlinear function of X as the sum of all cross-products
J =  1:s;    % select the first s variables
Y = zeros(n,1);
%for i=1:s   
%     Y = Y + sin(X(:,J(i)));  %Works!!!       
%end

for i=1:s
    for j=1:i-1   
        Y = Y + sin(sin(X(:,J(i)) .* sin(X(:,J(j)))));
    end
end

% normalize to unit standard deviation
Y = Y / std(Y);

% add some noise with known standard deviation
Y =  Y + randn(n,1) * noise_std;


% split data in two groups
%ntrain = round(n*proptrain);
%ntest = n - ntrain;
%rp = randperm(n);
%trainset = rp(1:ntrain);
%testset  = rp(ntrain+1:end);

% censored data
trainset = X(:,1) < 0 | X(:,2) < 0 | X(:,3) < 0;
testset = ~trainset;

test_size = length(testset);

X_all = X;
y_all = Y;


% split into training and test
X_test = X_all(testset,:);
y_test = y_all(testset);
X = X_all(trainset,:);
y = y_all(trainset);

[N,D] = size(X);

%plot3( X(:,1), X(:,2), y, '.' )

% Instead of restarting all the covariance parameters, just keep the
% old set and add one new parameter, also initialized to its previous
% value.
%hyp.cov = [hyp.cov hyp.cov(end)];


likfunc = 'likGauss'; sn = 0.1; hyp.lik = log(sn);
inference = @infExact;
meanfunc = {'meanConst'}; hyp.mean = 0;

R = 3;  
covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel
hyp.cov = [ log(ones(1,2*D)), log(ones(1,R))];    % Set hyperparameters.
evalc('hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);');
[predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);

hyp_add = hyp;
[lengthscales, variances, scaled_order_variances] = sort_additive_hypers( D, hyp.cov )
error_add = mean((predictions - y_test).^2)
logprob_add = mean(lp)



covfunc = { 'covSEard' };  % Construct an additive kernel
hyp.cov = [ log(ones(1,D)), log(1)];    % Set hyperparameters.
evalc('hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);');
[predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);

exp(hyp.cov)
error = mean((predictions - y_test).^2)
logprob = mean(lp)

%end

