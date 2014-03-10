function gradient_good = check_grad( f, g, x, varargin )

eps = 1e-6;
numerical_gradient = (f(x, varargin{:}) - f(x + eps, varargin{:})) / eps
analytic_gradient = g(x, varargin{:})

gradient_good = abs( numerical_gradient - analytic_gradient ) < 1e-3;