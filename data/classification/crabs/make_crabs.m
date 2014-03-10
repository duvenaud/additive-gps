load crabs_numeric.txt;
X = crabs_numeric;
y = X(:,2);
X(:,2) = [];
save crabs.mat