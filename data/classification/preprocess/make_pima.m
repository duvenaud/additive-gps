load pima-indians-diabetes.data;
X = pima_indians_diabetes;
y = X(:,end);
X = X(:,1:end-1);
y(y==0) = -1;
save pima.mat