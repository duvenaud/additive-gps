% Perform Classification with HKL
%
% Adapted from demo_classification.
% All hyperparameters are the same.
%
% David Duvenaud
% May 2011
% ===================================
function [predictions, log_prob_y, model] = ...
    hkl_classification( Xtrain, ytrain, Xtest, ytest )


% Change y from [-1,1] to [0,1]
ytrain(ytrain == -1) = 0;
ytest(ytest == -1) = 0;

% select some regularization parameterst lambdas (from large to small)
lambdas = 10.^[2:-.5:-8];

disp('Learning with the ANOVA kernels');

% HKL with ANOVA kernel
[outputs,model,accuracies] = hkl(Xtrain,ytrain,lambdas, ...    
    'logistic','anova',[ .0625 .1 8 30], ...
    'maxactive',400, 'memory_cache', 1e9, 'display', 1);
    %'square', 'spline', [ .1 4 40], 'maxactive',300,'memory_cache',1e9);

% perform testing on the test set provided separately
accuracies_test = hkl_test(model,outputs,Xtest,'Ytest',ytest);

% choose best lambda based on training error
[best_training_error, best_ix] = min( accuracies_test.training_error);
best_training_error
chosen_test_error = accuracies_test.testing_error(best_ix)
predictions = accuracies_test.predtest(:,best_ix);
log_prob_y = NaN( size(ytest));  % How to assign likelihoods?

%figure;
%plot(accuracies_test.testing_error, 'g'); hold on;
%plot(accuracies_test.testing_error_unreg, 'r'); hold on;
%plot(accuracies_test.training_error, 'b'); hold on;




