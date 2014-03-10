function [predictions, log_prob_y, model] = gp_add( Xtrain, ytrain, Xtest, ytest )

likfunc = @likGauss;
inference = @infExact;
[predictions, log_prob_y, model] = ...
    gp_add_general( likfunc, inference, Xtrain, ytrain, Xtest, ytest );

    