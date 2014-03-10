function hhp = common_gp_parameters()
% Defines a common set of parameters for all the GP experiments, just to
% make it harder to accidentally make the wrong comparison.
%
% Called hhp for 'hyper-hyper-parameters'.

hhp.max_iterations = 500;
hhp.max_ard_init_iterations = 500;
hhp.length_scale = 1;
hhp.sd_scale = 0.1;
hhp.add_sd_scale = 0.1;
hhp.noise_scale = 0.1;
hhp.max_order = 10;

% Parameters for gamma prior on lengthscales.
hhp.gamma_a = 2;
hhp.gamma_b = 2;