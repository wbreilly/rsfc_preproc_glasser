%function [b] = smooth_only_wbr(b)

% Writes smoothed volumes independently 
% written by Walter Reilly to save a lot of time

% Usage:
%
%	b = smooth_wbr(b)
%   
%   input arguments:
%
%	b = memolab qa batch structure containing the fields:
%
%       b.dataDir     = fullpath string to the directory where the functional MRI data
%                       is being stored
%
%       b.runs        = cellstring with IDs for each functional time series
%
%       b.auto_accept = a true/false variable denoting whether or not the 
%                       user wants to be prompted
%
%       b.rundir      = a 1 x n structure array, where n is the number of
%                       runs, with the fields:
% 
%       b.rundir.nfiles = all the normalized volumes
% 
%       Output:
% 
%       b.rundir.smfiles  = smoothed volumes

clear all
clc

dataDir     = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/batch_preproc_8_23_17';
scriptdir   = '/Users/wbr/walter/fmri/sms_scan_analyses/sms_scan_batch_preproc'; 

subjects    =  {'s015' 's016' 's018' 's019'};  %{'s001' 's002' 's003' 's004' 's007' 's008' 's009' 's010' 's011'};
runs        = {'Rifa_1' 'Rifa_2' 'Rifa_3' 'Rifa_4' 'Rifa_5' 'Rifa_6' 'Rifa_7' 'Rifa_8' 'Rifa_9'};  

%-- Check for required functions

% SPM
if exist('spm','file') == 0
    error('SPM must be on the path.')
end

fprintf('Smooth Criminal!!\n\n')

for i = 1:length(subjects)
    
    % Define variables for individual subjects - General
    b.curSubj   = subjects{i};
    b.runs      = runs;
    b.dataDir   = fullfile(dataDir, b.curSubj);
        
    % Define variables for individual subjects - QA General
    b.scriptdir   = scriptdir;

    for j = 1:length(b.runs)
        b.rundir(j).sfiles = spm_select('ExtFPListRec', b.dataDir, ['^normalized.*'  b.runs{j} '.*bold\.nii']);
        fprintf('%02d:   %0.0f slicetime files found.\n', i, length(b.rundir(j).sfiles))
    end

    for irun = 1:length(b.runs)
        clear matlabbatch

        %initiate
        % if normalizing, bring back .nfiles
        %matlabbatch{1}.spm.spatial.smooth.data = cellstr(b.rundir(i).nfiles);
        matlabbatch{1}.spm.spatial.smooth.data = cellstr(b.rundir(irun).sfiles);
        matlabbatch{1}.spm.spatial.smooth.fwhm = [3 3 3];
        matlabbatch{1}.spm.spatial.smooth.dtype = 0;
        matlabbatch{1}.spm.spatial.smooth.im = 0;
        matlabbatch{1}.spm.spatial.smooth.prefix = 'smoothed_';

        % run
        spm('defaults','fmri');
        spm_jobman('initcfg');
        spm_jobman('run',matlabbatch);

        % print success
        b.rundir(irun).smfiles = spm_select('ExtFPListRec', b.dataDir, ['^smoothed_norm.*'  b.runs{irun} '.*bold\.nii']);
        fprintf('%02d:   %0.0f smoothed files found.\n', i, length(b.rundir(irun).smfiles))

    end % end i b.runs
end