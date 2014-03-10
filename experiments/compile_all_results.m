function compile_all_results( K, seeds, outdir, tabledir )
% Main script to produce all figures.

fprintf('Compiling all results...\n');
addpath(genpath(pwd))
addpath('../utils/');

if nargin < 1; K = 10; end
if nargin < 2; seeds = [0:4]; end
if nargin < 3; outdir = 'results/'; end
%if nargin < 3; outdir = '../../../old/results_16_apr_100_init_iters/'; end
if nargin < 4; tabledir = '/homes/mlghomes/dkd23/Dropbox/papers/NIPS2011_Additive/tables/'; end
if nargin < 4; figuredir = '/homes/mlghomes/dkd23/Dropbox/papers/NIPS2011_Additive/figures/'; end
%if nargin < 4; tabledir = '../../../old/tables_additive_uni/'; end
%if nargin < 4; figuredir = '../../../old/tables_additive_uni/'; end


% Choose which subset of datasets and methods to look at.
[classification_datasets, classification_methods, ...
          regression_datasets, regression_methods] = define_datasets_and_methods();

% Remove sanity checks
%classification_datasets(end-1:end) = [];
%regression_datasets(end-1:end) = [];

hkl_ix = 3;

if 0
% Print dataset table
[class_nd_table, class_shortnames] = print_dataset_stats( classification_datasets );
[reg_nd_table, reg_shortnames ] = print_dataset_stats( regression_datasets );

% Output a dataset table to latex.
resultsToLatex2( [ tabledir, 'nd_table.tex'], [class_nd_table; reg_nd_table], {class_shortnames{:}, reg_shortnames{:}}, {'N', 'D'}, 'Dataset Statistics', 1 );
end

% Classification results.
% Note: some results are missing from the latest run.
if 0
[likelihoods, mses, accuracies, dataset_names, method_names, likelihood_all, mse_all, accuracy_all] ...
    = compile_results( classification_datasets, classification_methods, K, outdir, seeds );
