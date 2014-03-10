function run_experiment_set( datasets, methods, K, seed, outdir )

% Run one set of experiments,
% of all combinations of datasets and methods.
%
% David Duvenaud
% March 2011
% ===========================

if nargin < 3; K = 5; end
if nargin < 4; seed = 0; end
if nargin < 5; outdir = 'results/'; end

for fold = 1:K            
    
    for d_ix = 1:length(datasets)
    dataset = datasets{d_ix};
    
        for m_ix = 1:length(methods)        
            method = methods{m_ix};
         
            run_one_fold(dataset, method, K, fold, seed, outdir, false)
        end
    end        
end
