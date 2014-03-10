function [predictions, log_prob_y, model] = gp_ard( Xtrain, ytrain, Xtest, ytest )

inference = @infExact;
likfunc = @likGauss;
[predictions, log_prob_y, model] = ...
    gp_ard_general( likfunc, inference, Xtrain, ytrain, Xtest, ytest );
first_model = model;

% Now run for a second set of iterations, to be a fair comparison against
% other models that also use ARD to initialize.
%[predictions, log_prob_y, model] = ...
%    gp_ard_general( likfunc, inference, Xtrain, ytrain, Xtest, ytest, model.hypers );
%model.first_model = first_model;    