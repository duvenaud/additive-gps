function check_grads

    D = 10;
    X = randn( 20, D );
    y = randn( 20, 1 );
    
    
    cov = [ log(1*ones(1,3*D)), log(ones(1,D))]';
    
    %[ nlz, dnlz] = add_gp_SEiso( cov, X, y )
    [ nlz, dnlz] = add_gp_periodic( cov, X, y )

    eps = 1e-6;
    %checkgrad( 'add_gp_SEiso', cov, eps, X, y )
        cov = [ log(1*ones(1,3*D)), log(ones(1,D))]';
    checkgrad( 'add_gp_periodic', cov, eps, X, y )
end

