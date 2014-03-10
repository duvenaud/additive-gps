#!/bin/bash
#
# Script to submit a job for every single experiment that needs to be done.
#
# David Duvenaud
# March 2011
# ==================================


for K in 5
do
	for Seed in {0..4}
	do
		for fold in {1..5}
		do
			# Classification jobs
			for dataSetNum in {1..7}
			do
				for methodNum in {1..7}
				do
				    echo "run_one_job.sh $methodNum $dataSetNum $fold 1 $K $Seed"
				done
			done
			# Regression jobs
			for dataSetNum in {1..8}
			do
				for methodNum in {1..13}
				do
                     echo "run_one_job.sh $methodNum $dataSetNum $fold 0 $K $Seed"
				done
			done
		done
	done
done
