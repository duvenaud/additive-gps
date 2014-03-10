function DEFAULT(var_name, value);
%DEFAULT sets a variable to a default value if undefined or empty
%
%     DEFAULT(var_name, value);
%     DEFAULT('num_iters', 42);
%
% num_iters will have its previous value, or if it wasn't defined or was empty,
% num_iters will now be equal to 42.
%
% Inputs:
%     var_name string
%        value whatever
%
% WARNING: this function is quite slow. Using a less readable alternative -- or
% just insisting that all arguments are set -- is advisable in functions that
% will be called many times in an inner loop.

% Iain Murray, September 2009.
% Documentation updated January 2010.

if evalin('caller', ['~exist(''' var_name ''', ''var'') || isempty(' var_name ')']);
    assignin('caller', var_name, value)
end
