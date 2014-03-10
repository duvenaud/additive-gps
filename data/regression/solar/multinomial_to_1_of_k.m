function one_of_k = multinomial_to_1_of_k( multinomial)

% assumes multnomial is already numbered 1 to k.

n = numel(multinomial);
d = max(multinomial(:));
one_of_k = zeros(n,d);

for i = 1:n
    one_of_k( i, multinomial(i)) = 1;
end