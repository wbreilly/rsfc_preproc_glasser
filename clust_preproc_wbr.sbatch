#!/bin/bash -l 
#
#SBATCH --job-name=full_preproc_8_7_18
#SBATCH --output=/home/wbreilly/parallel_sms_scan_batch_preproc/logs/full_preproc_8_7_18.%j.%N.out
#SBATCH --error=/home/wbreilly/parallel_sms_scan_batch_preproc/logs/full_preproc_8_7_18.%j.%N.err
#SBATCH --nodes=1
#SBATCH -c 30
#SBATCH -p bigmemm
#SBATCH --time=5-00:00:00
#SBATCH --mem-per-cpu=2500 # 3gb % spm max mem set at 2.1gb
#SBATCH --mail-type=ALL
#SBATCH --mail-user=wbreilly@ucdavis.edu

# updated to -c changed matlab scripts to reflect new directory structure

date 
hostname
module load matlab/R2016a # load matlab module 

matlab -nodisplay < cluster_parallel_preproc_wbr.m # run matlab script # added srun
