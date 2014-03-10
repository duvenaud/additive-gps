function draw_interaction_plots2()
%
% A simple demo script to 
%
%

% Run from main directory
addpath(genpath([pwd '/']))
addpath('../utils/');
clear all
close all

outdir = 'results/';

dpi = 100;

K = 5;
fold = 1;
seeds = [0:4];

%dataset_name = 'data/classification/r_liver.mat';   % interesting 2d plots
%dataset_name = 'data/classification/crabs.mat';
%dataset_name = 'data/classification/r_breast.mat';
%dataset_name = 'data/classification/r_pima.mat';
%dataset_name = 'data/classification/r_heart.mat';
dataset_name = 'data/regression/r_concrete_500.mat';
load(dataset_name);

X = X(1:100,:);
y = y(1:100);

% Normalize the data.
X = X - repmat(mean(X), size(X,1), 1 );
X = X ./ repmat(std(X), size(X,1), 1 );

y = y - mean(y);
y = y / std(y);

[N,D] = size(X);

R = 4;
covfunc = { 'covADD',{1:R,'covSEiso_length'} };  % Construct an additive kernel
hyp.cov = zeros(1, D+R);

likfunc = @likGauss;
inference = @infExact;
hyp.lik = 0;

if 0
    clear infEP;
    likfunc = @likErf;
    hyp.lik = [];
    inference = @infEP;
end


meanfunc = {'meanConst'};
hyp.mean = 0;



% train
hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);
%[predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);

[add_lengthscales, add_orders] = sort_additive_hypers_lo(D, hyp.cov)
%[add_lengthscales, add_variances, add_orders] = sort_additive_hypers(D, hyp.cov)

plot_1st_order_interactions( X, y, hyp, covfunc, meanfunc, likfunc, inference )
%plot_2nd_order_interactions( X, y, hyp, covfunc, meanfunc, likfunc, inference )
plot_3rd_order_interactions( X, y, hyp, covfunc, meanfunc, likfunc, inference, 4, 8, 1 )
end