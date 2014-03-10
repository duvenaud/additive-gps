
function [Xfix, errFix, exponents, prec] = fixMatrix(X, errorBar)

assert(all(size(X) == size(errorBar)));
%assert(all(errorBar(:) > 0));

errorDigits = 2;
maxSigFigs = 6;

Xcols = size(X, 2);

% This way we know the resulting Xfix will never have more than maxSigFigs
% digits, even if the error bars are very small => We don't believe we have
% more than maxSigFigs digits not matter what a t-test says.
errorBar = max(errorBar, exp10(getScale(X) - maxSigFigs + errorDigits));

Xfix = zeros(size(X));
errFix = zeros(size(errorBar));
exponents = zeros(Xcols, 1);
prec = zeros(size(X));
for ii = 1:Xcols
  exponents(ii) = getExpo(errorBar(:, ii));
  Xfix(:, ii) = X(:, ii) * exp10(-exponents(ii));
  errFix(:, ii) = errorBar(:, ii) * exp10(-exponents(ii));
  
  prec(:, ii) = getScale(errFix(:, ii)) - errorDigits + 1;
  % We round our best estimate to the nearest value
  Xfix(:, ii) = roundPrec(Xfix(:, ii), prec(:, ii));
  % We round our error bars up, we would rather overstate our error bars
  % than under state them.
  errFix(:, ii) = ceilPrec(errFix(:, ii), prec(:, ii));
end

function S = getScale(X)
S = floor(log10(X));

function E = getExpo(X) 
E = min(getScale(X)) + 1;
% OR:
% E = max(getScale(X)) - 1;
% for the other constraint

function X = roundPrec(X, prec)

y = exp10(prec);
X = round(X ./ y) .* y;

function X = ceilPrec(X, prec)

y = exp10(prec);
X = ceil(X ./ y) .* y;
