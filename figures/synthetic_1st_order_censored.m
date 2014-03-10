function synthetic_1st_order_censored
% Generate some plots showing additive GP regression on synthetic datasets
% with 1st-order interactions and censored data.
%
% David Duvenaud
% April 2011
% ===============

addpath(genpath([pwd '/../']))
addpath('../../utils/');

% fixing the seed of the random generators
seed=6;
randn('state',seed);
rand('state',seed);

dpi = 100;
line_width = 2;
markersize = 14;

n = 100;            % number of observations
s = 2;              % number of relevant variables
noise_std = .02;		% standard deviation of noise
proptrain = .5;     % proportion of data kept for training (the rest is used for testing)

X = rand(n,2) * 4 - 2;


% generate nonlinear function of X as the sum of all cross-products
J =  1:s;    % select the first s variables
Y = zeros(n,1);
for i=1:s
    Y = Y + sin(X(:,J(i)) .* 2 + 1);
end

% normalize to unit standard deviation
Y = Y / std(Y);

% add some noise with known standard deviation
Y =  Y + randn(n,1) * noise_std;


% censored data
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

likfunc = 'likGauss'; sn = 0.1; hyp.lik = log(sn);
inference = @infExact;
meanfunc = {'meanConst'}; hyp.mean = 0;

% Train additive model
R = 2;
covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel
hyp.cov = [ log(ones(1,2*D)), log(ones(1,R))];    % Set hyperparameters.
evalc('hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);');
[predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);
hyp_add = hyp;
[lengthscales, variances, scaled_order_variances] = sort_additive_hypers( D, hyp.cov )
error_add = mean((predictions - y_test).^2)
logprob_add = mean(lp)


% Train ARD model
covfunc = { 'covSEard' };
hyp.cov = [ log(ones(1,D)), log(1)];    % Set hyperparameters.
evalc('hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);');
[predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);
exp(hyp.cov)
error = mean((predictions - y_test).^2)
logprob = mean(lp)



% generate a grid
range = -2:.005:2;
[a,b] = meshgrid(range, range);
xstar = [ a(:), b(:) ];

% make ard predictions.
predictions_ard = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, xstar);

% make additive predictions.
covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel
predictions_add = gp(hyp_add, inference, meanfunc, covfunc, likfunc, X, y, xstar);

