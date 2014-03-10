%function synthetic_1st_order

% demo script for regression with HKL
clear all
%addpath(genpath(pwd))

load housing

    assert(size(X,1) == size(y,1));
    assert(size(y,2) == 1 );

    % Normalize the data.
    X = X - repmat(mean(X), size(X,1), 1 );
    X = X ./ repmat(std(X), size(X,1), 1 );

    % Only normalize the y if it's not a classification experiment. Hacky.
    if ~all(y == 1 | y == -1 )
        y = y - mean(y);
        y = y / std(y);
    end


% censored data
trainset = all(X' > -1.5);
testset = ~trainset;
test_size = length(testset)

X_all = X;
y_all = y;


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

R = D;  
covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel
hyp.cov = [ log(ones(1,2*D)), log(ones(1,R))];    % Set hyperparameters.
hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);
[predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);

hyp_add = hyp;
[lengthscales, variances, scaled_order_variances] = sort_additive_hypers( D, hyp.cov )
error_add = mean((predictions - y_test).^2)
logprob_add = mean(lp)



covfunc = { 'covSEard' };  % Construct an additive kernel
hyp.cov = [ log(ones(1,D)), log(1)];    % Set hyperparameters.
hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);
[predictions, ~, ~, ~, lp] = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, X_test, y_test);

exp(hyp.cov)
error = mean((predictions - y_test).^2)
logprob = mean(lp)



% generate a grid
range = -2:.1:2;
[a,b] = meshgrid(range, range);
xstar = [ a(:), b(:) ];
%for i = 1:length(xstar)
 %   hyp.cov(end-1:end) = xstar(i, :);
    %hyp = minimize(hyp, @gp, -100, inference, meanfunc, covfunc, likfunc, X, y);
    predictions_ard = gp(hyp, inference, meanfunc, covfunc, likfunc, X, y, xstar);
    
    covfunc = { 'covADD',{1:R,'covSEiso'} };  % Construct an additive kernel
    predictions_add = gp(hyp_add, inference, meanfunc, covfunc, likfunc, X, y, xstar);
  %  error_grid(i) = mean((predictions - y_test).^2);
  %  logprob_grid(i) = mean(lp);
%end



figure;
h = surf(a,b,reshape(predictions_ard(1:length(xstar)), length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
view(2)
axis off
%title('ard')
save2pdf('figures/1st_order_censored_ard.pdf', gcf, 600 );

figure;
h = surf(a,b,reshape(predictions_add(1:length(xstar)), length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
view(2)
axis off
%title('additive');
save2pdf('figures/1st_order_censored_add.pdf', gcf, 600 );

Y2 = zeros(length(xstar),1);
for i=1:s
    %for j=1:i-1
        Y2 = Y2 + sin(xstar(:,J(i)).*2 + 1);
        %Y = Y + X(:,J(i)) + X(:,J(j));
    %end
end
Y2 = Y2 / std(Y);
figure;
h = surf(a,b,reshape(Y2(1:length(xstar)), length( range), length( range) ), 'EdgeColor','none','LineStyle','none','FaceLighting','phong'); 
%title('truth');
hold on;
plot3(X(:,1), X(:,2), y + 10, '.')
view(2)
axis off
save2pdf('figures/1st_order_censored__truth.pdf', gcf, 600 );
