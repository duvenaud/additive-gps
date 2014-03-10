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

y(y>0) = 1;
y(y<0) = -1;

save( 'r_heart.mat', 'X', 'y' );


