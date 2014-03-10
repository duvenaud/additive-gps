function [likelihoods, mses, accuracies, ...
    dataset_names, method_names, ...
    likelihood_all, mse_all, accuracy_all] = compile_results( datasets, methods, K, outdir, seeds )

% Compiles all the results.
% 
% David Duvenaud
% March 2011
% ===========================

has_likelihood = [1 1 0 1 1 ]'   % Don't worry if HKL doesn't have a loglik.

if nargin < 3; K = 5; end
if nargin < 4; outdir = 'results/'; end

log_likelihood_table = NaN( K, length(datasets), length(methods), length(seeds));
mse_table = NaN( K, length(datasets), length(methods), length(seeds));
accuracy_table = NaN( K, length(datasets), length(methods), length(seeds));
marginal_lik_table = NaN( K, length(datasets), length(methods), length(seeds));
marginal_lik_table_test = NaN( K, length(datasets), length(methods), length(seeds));

best_log_likelihood_table = NaN( K, length(datasets), length(methods));
best_mse_table = NaN( K, length(datasets), length(methods));
best_accuracy_table = NaN( K, length(datasets), length(methods));
best_marginal_lik_table = NaN( K, length(datasets), length(methods));

folds = 1:K;

num_missing = 0;

for d_ix = 1:length(datasets)
    cur_dataset = datasets{d_ix};
    [~, shortname] = fileparts(cur_dataset);
    fprintf('\nCompiling results for %s dataset...\n', shortname );   
    
    dataset_names{d_ix} = shortname;
    for m_ix = 1:length(methods)        
        train = methods{m_ix};
        method_names{m_ix} = func2str(train);
        
        for fold = folds
            for seed_ix = 1:length(seeds)
                seed = seeds(seed_ix);
                try
                    % Load the results.
                    filename = run_one_fold( cur_dataset, train, K, fold, seed, outdir, true );
                    %fprintf('Loading %s', filename );
                    results = load( filename );

                    try
                        marginal_lik_table(fold, d_ix, m_ix, seed_ix) = results.model.marginal_log_likelihood_train;                        
                    catch
                    end

                    %try
                    %    marginal_lik_table_test(fold, d_ix, m_ix, seed_ix) = results.model.marginal_log_likelihood_test;
                    %catch
                    %end                    
                    
                    log_likelihood_table(fold, d_ix, m_ix, seed_ix) = mean( results.loglik );
                    mse_table(fold, d_ix, m_ix, seed_ix) = mean( (results.predictions - results.actuals).^2 );
                    accuracy_table(fold, d_ix, m_ix, seed_ix) = mean((results.predictions > 0) * 2 - 1 == results.actuals);
                    
                    if ~isfinite(mean( results.loglik ))
                        fprintf('N');   % Failed because of a Nan or Inf.
                    else
                        fprintf('O');   % Run went OK
                    end
                catch 
                    %disp(lasterror);
                    fprintf('X');       % Never even finished.
                    num_missing = num_missing + 1;
                    
                    % Stop here and run this to see why it failed:
                    %run_one_experiment(m_ix, d_ix, K, fold, 0, seed, outdir)
                end                
            end

            % Choose the model that had the best training set marginal
            % likelihood.
            [best_marginal_lik_table(fold, d_ix, m_ix), best_seed_ix] = max(marginal_lik_table(fold, d_ix, m_ix,:), [], 4);
            best_log_likelihood_table(fold, d_ix, m_ix) = log_likelihood_table(fold, d_ix, m_ix, best_seed_ix);
            best_mse_table(fold, d_ix, m_ix) = mse_table(fold, d_ix, m_ix, best_seed_ix);
            best_accuracy_table(fold, d_ix, m_ix) = accuracy_table(fold, d_ix, m_ix, best_seed_ix);                                    
            
            %squeeze(mse_table(fold, d_ix, m_ix,:))
        end
        fprintf('\n');
        

        %fold_has_nans = any(isnan(best_log_likelihood_table(folds,d_ix,:)), 3);
        %if fold_has_nans
        %end
    end

    % Make the comparison fair by removing a fold if any methods have a NaN
    % in it.
    %best_log_likelihood_table( has_likelihood & squeeze(any(isnan(best_log_likelihood_table(folds,d_ix,:)), 1)), d_ix, :) = NaN;
    %best_mse_table( any(isnan(best_mse_table(folds,d_ix,:)), 1), d_ix, :) = NaN;
    %best_accuracy_table( any(isnan(best_accuracy_table(folds,d_ix,:)), 1), d_ix, :) = NaN;        

    for fold = folds
        missing_ll = any(has_likelihood & squeeze(any(isnan(best_log_likelihood_table(fold,d_ix,:)), 1)));
        if missing_ll
            warning('missing a fold');
            best_log_likelihood_table( fold, d_ix, :) = NaN;
        end
        
        missing_mse = any(any(isnan(best_mse_table(fold,d_ix,:))));
        if missing_mse
            warning('missing a fold');
            best_mse_table( fold, d_ix, :) = NaN;
        end
        
        missing_acc = any(any(isnan(best_accuracy_table(fold,d_ix,:))));
        if missing_acc
            warning('missing a fold');
            best_accuracy_table( fold, d_ix, :) = NaN;
        end
    end
