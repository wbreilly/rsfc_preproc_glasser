#!/bin/bash 
# export ANTSPATH=${HOME}/bin/ants/bin/
# export PATH=${ANTSPATH}:$PATH

# This shell script takes the warp parameters used to align the MNI template to subject space in the ZooCon dataset, and uses those to align ROIs to subject space.
# To execute, pass in subject as a variable after calling the script (I highly recommend looping).
# For further info on antsApplyTransforms, see: http://manpages.ubuntu.com/manpages/yakkety/man1/antsApplyTransforms.1.html
# N.B. antsRegistrationSynQuick.sh was used to generate the Affine file called below.
# N.B. if more ROIs are desired, simply draw or register them onto the 1mm MNI template and add lines below as needed.
# Hastily and inefficiently written by Z. Reagh 10/11/17.

# full affine file name s202_aligned_MNI_0GenericAffine.mat 

# the call srun write_rois.sh $t1_image $SUBJECTS_DIR $SEED
# t1_image is the mprage for the subject, same version used in coregistration and in antsRegistrationSyN.sh
# SUBJECTS_DIR is the mprage folder and $SEED is the subject number/seed in the array.txt of subject names for array job

echo "Aligning ROIs for" $1 "..."
antsApplyTransforms -d 3 -i /home/wbreilly/halle_data_ants_crick/mtl_probabilistic_masks/HIPP_BODY_L_mask.nii.gz -o $2/HIPP_BODY_L_mask_$1.nii.gz -r $1 -t $2/$3\_aligned_MNI_0GenericAffine.mat -n NearestNeighbor
antsApplyTransforms -d 3 -i /home/wbreilly/halle_data_ants_crick/mtl_probabilistic_masks/HIPP_BODY_R_mask.nii.gz -o $2/HIPP_BODY_R_mask_$1.nii.gz -r $1 -t $2/$3\_aligned_MNI_0GenericAffine.mat -n NearestNeighbor
antsApplyTransforms -d 3 -i /home/wbreilly/halle_data_ants_crick/mtl_probabilistic_masks/HIPP_HEAD_L_mask.nii.gz -o $2/HIPP_HEAD_L_mask_$1.nii.gz -r $1 -t $2/$3\_aligned_MNI_0GenericAffine.mat -n NearestNeighbor
antsApplyTransforms -d 3 -i /home/wbreilly/halle_data_ants_crick/mtl_probabilistic_masks/HIPP_HEAD_R_mask.nii.gz -o $2/HIPP_HEAD_R_mask_$1.nii.gz -r $1 -t $2/$3\_aligned_MNI_0GenericAffine.mat -n NearestNeighbor
antsApplyTransforms -d 3 -i /home/wbreilly/halle_data_ants_crick/mtl_probabilistic_masks/HIPP_TAIL_L_mask.nii.gz -o $2/HIPP_TAIL_L_mask_$1.nii.gz -r $1 -t $2/$3\_aligned_MNI_0GenericAffine.mat -n NearestNeighbor
antsApplyTransforms -d 3 -i /home/wbreilly/halle_data_ants_crick/mtl_probabilistic_masks/HIPP_TAIL_R_mask.nii.gz -o $2/HIPP_TAIL_R_mask_$1.nii.gz -r $1 -t $2/$3\_aligned_MNI_0GenericAffine.mat -n NearestNeighbor
antsApplyTransforms -d 3 -i /home/wbreilly/halle_data_ants_crick/mtl_probabilistic_masks/PHC_L_mask.nii.gz -o $2/PHC_L_mask_$1.nii.gz -r $1 -t $2/$3\_aligned_MNI_0GenericAffine.mat -n NearestNeighbor
antsApplyTransforms -d 3 -i /home/wbreilly/halle_data_ants_crick/mtl_probabilistic_masks/PHC_R_mask.nii.gz -o $2/PHC_R_mask_$1.nii.gz -r $1 -t $2/$3\_aligned_MNI_0GenericAffine.mat -n NearestNeighbor
antsApplyTransforms -d 3 -i /home/wbreilly/halle_data_ants_crick/mtl_probabilistic_masks/PRC_L_mask.nii.gz -o $2/PRC_L_mask_$1.nii.gz -r $1 -t $2/$3\_aligned_MNI_0GenericAffine.mat -n NearestNeighbor
antsApplyTransforms -d 3 -i /home/wbreilly/halle_data_ants_crick/mtl_probabilistic_masks/PRC_R_mask.nii.gz -o $2/PRC_R_mask_$1.nii.gz -r $1 -t $2/$3\_aligned_MNI_0GenericAffine.mat -n NearestNeighbor


# antsApplyTransforms -d 3 -i ./DML_MTL_ROIs/vmpfc_mask.nii.gz -o ./Aligned_ROIs/vmpfc_mask_$1.nii.gz -r $1 -t ./ANTs_MNI2sub/aligned_MNI_$1\0GenericAffine.mat -n NearestNeighbor
# echo "Done!"