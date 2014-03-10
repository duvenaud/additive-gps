% Make dataset
clear
load Dataset.data
Dataset(1025:end,:) = [];
y = Dataset(:,end);
X = Dataset(:,1:end-1);
clear Dataset
save add_1024.mat


X(513:end,:) = [];
y(513:end) = [];
save add_512.mat


X(257:end,:) = [];
y(257:end) = [];
save add_256.mat