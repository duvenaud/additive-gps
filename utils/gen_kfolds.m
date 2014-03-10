function  [trainfolds, testfolds] = gen_kfolds(N, K, perm)

if nargin < 3
    perm = randperm(N);
end

ndx = 1;
for i=1:K
  low(i) = ndx;
  Nbin(i) = fix(N/K);
  if i==K
    high(i) = N;
  else
    high(i) = low(i)+Nbin(i)-1;
  end
  testfolds{i} = low(i):high(i);
  trainfolds{i} = setdiff(1:N, testfolds{i});
  testfolds{i} = perm(testfolds{i});
  trainfolds{i} = perm(trainfolds{i});
  ndx = ndx+Nbin(i);
end