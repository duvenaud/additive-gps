function filename = run_one_fold( dataset, method, K, fold, seed, outdir, skip )

% Run one fold of one experiment.
%
% David Duvenaud
% March 2011
% ===========================

% Generate the filename for this fold.
[ia, shortname] = fileparts(dataset);
filename = sprintf( '%s%s_%s_fold_%d_of_%d_seed_%d.mat', ...
                    outdir, shortname, func2str(method), fold, K, seed );

% Set skip to true if you want to just find what the filename for this
% experiment would be.
if skip
    return;
end

% Save the text output.
diary( [filename '.txt' ] );

fprintf('\n\nRunning\n');
fprintf('          Method: %s\n', func2str(method) );
fprintf('         Dataset: %s \n', shortname );
fprintf('            Fold: %d of %d \n', fold, K );
fprintf('            Seed: %d \n', seed );
fprintf('Output directory: %s \n', outdir );
fprintf(' Output filename: %s\n', filename );

try   
    % Loading the dataset.  The dataset should contain:
    % X: an n x d matrix
    % y: a  n x 1 vector    
    load(dataset);    
    assert(size(X,1) == size(y,1));
    assert(size(y,2) == 1 );

    % Normalize the data.
    X = X - repmat(mean(X), size(X,1), 1 );
    X = X ./ repmat(std(X), size(X,1), 1 );

    % Only normalize the y if it's not a classification experiment. Hacky.
    if ~all(y == 1 | y == -1 )
        y = y - mean(y);
        y = y / std(y);
    end


    % Reset the random seed, always the same for the datafolds.
    randn('state', 0);
    rand('twister', 0);    
    % Generate the folds, which should be the same for each call.
    %perm = randperm(size(y,1));
    perm = 1:size(y,1); fprintf('\n Not randomizing dataset order\n');
    [trainfolds, testfolds] = gen_kfolds(length(y), K, perm);
    
    % Reset the random seed.
    randn('state', seed);
    rand('twister', seed);    
    % Run the experiment.
    timestamp = now;
    tic;           
    [predictions, loglik, model ] = ...
                method( X(trainfolds{fold},:), y(trainfolds{fold}), ...
                        X(testfolds{fold},:), y(testfolds{fold}) );
    train_time = toc;
    actuals = y(testfolds{fold});

    % Save all the results.        
    save( filename, 'loglik', 'predictions', 'actuals', 'model', ...
        'train_time', 'trainfolds', 'testfolds', ...
        'K', 'fold', 'seed', 'outdir', 'timestamp' );
    fprintf('Saved to %s\n', filename );
catch
    disp(lasterror);
end
diary off

