% demo script for regression with HKL
clear all
seed=1;
randn('state',seed);
rand('state',seed);

p = 1024;           % total number of variables (used to generate Wishart)
psub = 8;          % kept number of variables
n = 200;           % number of observations
s = 4;              % number of relevant variables
noise_std = .2;		% standard deviation of noise
proptrain = .5;     % proportion of data kept for training


% generate random covariance matrix from a Wishart distribution
Sigma_sqrt = randn(p,p);
Sigma = Sigma_sqrt' * Sigma_sqrt;


% normalize to unit trace and sample
diagonal = diag(Sigma);
Sigma = diag( 1./diagonal.^.5) * Sigma * diag( 1./diagonal.^.5);
Sigma_sqrt =   Sigma_sqrt * diag( 1./diagonal.^.5);
X = randn(n,p) * Sigma_sqrt;

X = X(:,1:psub);
p=psub;

% generate nonlinear function of X
J =  1:s;    % select variables
Y = zeros(n,1);
for i=1:s
	for j=1:i-1
		Y = Y + X(:,J(i)) .* X(:,J(j));
	end
end
Y = Y / std(Y);

% add some noise with known standard deviation
Y = 1/noise_std * Y / std(Y);
Y = double( ( rand(n,1) < 1./( 1 + exp(-Y) ) ) );


y = Y .* 2 - 1;
save('bach_synth_c_200.mat', 'X', 'y' );

X = X(1:100,:);
y = y(1:100,:);
save('bach_synth_c_100.mat', 'X', 'y' );