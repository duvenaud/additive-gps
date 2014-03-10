% Logistic regression using IRLS.
% Code originally from:
% http://www.cs.cmu.edu/~ggordon/IRLS-example/logistic.m
%
% David Duvenaud
% May 2011
% =================

function [predictions, log_prob_y, model] = logistic( Xtrain, ytrain, Xtest, ytest )
% Simple maximum-likelihood logistic regression model as a sanity check.


param.maxiter = 200;
param.epsilon = 1e-10;
param.ridge = 1e-2;   % Just enough regularization to prevent numerical problems.

% Training
% do the regression

a = Xtrain;
[n, m] = size(a);
x = zeros(m,1);
y = ytrain;
y(y==-1) = 0;
oldexpy = -ones(size(y));
ridgemat = eye(m) * param.ridge;

for iter = 1:param.maxiter

  adjy = a * x;
  expy = 1 ./ (1 + exp(-adjy));
  deriv = expy .* (1-expy); 
  wadjy = deriv .* adjy + (y-expy);
  weights = spdiags(deriv, 0, n, n);

  %x = inv(a' * weights * a + ridgemat) * a' * wadjy;    % bad version
  x = (a' * weights * a + ridgemat) \ ( a' * wadjy);
  if (sum(abs(expy-oldexpy)) < n*param.epsilon)
      fprintf('Converged in %d iterations.\n', iter);
    break;
  end
  
  oldexpy = expy;

end

model.weights = x;

% Testing
predictions = (Xtest * model.weights).*2 - 1;
log_prob_y = log(1 ./ (1 + exp(-ytest.*predictions)));
