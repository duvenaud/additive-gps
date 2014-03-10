function randomize_dataset_orders

[classification_datasets, classification_methods, ...
              regression_datasets, regression_methods] = define_datasets_and_methods()

    for i = 1:length(classification_datasets)
        randomize_dataset_order( classification_datasets{i} )
    end

    for i = 1:length(regression_datasets)
        randomize_dataset_order( regression_datasets{i} )
    end

end


function randomize_dataset_order( filename )


    
    [pathstr, name, ext, versn] = fileparts(filename);
    new_filename = [pathstr, '/r_', name, ext]
    load(filename)
    
    % Reset the random seed, always the same for the datafolds.
    randn('state', 0);
    rand('twister', 0);
    
    [N,D] = size(X);
    perm = randperm(N);


    X = X(perm,:);
    y = y(perm);
    
    save( new_filename, 'X', 'y' );
end
