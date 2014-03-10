function print_hyperparameter_tables( K, seeds, outdir, tabledir )
    if nargin < 1; K = 5; end
    if nargin < 2; seeds = [0:4]; end
    if nargin < 3; outdir = 'results/'; end
    if nargin < 4; tabledir = '/homes/mlghomes/dkd23/Dropbox/papers/NIPS2011_Additive/tables/'; end

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
            make_table( classification_datasets{i}, K, seeds, outdir, tabledir, 1, true, true );
        catch
            disp(lasterror);
        end
    end
    
    for i = 1:length(regression_datasets)
        try
            make_table( regression_datasets{i}, K, seeds, outdir, tabledir, 1, false, false );
            make_table( regression_datasets{i}, K, seeds, outdir, tabledir, 1, false, true );
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
            add_method = @gp_add_lo_ard_init;
        end
    else
        ard_method = @gp_ard_class;
        if grow
            add_method = @gp_add_class_grow_lo;
        else
            add_method = @gp_add_class_lo_ard_init;
        end
    end
    
    [pathstr, nicename, ext, versn] = fileparts( dataset_name );
    if grow
        tex_name = [ nicename, '_hypers_table_grow.tex' ];
    else
        tex_name = [ nicename, '_hypers_table.tex' ];
    end
    fprintf('\\input{tables/%s}\n', tex_name);
    
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
    [add_lengthscales, add_variances, add_orders] = ...
        sort_additive_hypers(D, results.model.hypers.cov);
    add_linear = results.model.hypers.mean(2:end);
    
    % Print a nice latex table to a file.
    hypers_to_latex3([ tabledir, tex_name ], ...
        ard_lengthscales, ard_variance, ...
        add_lengthscales, add_variances, add_orders, ...
        dataset_name, false, ard_linear, add_linear );
end