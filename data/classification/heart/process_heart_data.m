% Process heart data
%
% David Duvenaud
% May 2011
%
% Data from:
% http://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/
%
% Using the cleveland dataset.
% ======================================

load heart_raw

% Reset the random seed, always the same for the datafolds.
randn('state', 0);
rand('twister', 0);    

% randomize order
[N,D] = size(data);
perm = randperm(N);
data = data(perm,:);

X = data(:,1:end-1);
y = data(:,end);
save( 'r_concrete_1030.mat', 'X', 'y' );

X = data(1:500,1:end-1);
y = data(1:500,end);
save( 'r_concrete_500.mat', 'X', 'y' );

X = data(1:100,1:end-1);
y = data(1:100,end);
save( 'r_concrete_100.mat', 'X', 'y' );
