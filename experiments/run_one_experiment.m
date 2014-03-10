% This function is designed to call an experiment, where everything is
% indexed by integers so that it's easy to call from a shell script.
%
% David Duvenaud
% March 2011
% =================

function run_one_experiment(method_number, dataset_number, K, fold, class, seed, outdir)

% Set defaults.
if nargin < 1; method_number = 1; end
if nargin < 2; dataset_number = 1; end
if nargin < 3; K = 5; end
if nargin < 4; fold = 1; end
if nargin < 5; class = 1; end
if nargin < 6; seed = 0; end
if nargin < 7; outdir = 'results/'; end

% If calling from the shell, all inputs will be strings, so we need to
% convert them to numbers.
if isstr(method_number); method_number = str2double(method_number); end
if isstr(dataset_number); dataset_number = str2double(dataset_number); end
if isstr(K); K = str2double(K); end
if isstr(fold); fold = str2double(fold); end
if isstr(class); class = str2double(class); end
if isstr(seed); seed = str2double(seed); end


fprintf('Running one experiment...\n');

addpath(genpath(pwd))
addpath('../utils/');

[classification_datasets, classification_methods, ...
          regression_datasets, regression_methods] = define_datasets_and_methods();
      
if class == 1
    % Classification
    dataset = classification_datasets{dataset_number}
    method = classification_methods{method_number}
else
    % Regression
    dataset = regression_datasets{dataset_number}
    method = regression_methods{method_number}
end

% Run experiments.
run_one_fold( dataset, method, K, fold, seed, outdir, 0 );

