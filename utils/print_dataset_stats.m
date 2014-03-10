function [ table, dataset_names ] = print_dataset_stats( datasets )
% Print some stats about the datasets.
% 
% David Duvenaud
% March 2011
% ===========================

table = NaN( length(datasets), 2);

for d_ix = 1:length(datasets)
    cur_dataset = datasets{d_ix};
    [~, shortname, ~, ~] = fileparts(cur_dataset);   
    dataset_names{d_ix} = shortname;
    load(cur_dataset);
    [table(d_ix,1), table(d_ix, 2)] = size(X);
end

% Now make figures and tables.
fprintf('\n\n');
print_table( 'Dataset Stats', dataset_names, {'N', 'D'}, table );
