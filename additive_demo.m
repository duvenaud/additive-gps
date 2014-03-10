function additive_demo
% Generate some plots showing additive GP regression on synthetic datasets
% with 1st-order interactions and censored data.
%
% David Duvenaud
% April 2011
% ===============

addpath(genpath('gpml'));

seed=6;   % fixing the seed of the random generators
randn('state',seed);
rand('state',seed);

line_width = 2;
markersize = 14;
n = 100;            % number of observations
noise_std = .02;		% standard deviation of noise
proptrain = .5;     % proportion of data kept for training (the rest is used for testing)

% Generate 2D sine data
X = rand(n,2) * 4 - 2;
Y = zeros(n,1);
for i=1:2
    Y = Y + sin(X(:,i) .* 2 + 1);
end
Y = Y / std(Y);                    % normalize to unit standard deviation
Y =  Y + randn(n,1) * noise_std;   % add some noise with known standard deviation

% Censored train/test split
censor_threshold = -1.5;
trainset = X(:,1) < censor_threshold | X(:,2) < censor_threshold;
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



% Set up additive model.
% =====================================

likfunc = 'likGauss'; sn = 0.1; hyp.lik = log(sn);
inference = @infExact;
meanfunc = {'meanConst'}; hyp.mean = 0;

R = 2;  % Maximum order of interaction.  Since our input dimension is
        % 2, our maximum order of interaction is also 2.

% Construct an additive kernel out of R one-dimensional SE kernels:
covfunc = { 'covADD',{1:R,'covSEiso'} };  

% Set hyperparameters.  First 2*R params are for the one-dimensional kernels,
% the last R are for the order variances.
hyp.cov = [ log(ones(1,2*D)), log(ones(1,R))];    

% Optimize hyperparameters
hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);
[predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);
hyp_add = hyp;
%[lengthscales, variances, scaled_order_variances] = sort_additive_hypers( D, hyp.cov )
error_add = mean((predictions - y_test).^2)
logprob_add = mean(lp)


% Setup and train ARD model (full-interaction GP)
% =====================================================

covfunc = { 'covSEard' };
hyp.cov = [ log(ones(1,D)), log(1)];    % Set hyperparameters.
hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);
[predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);
exp(hyp.cov)
error = mean((predictions - y_test).^2)
logprob = mean(lp)



% Generate a grid on which to visualize the learned functions.
% =====================================================

range = -2:.005:2;
[a,b] = meshgrid(range, range);
xstar = [ a(:), b(:) ];

% Make ard predictions.
predictions_ard = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, xstar);

% Make additive predictions.
covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel
predictions_add = gp(hyp_add, inference, meanfunc, covfunc, likfunc, X, y, xstar);


% Plot function learned by ARD GP model.
figure; %subplot('position',[0 0 1 1]);
h = surf(a,b,reshape(predictions_ard(1:length(xstar)), length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
view(2); hold on;
plot3(X(:,1), X(:,2), y + 10, 'wx', 'Linewidth', line_width, 'Markersize', markersize);   % show the data
axis off
title('ARD')


% Plot the function learned by the additive GP model.
figure; %subplot('position',[0 0 1 1]);
h = surf(a,b,reshape(predictions_add(1:length(xstar)), length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
view(2); hold on;
plot3(X(:,1), X(:,2), y + 10, 'wx', 'Linewidth', line_width, 'Markersize', markersize);   % show the data
axis off
title('additive');


% Plot the original function and data.
Y2 = zeros(length(xstar),1);
for i=1:2
    Y2 = Y2 + sin(xstar(:,i).*2 + 1);    
end
Y2 = Y2 / std(Y);
figure; %subplot('position',[0 0 1 1]);
h = surf(a,b,reshape(Y2(1:length(xstar)), length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
hold on;
plot3(X(:,1), X(:,2), y + 10, 'wx', 'Linewidth', line_width, 'Markersize', markersize);   % show the data
view(2)
axis off
title('True function');



% View the 1-D functions learned by the additive model.
covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel
figure; subplot( 2, 1, 1);
% plot the part of the function depending on the first dimension.
xstar = [ range', Inf(length(range),1) ];
predictions_add = gp(hyp_add, inference, meanfunc, covfunc, likfunc, X, y, xstar);
plot( range, sin(range.*2 + 1), 'g-' ); hold on;
plot( range, predictions_add - hyp_add.mean, 'b-' ); hold on;
% for each datapoint, find out how much the other dimension contributed.
xstar = [ Inf(length(X),1), X(:,2) ];
data_minus_2nd_d = gp(hyp_add, inference, meanfunc, covfunc, likfunc, X, y, xstar);
plot( X(:,1), y - data_minus_2nd_d, 'b.' ); hold on;
xlabel('$x_1$');
ylabel('$f_1(x_1)$');
set(get(gca,'XLabel'),'Rotation',0,'Interpreter','latex', 'Fontsize', 16)
set(get(gca,'YLabel'),'Rotation',0,'Interpreter','latex', 'Fontsize', 16)
title('1-dimensional functions learned by additive model');

subplot(2,1,2);
xstar = [ Inf(length(range),1), range'];
predictions_add = gp(hyp_add, inference, meanfunc, covfunc, likfunc, X, y, xstar);
plot( range, sin(range.*2 + 1), 'g-' ); hold on;
plot( range, predictions_add - hyp_add.mean, 'b-' ); hold on;
% for each datapoint, find out how much the other dimension contributed.
xstar = [ X(:,1), Inf(length(X),1) ];
data_minus_1st_d = gp(hyp_add, inference, meanfunc, covfunc, likfunc, X, y, xstar);
plot( X(:,2), y - data_minus_1st_d, 'b.' ); hold on;
xlabel('$x_2$');
ylabel('$f_2(x_2)$');
set(get(gca,'XLabel'),'Rotation',0,'Interpreter','latex', 'Fontsize', 16)
set(get(gca,'YLabel'),'Rotation',0,'Interpreter','latex', 'Fontsize', 16)