figure; subplot('position',[0 0 1 1]);
h = surf(a,b,reshape(predictions_ard(1:length(xstar)), length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
view(2); hold on;
plot3(X(:,1), X(:,2), y + 10, 'wx', 'Linewidth', line_width, 'Markersize', markersize, 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor','none');   % show the data
%line([censor_threshold censor_threshold], [ censor_threshold 2 ], [20 20], 'LineWidth',line_width,'Color',[0 0 0] ); hold on;
%line([censor_threshold 2], [ censor_threshold censor_threshold ], [20 20], 'LineWidth',line_width,'Color',[0 0 0] );
axis off
%title('ard')


save2pdf('1st_order_censored_ard.pdf', gcf, dpi, true );


figure; subplot('position',[0 0 1 1]);
h = surf(a,b,reshape(predictions_add(1:length(xstar)), length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
view(2); hold on;
plot3(X(:,1), X(:,2), y + 10, 'wx', 'Linewidth', line_width, 'Markersize', markersize, 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor',[1 1 1]);   % show the data
%line([censor_threshold censor_threshold], [ censor_threshold 2 ], [20 20],'LineWidth',line_width,'Color',[0 0 0] ); hold on;
%line([censor_threshold 2], [ censor_threshold censor_threshold ], [20 20], 'LineWidth',line_width,'Color',[0 0 0] );
axis off
%title('additive');
save2pdf('1st_order_censored_add.pdf', gcf, dpi, true );

Y2 = zeros(length(xstar),1);
for i=1:s
    Y2 = Y2 + sin(xstar(:,J(i)).*2 + 1);    
end
Y2 = Y2 / std(Y);

figure; subplot('position',[0 0 1 1]);
h = surf(a,b,reshape(Y2(1:length(xstar)), length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
%title('truth');
hold on;
plot3(X(:,1), X(:,2), y + 10, 'wx', 'Linewidth', line_width, 'Markersize', markersize);   % show the data
%line([censor_threshold censor_threshold], [ censor_threshold 2 ], [20 20], 'LineWidth',line_width,'Color',[0 0 0] ); hold on;
%line([censor_threshold 2], [ censor_threshold censor_threshold ], [20 20], 'LineWidth',line_width,'Color',[0 0 0] );
view(2)
axis off
save2pdf('1st_order_censored_truth.pdf', gcf, dpi, true );

figure; % subplot('position',[0 0 1 1]);
h = plot3(X(:,1), X(:,2), y + 10, 'b.', 'Linewidth', 2);   % show the data
xlim( [-2 2] );
ylim( [-2 2] );
view(2)
%axis off
set( gca, 'Box', 'on' );
set( gca, 'XTick', [] );
set( gca, 'yTick', [] );
set( gca, 'XTickLabel', '' );
set( gca, 'yTickLabel', '' );
xlabel('x_1');
ylabel('x_2');
line([censor_threshold censor_threshold], [ censor_threshold 2 ], [20 20], 'LineWidth',line_width,'Color',[0 0 0] ); hold on;
line([censor_threshold 2], [ censor_threshold censor_threshold ], [20 20], 'LineWidth',line_width,'Color',[0 0 0] );
save2pdf('1st_order_censored_data.pdf', gcf, dpi, true );


% View the 1-D functions.
% make additive predictions.
% generate a grid
%range = -2:.1:20;
covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel
%[a,b] = meshgrid(range, range);

subplot( 2, 1, 1);
% plot the part of the function depending on the first dimension.
xstar = [ range', Inf(length(range),1) ];
predictions_add = gp(hyp_add, inference, meanfunc, covfunc, likfunc, X, y, xstar);
%figure; %subplot('position',[0 0 1 1]);
plot( range, sin(range.*2 + 1), 'g-' ); hold on;
plot( range, predictions_add - hyp_add.mean, 'b-' ); hold on;
%plot( X(:,1), y, 'r.' ); hold on;
% for each datapoint, find out how much the other dimension contributed.
xstar = [ Inf(length(X),1), X(:,2) ];
data_minus_2nd_d = gp(hyp_add, inference, meanfunc, covfunc, likfunc, X, y, xstar);
%plot( X(:,1), y - data_minus_2nd_d + hyp_add.mean, 'b.' ); hold on;
plot( X(:,1), y - data_minus_2nd_d, 'b.' ); hold on;
xlabel('$x_1$');
ylabel('$f_1(x_1)$');
set(get(gca,'XLabel'),'Rotation',0,'Interpreter','latex', 'Fontsize', 16)
set(get(gca,'YLabel'),'Rotation',0,'Interpreter','latex', 'Fontsize', 16)
%save2pdf('1st_order_censored_d1.pdf', gcf, dpi, true );

subplot(2,1,2);
xstar = [ Inf(length(range),1), range'];
predictions_add = gp(hyp_add, inference, meanfunc, covfunc, likfunc, X, y, xstar);
%figure; %subplot('position',[0 0 1 1]);
plot( range, sin(range.*2 + 1), 'g-' ); hold on;
plot( range, predictions_add - hyp_add.mean, 'b-' ); hold on;
%plot( X(:,2), y, 'r.' ); hold on;
% for each datapoint, find out how much the other dimension contributed.
xstar = [ X(:,1), Inf(length(X),1) ];
data_minus_1st_d = gp(hyp_add, inference, meanfunc, covfunc, likfunc, X, y, xstar);
%plot( X(:,1), y - data_minus_2nd_d + hyp_add.mean, 'b.' ); hold on;
plot( X(:,2), y - data_minus_1st_d, 'b.' ); hold on;
xlabel('$x_2$');
ylabel('$f_2(x_2)$');
set(get(gca,'XLabel'),'Rotation',0,'Interpreter','latex', 'Fontsize', 16)
set(get(gca,'YLabel'),'Rotation',0,'Interpreter','latex', 'Fontsize', 16)

save2pdf('1st_order_censored_d1d2.pdf', gcf, dpi, true );

%asdf
