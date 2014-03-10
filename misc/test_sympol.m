% A quick test script to copmare my version of elsympol to Hannes'.
%
% David Duvenaud
% April 2011
% =================

load good_test_params

% Timing tests
if 0
    tic;
    for i = 1:10000
        elsympol(Z,R);
    end
    toc

    tic;
    for i = 1:10000
        elsympol2(Z,R);
    end
    toc
end

if 1
    Z2 = repmat(Z, 1000, 1000 );
    tic;
    for i = 1:1000
        elsympol(Z,R);
    end
    toc

    tic;
    for i = 1:1000
        elsympol2(Z,R);
    end
    toc
end

% Numerical tests
E1 = squeeze(elsympol(Z,R));
E2 = squeeze(elsympol2(Z,R));

[ E1 E2 ]

E2 - E1