end


if 0
% Compute correlations to see how bad overfitting is
cfs = 0;
for m_ix = 1:length(methods)
    train = methods{m_ix};
    func2str(train);
    i = 0;         
    for d_ix = 1:length(datasets)
        cur_dataset = datasets{d_ix};
        [~, shortname] = fileparts(cur_dataset);        
        shortname
        
        for fold = 1:K
            train = squeeze(marginal_lik_table(fold, d_ix, m_ix, :));
            %test = squeeze(marginal_lik_table_test(fold, d_ix, m_ix, :));
            test = squeeze(log_likelihood_table(fold, d_ix, m_ix, :));
            good = ~(isnan(train) | isnan(test));
            
            c = 0;
            if sum(good) > 0
                c = corr(train(good), test(good));
            end
         
            
            i = i + 1;
            cfs( m_ix, d_ix, fold ) = c;
            %plot( train, test, '.');
            %pause;
            %drawnow;
        end
    end
end
nanmean(cfs,3)
nanmean(nanmean(cfs,3),1);
end
%mse_table = mse_table([1 2 3 4 ], :,:)
%figure(1) ;plot( marginal_lik_table(:), accuracy_table(:), '.'); 
%figure(2); plot( marginal_lik_table(:), mse_table(:), '.')

% Now make figures and tables.

meanfunc = @nanmean
stdfunc = @nanstd

likelihoods = reshape(meanfunc(best_log_likelihood_table(folds,:,:),1), length(datasets),  length(methods));
%likelihood_std = reshape(stdfunc(best_log_likelihood_table(folds,:,:),1), length(datasets),  length(methods));
likelihood_all = best_log_likelihood_table;
fprintf('\n\n');
print_table( 'Log Likelihood', dataset_names, method_names, likelihoods );
if any(isnan(log_likelihood_table(:)))
    warning('Some log likelihood entries missing!')
end

mses = reshape(meanfunc(best_mse_table(folds,:,:),1), length(datasets),  length(methods));
%mse_std = reshape(stdfunc(best_mse_table(folds,:,:),1), length(datasets),  length(methods));
mse_all = best_mse_table;
fprintf('\n\n');
print_table( 'Mean Squared Error', dataset_names, method_names, mses );
if any(isnan(mse_table(:)))
    warning('Some Mean Squared Error entries missing!')
end

accuracies = reshape(meanfunc(best_accuracy_table(folds,:,:),1), length(datasets),  length(methods));
%accuracy_std = reshape(stdfunc(best_accuracy_table(folds,:,:),1), length(datasets),  length(methods));
accuracy_all = best_accuracy_table;
fprintf('\n\n');
print_table( 'Classification Acc', dataset_names, method_names, accuracies );
if any(isnan(accuracy_table(:)))
    warning('Some Classification Acc entries missing!')
end

num_missing
