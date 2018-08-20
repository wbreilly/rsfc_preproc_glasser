#!/bin/bash -l 
#
#SBATCH --job-name=glasser_rois_8_19_18
#SBATCH --output=/home/wbreilly/halle_data_glasser_rois/logs/glasser_rois_8_19_18.%j.%N.out
#SBATCH --error=/home/wbreilly/halle_data_glasser_rois/logs/glasser_rois_8_19_18.%j.%N.err
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH --time=5-00:00:00
#SBATCH -p bigmemm
#SBATCH --mem-per-cpu=2000 
#SBATCH --mail-type=ALL
#SBATCH --mail-user=wbreilly@ucdavis.edu
#SBATCH --array=2-47


date 
hostname
module load freesurfer/6.0.0
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# export ANTSPATH=/group/dml/apps/ants/bin
# export PATH=${ANTSPATH}:$PATH

# export script_path=/home/wbreilly/halle_data_glasser_rois/freesurfer_scripts
# export PATH=${script_path}:$PATH

SEEDFILE=/home/wbreilly/halle_data_glasser_rois/sub_array.txt # this is a file with the subjects to run one line for each subject i.e. sub01 sub02 etc.
SEED=$(cat $SEEDFILE | head -n $SLURM_ARRAY_TASK_ID | tail -n 1) 

# SUBJECTS_DIR=/home/wbreilly/halle_data_ants_crick/$SEED/002_mprage_sag_NS_g3

# cd $SUBJECTS_DIR
# echo $SUBJECTS_DIR

# t1_image="$(ls s*.nii)"
# echo $t1_image

srun rsfc_cluster_create_subj_volume_parcellation.sh -L $SEEDFILE -a HCP-MMP1 -d MMP1_native -f $SLURM_ARRAY_TASK_ID -l $SLURM_ARRAY_TASK_ID