dataset_names = shorten_names( dataset_names );
method_names = replace_method_names( method_names );
resultsToLatex2( [ tabledir, 'class_table.tex'], (1 - accuracies') .* 100, method_names, dataset_names, 'Classification Percent Error', 1 );
resultsToLatex2( [ tabledir, 'class_table_ll.tex'], -likelihoods', method_names, dataset_names, 'Classification Negative Log Likelihood', 1);

resultsToLatex4( [tabledir, 'class_table2.tex'], (1 - accuracy_all) .* 100, method_names, dataset_names, 'Classification Percent Error' );
resultsToBargraph( [ figuredir, 'class_graph.pdf'], (1 - accuracy_all) .* 100, method_names, dataset_names, 'Classification Percent Error', '% Error', [], true );
method_names(hkl_ix) = []; likelihood_all(:,:,hkl_ix) = [];  %remove HKL log likelihood, since it isn't defined.
resultsToLatex4( [tabledir, 'class_table_ll2.tex'], -likelihood_all, method_names, dataset_names, 'Classification Negative Log Likelihood' );
resultsToBargraph( [ figuredir, 'class_graph_ll.pdf'], -likelihood_all, method_names, dataset_names, 'Classification Negative Log Likelihood', 'NLL', [0 1.1], true );
end

%combined_results = zeros( size( likelihoods' ));
%combined_results(:,:,1) = (1 - accuracies') .* 100;
%combined_results(:,:,2) = -likelihoods';
%resultsToLatex3( [ tabledir, 'class_table_all.tex'], combined_results, ...
    %method_names, dataset_names, {'Err\%', 'NLL' }, 'Negative Log Likelihood' );

% Regression results.
[likelihoods, mses, accuracies, dataset_names, method_names, likelihood_all, mse_all, accuracy_all] ...
    = compile_results( regression_datasets, regression_methods, K, outdir, seeds );
dataset_names = shorten_names( dataset_names );
method_names = replace_method_names( method_names );
resultsToLatex2( [ tabledir, 'mse_table.tex'], mses', method_names, dataset_names, 'Regression Mean Squared Error', 1 );
resultsToLatex2( [ tabledir, 'll_table.tex'], -likelihoods', method_names, dataset_names, 'Regression Negative Log Likelihood', 1 );

resultsToLatex4( [tabledir, 'reg_table_mse2.tex'], mse_all, method_names, dataset_names, 'Regression Mean Squared Error' );
resultsToBargraph( [ figuredir, 'reg_graph.pdf'], mse_all, method_names, dataset_names, 'Regression Mean Squared Error', 'MSE', [0 1.2], false );
method_names(hkl_ix) = []; likelihood_all(:,:,hkl_ix) = [];  %remove HKL log likelihood, since it isn't defined.
resultsToLatex4( [tabledir, 'reg_table_ll2.tex'], -likelihood_all, method_names, dataset_names, 'Regression Negative Log Likelihood' );
resultsToBargraph( [ figuredir, 'reg_graph_ll.pdf'], -likelihood_all, method_names, dataset_names, 'Regression Negative Log Likelihood', 'NLL', [-.25 2.5], false );

%combined_results = zeros( size( likelihoods' ));
%combined_results(:,:,1) = sqrt(mses');
%combined_results(:,:,2) = -likelihoods';
%resultsToLatex3( [ tabledir, 'rmse_table_all.tex'], combined_results, ...
    %method_names, dataset_names, {'RMSE', 'NLL' }, 'Negative Log Likelihood' );


print_hyperparameter_tables_lo( K, seeds, outdir );

end

function nicenames = shorten_names( names )
    for i = 1:length(names)
        nicenames{i} = names{i};
        nicenames{i} = strrep(nicenames{i}, '_', ' ' );
        nicenames{i} = strrep(nicenames{i}, '0', '' );
        nicenames{i} = strrep(nicenames{i}, '1', '' );
        nicenames{i} = strrep(nicenames{i}, '2', '' );
        nicenames{i} = strrep(nicenames{i}, '3', '' );
        nicenames{i} = strrep(nicenames{i}, '4', '' );
        nicenames{i} = strrep(nicenames{i}, '5', '' );
        nicenames{i} = strrep(nicenames{i}, '6', '' );
        nicenames{i} = strrep(nicenames{i}, '7', '' );
        nicenames{i} = strrep(nicenames{i}, '8', '' );
        nicenames{i} = strrep(nicenames{i}, '9', '' );        
        nicenames{i} = strrep(nicenames{i}, 'synth ', '' );
        nicenames{i} = strrep(nicenames{i}, 'c ', '' );
        nicenames{i} = strrep(nicenames{i}, 'r ', '' );
        nicenames{i} = strrep(nicenames{i}, 'sola', 'solar' );
        nicenames{i} = strrep(nicenames{i}, 'pumadyn', 'puma'); %dyn-8nh' );        
    end
end

function nicenames = replace_method_names( names )
    for i = 1:length(names)
        nicenames{i} = names{i};
        nicenames{i} = strrep(nicenames{i}, 'gp_ard_class', 'GP Squared-exp' );
        nicenames{i} = strrep(nicenames{i}, 'gp_ard', 'GP Squared-exp' );
        nicenames{i} = strrep(nicenames{i}, 'gp_add_lo_1', 'GP GAM' );
        nicenames{i} = strrep(nicenames{i}, 'gp_add_lo', 'GP Additive' );
        nicenames{i} = strrep(nicenames{i}, 'gp_add_class_lo_1', 'GP GAM' );
        nicenames{i} = strrep(nicenames{i}, 'gp_add_class_lo', 'GP Additive' );
        nicenames{i} = strrep(nicenames{i}, 'lin_model', 'Linear Regression' );
        nicenames{i} = strrep(nicenames{i}, 'logistic', 'Logistic Regression' );
        nicenames{i} = strrep(nicenames{i}, 'hkl_regression', 'HKL' );
        nicenames{i} = strrep(nicenames{i}, 'hkl_classification', 'HKL' );
    end
end
