function [] = preproc_wbr()
% tweaking to preprocess Halle's RSFC data
% Walter Reilly's spm preproc script, adapted from Maureen Ritchey

%====================================================================================
%			Specify Variables
%====================================================================================

%-- File Type
% Are you using DCM or NII files? If NII, they should be unprocessed
% .*\.nii files. Alternatively they can be a 4D .nii file (single file per
% run; can be .*\.nii or .*\.nii.gz, although gz files will be unzipped for
% SPM). 'DCM' or 'NII'. Note: this QA routine is NOT compatible with
% .img/.hdr. Please convert .img/.hdr to .nii prior to running routine.

fileType    = 'DCM';

%-- Directory Information
% Paths to relevant directories.
% dataDir   = path to the directory that houses the MRI data
% scriptdir = path to directory housing this script (and auxiliary scripts)
% QAdir     = Name of output QA directory

dataDir     = '/Users/wbr/walter/fmri/rsfc_glasser_halledata';
scriptdir   = '/Users/wbr/walter/fmri/rsfc_preproc_glasser'; % fileparts(mfilename('fullpath'));


%-- Info for Subjects
% Subject-specific information.
% subjects  = cellstring containing the subject IDs
% runs      = cellstring containg the IDs for each BOLD time series
%
% Assumes that all files have unique filenames that can be identified with
% a combination of the cell strings above. For example, bold files NEED to
% look something like:
%   /dataDir/sub-001/func/sub-001_encoding_run-001_bold.nii
%   /dataDir/sub-001/func/sub-001_encoding_run-002_bold.nii
%   /dataDir/sub-001/func/sub-001_retrieval_run-001_bold.nii
%   /dataDir/sub-001/func/sub-001_retrieval_run-002_bold.nii
%
%  See BIDS format

subjects    = {'s202'	's203'	's212'	's217'	's223'	's228'	's233'	's238' 's244'	's249'  's207'	's208' ...	
               's213'	's218'	's224'	's229'	's234'  's240'	's245'	's250' 's204'	's209'	's214'	's219' ...	
               's225'	's230'	's235'	's241'	's246'  's205'	's210'	's215'	's220'	's226'	's231'	's236' ...	
               's242'	's247'  's206'	's211'	's216'	's221'	's227'	's232'	's237'	's243'	's248'};
runs        = {'005_bold_rest_5minX5' '006_bold_rest_5minX5' '007_bold_rest_5minX5' '008_bold_rest_5minX5' '009_bold_rest_5minX5'};  

%-- Auto-accept
% Do you want to run all the way through without asking for user input?
% if 0: will prompt you to take action;
% if 1: skips realignment and ArtRepair if already run, overwrites output files
auto_accept = 0;

%% function flags. if 0 don't do
origin_flag = 0;
slice_flag = 0; % when this is set to 0 files are gotten from .files not .sfiles. Need to change file paths back if 1
realign_flag = 1;
coreg_flag = 1;
smooth_flag = 0;
%%



%====================================================================================
%			Routine (DO NOT EDIT BELOW THIS BOX!!)
%====================================================================================

%-- Clean up

clc
fprintf('Initializing and checking paths.\n')

%-- Add paths
addpath(genpath(fullfile(scriptdir, 'functions')));
if exist(fullfile(scriptdir, 'vendor'),'dir')
    addpath(genpath(fullfile(scriptdir, 'vendor')));
end

%-- Check for required functions

% SPM
if exist('spm','file') == 0
    error('SPM must be on the path.')
end

fprintf('Running preproc script')

%% parallel
% start the matlabpool with maximum available workers
% control how many workers by setting ntasks in your sbatch script
% pc = parcluster('local');
% poolobj = parpool(pc, 2);

%%
    
    %--Loop over subjects
for i = 1 %length(subjects)
    
    % Define variables for individual subjects - General
    b.curSubj   = subjects{i};
    b.runs      = runs;
    b.dataDir   = fullfile(dataDir, b.curSubj);
    
    %%% Alternatively, if there is an initializeVars script set up, call that
    %%% see https://github.com/ritcheym/fmri_misc/tree/master/batch_system    
    %     b = initializeVars(subjects,i);
    
     % Define variables for individual subjects - QA General
    b.scriptdir   = scriptdir;
    b.auto_accept = auto_accept;
    b.messages    = sprintf('Messages for subject %s:\n', subjects{i});
    
    % Initialize diary for saving output
    diaryname = fullfile(b.dataDir, 'rsfc_halle_preproc.txt');
    diary(diaryname);
    
    % Convert dicom images or find nifti images
    if strcmp(fileType, 'DCM')
        fprintf('--Converting DCM files to NII format--\n')
        [b] = convert_dicom(b);
        fprintf('------------------------------------------------------------\n')
        fprintf('\n')
    elseif strcmp(fileType, 'NII')
        fprintf('--Finding NII files (no DCM conversion required)--\n')
        [b] = find_nii(b);
        fprintf('------------------------------------------------------------\n')
        fprintf('\n')
    else
        error('Specify a valid fileType (''DCM'' or ''NII'')');
    end
    
%     Set origin in mprage to AC
    if origin_flag
        fprintf('Set origin to AC!')
        [b] = set_origin(b);
        fprintf('------------------------------------------------------------\n')
        fprintf('\n')     
    end

    % run slice time correction
    if slice_flag
        fprintf('--Running slicetime correction--\n')
        [b] = slicetime_correct(b);
        fprintf('------------------------------------------------------------\n')
        fprintf('\n')
    end
   
    % Run realignment
    if realign_flag
        fprintf('--Realigning and reslicing images using spm_realign and spm_reslice--\n')
        [b] = batch_spm_realign(b);
        fprintf('------------------------------------------------------------\n')
        fprintf('\n')
    end
    
%     Run coregistration (estimate)
    if coreg_flag
        fprintf('--Coregistering images--\n')
        [b] = coregister_estimate(b);
        fprintf('------------------------------------------------------------\n')
        fprintf('\n')
    else
        fprintf('--Skipping coregistration--\n')
        fprintf('------------------------------------------------------------\n')
        fprintf('\n')
    end
    
% %     Run normalization estimate
%     fprintf('--Normalize estimating--\n')
%     [b] = normalize_estimate(b);
%     fprintf('------------------------------------------------------------\n')
%     fprintf('\n')
%     
%     % Run normalization write
%     fprintf('--Normalize writing--\n')
%     [b] = normalize_write(b);
%     fprintf('------------------------------------------------------------\n')
%     fprintf('\n')
    
% %     Run smooth
    if smooth_flag
        fprintf('--Smoothing--\n')
        [b] = smooth_wbr(b);
        fprintf('------------------------------------------------------------\n')
        fprintf('\n')
    end
    
end % i (subjects)

fprintf('Done preproc script\n')
diary off

end % main function