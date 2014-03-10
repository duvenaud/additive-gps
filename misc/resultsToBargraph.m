% Turns an array of results into a nice LaTeX table.
% This version also print error bars.
%
% Adapted from Ryan Turner's code.
%
% David Duvenaud
% May 2011
% ========================
function resultsToLatex4(filename, results, methodNames, dataNames, ...
  experimentName, metric_name, range, legend)

meanfunc = @mean
stdfunc = @std
results = permute(results, [ 3 2 1 ] );

means = meanfunc(results, 3);
stds = stdfunc(results,1,3);   % 1 or 0 here? unbiasedness, etc.

%file = fopen( filename, 'w');

if ~legend
    methodNames = [];
end

%handles = barweb(means', stds', 1, dataNames, experimentName, methodNames, metric_name);%, bw_colormap, gridstatus, bw_legend, error_sides, legend_type)
%handles = barweb(means', stds', 1, dataNames, experimentName, [], metric_name, [], [], methodNames);%, error_sides, legend_type)

%if numel(range) > 0
%    ylim( range);
%end
%save2pdf(filename, gcf, 600, true );

