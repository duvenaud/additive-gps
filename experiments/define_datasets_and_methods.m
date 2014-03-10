function [classification_datasets, classification_methods, ...
          regression_datasets, regression_methods] = define_datasets_and_methods()
    
% Classification
% ==============================================================
      
% Choose datasets.
classification_datasets = {};
test = 0
if test
    classification_datasets{end+1} = 'data/classification/r_sanity_easy.mat';
    classification_datasets{end+1} = 'data/classification/r_sanity_hard.mat';
    %classification_datasets{end+1} = 'data/classification/bach_synth_c_100.mat';
else  
    classification_datasets{end+1} = 'data/classification/r_breast.mat';
    classification_datasets{end+1} = 'data/classification/r_pima.mat';
    classification_datasets{end+1} = 'data/classification/r_sonar.mat';
    classification_datasets{end+1} = 'data/classification/r_ionosphere.mat';
    classification_datasets{end+1} = 'data/classification/r_liver.mat';
    classification_datasets{end+1} = 'data/classification/r_heart.mat';
  %  classification_datasets{end+1} = 'data/classification/r_sanity_easy.mat';
  %  classification_datasets{end+1} = 'data/classification/r_sanity_hard.mat';
end

%classification_datasets{end+1} = 'data/classification/bach_synth_c_100.mat';    
%classification_datasets{end+1} = 'data/classification/bach_synth_c_200.mat';    
%classification_datasets{end+1} = 'data/classification/crabs.mat';

% Choose models. 
classification_methods = {};
classification_methods{end+1} = @logistic;
classification_methods{end+1} = @gp_add_class_lo_1;
classification_methods{end+1} = @hkl_classification;
classification_methods{end+1} = @gp_ard_class;
classification_methods{end+1} = @gp_add_class_lo;

%classification_methods{end+1} = @fail_model;
%classification_methods{end+1} = @gp_add_class_1;
%classification_methods{end+1} = @gp_add_class_2;
%classification_methods{end+1} = @gp_add_class_3;
%classification_methods{end+1} = @gp_add_class_4;
%classification_methods{end+1} = @gp_add_class;
%classification_methods{end+1} = @gp_add_class_grow;
%classification_methods{end+1} = @gp_add_class_grow_vo;
%classification_methods{end+1} = @gp_add_class_vo;
%classification_methods{end+1} = @gp_add_class_grow_lo;
%classification_methods{end+1} = @gp_add_class_lo_ard_init;

% Regression
% ==============================================================

%Choose datasets.
regression_datasets = {};

if test
    %regression_datasets{end+1} = 'data/classification/r_sanity_easy.mat';
    %regression_datasets{end+1} = 'data/classification/r_sanity_hard.mat';
    %regression_datasets{end+1} = 'data/regression/bach_synth_r_100.mat';
else
    regression_datasets{end+1} = 'data/regression/bach_synth_r_200.mat';    
    regression_datasets{end+1} = 'data/regression/r_concrete_500';
    regression_datasets{end+1} = 'data/regression/r_pumadyn512.mat';
    regression_datasets{end+1} = 'data/regression/r_servo.mat';    
    regression_datasets{end+1} = 'data/regression/r_housing.mat';
    %regression_datasets{end+1} = 'data/classification/r_sanity_easy.mat';
    %regression_datasets{end+1} = 'data/classification/r_sanity_hard.mat';   
    %regression_datasets{end+1} = 'data/regression/unicycle_roll_angular_velocity_150.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_yaw_ang_vel_150.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_wheel_ang_vel_150.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_pitch_ang_vel_150.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_turn_table_ang_vel_150.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_x_origin_scc_150.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_y_origin_scc_150.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_roll_angle_150.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_pitch_angle_150.mat';       
end
%regression_datasets{end+1} = 'data/regression/r_solar_500.mat';

    %regression_datasets{end+1} = 'data/regression/unicycle_roll_angular_velocity_100.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_yaw_ang_vel_100.mat';
%    regression_datasets{end+1} = 'data/regression/unicycle_wheel_ang_vel_400.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_pitch_ang_vel_100.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_turn_table_ang_vel_100.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_x_origin_scc_100.mat';
    %regression_datasets{end+1} = 'data/regression/unicycle_y_origin_scc_100.mat';
%    regression_datasets{end+1} = 'data/regression/unicycle_roll_angle_400.mat';
%    regression_datasets{end+1} = 'data/regression/unicycle_pitch_angle_400.mat';       




%regression_datasets{end+1} = 'data/regression/r_concrete_100';
%regression_datasets{end+1} = 'data/regression/pumadyn256.mat';
%regression_datasets{end+1} = 'data/regression/prostate.mat';
%regression_datasets{end+1} = 'data/regression/bach_synth_r_100.mat';
%regression_datasets{end+1} = 'data/regression/bach_synth_r_200.mat';
%regression_datasets{end+1} = 'data/regression/abalone_500.mat'; 
%regression_datasets{end+1} = 'data/regression/add_256.mat';


% Choose models.                    
regression_methods = {};               
regression_methods{end+1} = @lin_model;
regression_methods{end+1} = @gp_add_lo_1;
regression_methods{end+1} = @hkl_regression;
regression_methods{end+1} = @gp_ard;
regression_methods{end+1} = @gp_add_lo;

%regression_methods{end+1} = @fail_model;
%regression_methods{end+1} = @gp_ard_laplace;
%regression_methods{end+1} = @gp_add_1;
%regression_methods{end+1} = @gp_add_2;
%regression_methods{end+1} = @gp_add_3;
%regression_methods{end+1} = @gp_add_4;
%regression_methods{end+1} = @gp_add;
%regression_methods{end+1} = @gp_add_grow;
%regression_methods{end+1} = @gp_add_laplace_1;
%regression_methods{end+1} = @gp_add_laplace_2;
%regression_methods{end+1} = @gp_add_laplace_3;
%regression_methods{end+1} = @gp_add_laplace_4;
%regression_methods{end+1} = @gp_add_laplace;
%regression_methods{end+1} = @gp_add_laplace_grow;
%regression_methods{end+1} = @gp_add_grow_vo;
%regression_methods{end+1} = @gp_add_vo;
%regression_methods{end+1} = @gp_add_grow_lo;
%regression_methods{end+1} = @gp_add_lo_ard_init;
