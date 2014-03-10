% Process bupa liver data
%
% David Duvenaud
% May 2011
%
% Data from:
% http://www.cs.huji.ac.il/~shais/datasets/ClassificationDatasets.html
% ======================================

load liver_raw

% Reset the random seed, always the same for the datafolds.
randn('state', 0);
rand('twister', 0);    

% randomize order
[N,D] = size(data);
perm = randperm(N);
data = data(perm,:);

X = data(:,1:end-1);
y = data(:,end);

y(y>1) = 1;
y(y<1) = -1;

save( 'r_liver.mat', 'X', 'y' );


