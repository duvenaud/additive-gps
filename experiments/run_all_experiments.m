% Main script to call all experiments and produce all figures.
%
% David Duvenaud
% March 2011
% ======================

addpath(genpath(pwd))
addpath('../utils/');

K = 10;
seed = 0;
outdir = 'results/';

[classification_datasets, classification_methods, ...
          regression_datasets, regression_methods] = define_datasets_and_methods();
    
fprintf('Running all experiments...\n');
% Run classification experiments.
run_experiment_set( classification_datasets, classification_methods, K, seed, outdir );   
   
% Run regression experiments.
run_experiment_set( regression_datasets, regression_methods, K, seed, outdir );

% Generate tables and figures.
compile_all_results( K, seed, outdir );



