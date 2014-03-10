% Process solar data
% data from
% http://archive.ics.uci.edu/ml/machine-learning-databases/solar-flare/
%
% David Duvenaud
% May 2011

importdata('flare.data2')
data = ans.data;
textdata = ans.textdata;

% letters to be replaced with integers
reps = {{'A','B','C','D','E','F','H'}, {'X','R','S','A','H','K'},   {'X','O','I','C'}};

% convert letters to numbers
numeric = NaN( size(textdata));
for c = 1:3
    for r = 1:length(textdata)
        for l = 1:length(reps{c})
            if strcmp(reps{c}{l}, textdata{r,c})
                numeric(r,c) = l;
            end
        end
    end
end

% Convert multinomial columns into 1-of-k
c1 = multinomial_to_1_of_k( numeric( :, 1));
c(:,1) = [];  % no A's, I guess.
c2 = multinomial_to_1_of_k( numeric( :, 2));
c3 = multinomial_to_1_of_k( numeric( :, 3));


% append to the beginning of the other numeric columns
%all_data = [numeric data];
all_data = [c1 c2 c3 data];

% sum the number of flares in the last 3 columns
num_flares = sum(all_data(:, end-2:end),2);


% get rid of useless last 3 columns
all_data(:,end-3:end) = [];

% and get rid of useless 1st column
all_data(:,1) = [];

data = [all_data, num_flares];

% Reset the random seed, always the same for the datafolds.
randn('state', 0);
rand('twister', 0);    

% randomize order
[N,D] = size(data);
perm = randperm(N);
data = data(perm,:);

X = data(:,1:end-1);
y = data(:,end);
save( 'r_solar_all.mat', 'X', 'y' );

X = data(1:500,1:end-1);
y = data(1:500,end);
save( 'r_solar_500.mat', 'X', 'y' );
