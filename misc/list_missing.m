function list_missing( K, seeds, outdir )
% Checks to see which runs failed or are missing,
% and prints the qsub commands corresponding to those jobs.
%
% David Duvenaud
% May 2011
% =============================

fprintf('Printing missing commands...\n');

addpath(genpath(pwd))
addpath('../utils/');

if nargin < 1; K = 5; end
%if nargin < 2; seeds = [0:4]; end
if nargin < 2; seeds = [0:4]; end
if nargin < 3; outdir = 'results/'; end


% Choose which subset of datasets and methods to look at.
[classification_datasets, classification_methods, ...
          regression_datasets, regression_methods] = define_datasets_and_methods();

% Classification
print_missing_commands( classification_datasets, classification_methods, K, outdir, seeds, true );

% Regression
print_missing_commands( regression_datasets, regression_methods, K, outdir, seeds, false );
end


function print_missing_commands( datasets, methods, K, outdir, seeds, classification )

    num_missing = 0;
    if nargin < 3; K = 5; end
    if nargin < 4; outdir = 'results/'; end

    folds = 1:K;
    
    for d_ix = 1:length(datasets)
        cur_dataset = datasets{d_ix};
        for m_ix = 1:length(methods)        
            train = methods{m_ix};
            for fold = folds
                for seed_ix = 1:length(seeds)
                    seed = seeds(seed_ix);
                    try
                        % Load the results.
                        filename = run_one_fold( cur_dataset, train, K, fold, seed, outdir, true );
                        results = load( filename );
                        if m_ix ~= 3 && isnan(mean( results.loglik ))
                        %    error('nan');
                        end
                        mean( (results.predictions - results.actuals).^2 );
                        mean((results.predictions > 0) * 2 - 1 == results.actuals);                        
                    catch 
                        %disp(lasterror);
                        fprintf('qsub -l lr=0 -o "logs/run_log_%d_%d_%d.txt" -e "logs/run_log_%d_%d_%d.txt" run_one_job.sh %d %d %d %d %d %d\n', ...
                            m_ix, d_ix, fold, m_ix, d_ix, fold, m_ix, d_ix, fold, classification, K, seed);
                        num_missing = num_missing + 1;
                    end
                end                        
            end 
        end    
    end
    %num_missing
end