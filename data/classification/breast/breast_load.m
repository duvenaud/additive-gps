% load the Wisconsin Breast Cancer dataset (with ? removed)
function [xtrain, ytrain, xtest, ytest] = breast_load(seed, ntrain)

% use pseudo randomness, to shuffle dataset
if nargin==0, seed = 0; end
rand('state',seed)

% crabs data
fd = fopen('breast.data','r');
X = [];
while ~feof(fd)
    lin = fgetl(fd);
    lin = sscanf(lin,'%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d')';
    X = [X; lin];
end
fclose(fd);

X = X(:,2:end);         % remove id
Xu = unique(X, 'rows'); % keep unique datapoints (x,y) only (449 out of 683)

% set belign=2 (-1)  and malignant=4 (+1) as label
y = Xu(:,10)-3;
x = Xu(:,1:9); clear X

% standardize data to zero mean and unit variance per dimension
[n,D] = size(x);
x = x - repmat(mean(x),[n,1]); % remove mean
x = x*diag(1./(std(x)+eps));

% split into random train (50) and test set (399) for validation
%ntrain  = 50;
id = randperm(length(y)); 
idtrain =  id(       1:ntrain);
idtest  =  id(ntrain+1:end   );
ytrain  = y(idtrain,1); xtrain = x(idtrain,:)';
ytest   = y(idtest ,1); xtest  = x(idtest ,:)';
