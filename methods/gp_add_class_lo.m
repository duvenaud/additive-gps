function [predictions, log_prob_y, model] = gp_add_class_lo( Xtrain, ytrain, Xtest, ytest )

likfunc = @likErf;
inference = @infEP;
[predictions, log_prob_y, model] = ...
    gp_add_general_lo( likfunc, inference, Xtrain, ytrain, Xtest, ytest );

