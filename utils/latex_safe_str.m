function str = latex_safe_str( str )
% Just strips out characters that bother latex.

str = strrep( str, '_', ' ');