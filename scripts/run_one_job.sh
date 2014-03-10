#!/bin/sh
#
# the next line is a "magic" comment that tells codine to use bash
#$ -S /bin/bash
#
# This script should be what is passed to qsub; its job is just to run one matlab job.

/usr/local/apps/matlab/matlabR2007a/bin/matlab -nodisplay -nojvm -logfile "logs/matlab_log_$1_$2_$3_$4_5_fold.txt" -r "ls; cd /home/mlg/dkd23/Dropbox/code/additive_v3/; ls; run_one_experiment($1,$2, $5, $3, $4, $6, 'results/'); exit" 
                                                                                                                                                                          #method_number, dataset_number, K, fold, class, seed, outdir
