% Preprocess abalone dataset
% David Duvenaud
% May 2011
% ==============


fid = fopen('abalone_raw.data');
C = textscan(fid,'%s%f%f%f%f%f%f%f%f');
fclose(fid);

% Turn tri-valued discrete variable into two binary variables.
infant = strcmp(C{1},'I');
male = strcmp(C{1},'M');

X = [ infant male C{2:end-1} ];
y = C{end};

save( 'abalone_all.mat', 'X', 'y' );

X(501:end,:) = [];
y(501:end) = [];
save( 'abalone_500.mat', 'X', 'y' );
