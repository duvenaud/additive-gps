function [predictions, log_prob_y, model] = lin_model( Xtrain, ytrain, Xtest, ytest )
% Simple maximum-likelihood linear regression model as a sanity check.

% Training
weights = Xtrain \ ytrain
ss_hat = mean((ytrain - Xtrain*weights).^2)
model.weights = weights;
model.ss_hat = ss_hat;

% Testing
predictions = Xtest * weights;
log_prob_y = -(0.5/ss_hat).*(predictions - ytest).^2 ...
             -log(2*pi*ss_hat);


