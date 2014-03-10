function print_hyperparameter_tables_lo( K, seeds, outdir, tabledir )
    if nargin < 1; K = 5; end
    if nargin < 2; seeds = [0:4]; end
    if nargin < 3; outdir = 'results/'; end
    if nargin < 4; tabledir = '../../../old/tables_additive_uni/'; end

    %addpath('../utils/');
    % Print some tables of hyperparameters.
    % Todo: make it choose the best ones instead.
    %make_table( 'data/regression/servo.mat', 'servo_hypers_table.tex', K, seeds, outdir, tabledir, 1 );
    %make_table( 'data/regression/housing.mat', 'housing_hypers_table.tex', K, seeds, outdir, tabledir, 1 );
    %make_table( 'data/classification/pima.mat', 'pima_hypers_table.tex', K, seeds, outdir, tabledir, 2, true );
    %make_table( 'data/classification/bach_synth_c_200.mat', 'synth_c_hypers_table.tex', K, seeds, outdir, tabledir, 1, true );

    [classification_datasets, classification_methods, ...
              regression_datasets, regression_methods] = define_datasets_and_methods();

    for i = 1:length(classification_datasets)
        try
            make_table( classification_datasets{i}, K, seeds, outdir, tabledir, 1, true, false );
      %      make_table( classification_datasets{i}, K, seeds, outdir, tabledir, 1, true, true );
        catch
            disp(lasterror);
        end
    end
    
    for i = 1:length(regression_datasets)
        try
            make_table( regression_datasets{i}, K, seeds, outdir, tabledir, 1, false, false );
       %     make_table( regression_datasets{i}, K, seeds, outdir, tabledir, 1, false, true );
        catch
            disp(lasterror);
        end          
    end
end

function make_table( dataset_name, K, seeds, outdir, tabledir, fold, classification, grow )

    if nargin < 7; classification = false; end
    if nargin < 8; grow = false; end
    
    if classification == false
        ard_method = @gp_ard;
        
        if grow
            add_method = @gp_add_grow_lo;
        else
            add_method = @gp_add_lo;
        end
    else
        ard_method = @gp_ard_class;
        if grow
            add_method = @gp_add_class_grow_lo;
        else
            add_method = @gp_add_class_lo;
        end
    end
    
    [pathstr, nicename] = fileparts( dataset_name );
    if grow
        tex_name = [ nicename, '_hypers_table_grow.tex' ];
        growtext = '_grow';
    else
        tex_name = [ nicename, '_hypers_table.tex' ];
        growtext = '';
    end
    fprintf('\\input{tables/%s}\n', tex_name);
    nicename = shorten_names( nicename );
    
    % Find the filename where the ARD hyperparameters should be stored.
    filename = run_one_fold( dataset_name, ard_method, K, fold, seeds(1), outdir, true );
    
    % Load and parse ARD hyperparameters.
    results = load( filename );
    D = length(results.model.hypers.cov) - 1;
    ard_lengthscales = exp(results.model.hypers.cov(1:D));
    ard_linear = results.model.hypers.mean(2:end);
    ard_variance = exp(2*results.model.hypers.cov(D+1));
    
    % Find the filename where the ADD hyperparameters should be stored.
    filename = run_one_fold( dataset_name, add_method, K, fold, seeds(1), outdir, true );
    
    % Load and parse ADD hyperparameters.
    results = load( filename );
    [add_lengthscales, add_orders] = ...
        sort_additive_hypers_lo(D, results.model.hypers.cov);
    add_variances = [];
    add_linear = results.model.hypers.mean(2:end);    
    
    % Print a nice latex table to a file.
    hypers_to_latex3([ tabledir, tex_name ], ...
        ard_lengthscales, ard_variance, ...
        add_lengthscales, add_variances, add_orders, ...
        [nicename, growtext], false, ard_linear, add_linear );
end

function nicename = shorten_names( nicename )
    nicename = strrep(nicename, '_', ' ' );
    nicename = strrep(nicename, '0', '' );
    nicename = strrep(nicename, '1', '' );
    nicename = strrep(nicename, '2', '' );
    nicename = strrep(nicename, '3', '' );
    nicename = strrep(nicename, '4', '' );
    nicename = strrep(nicename, '5', '' );
    nicename = strrep(nicename, '6', '' );
    nicename = strrep(nicename, '7', '' );
    nicename = strrep(nicename, '8', '' );
    nicename = strrep(nicename, '9', '' );        
    nicename = strrep(nicename, 'synth ', '' );
    nicename = strrep(nicename, 'c ', '' );
    nicename = strrep(nicename, 'r ', '' );
    nicename = strrep(nicename, 'sola', 'solar' );
    nicename = strtrim(nicename);
end
