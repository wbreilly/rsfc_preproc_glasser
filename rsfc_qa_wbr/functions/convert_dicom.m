function [b] = convert_dicom(b)
% CONVERT_DICOM  converts dicom files and stores paths in the b structure
%
%   Intended for use with memolab_batch_qa.
%   Written by Maureen Ritchey (BC, Davis), circa 2014
%   
%   Usage:
%
%	b = convert_dicom(b)
%   
%   input arguments:
%
%	b = memolab qa batch structure containing the fields:
%
%       b.runs      = cellstring with the name of the directories containing
%                     each functional run
%
%       b.dataDir   = fullpath string to the directory where the functional MRI data
%                     is being stored
%
%       b.rundir    = a 1 x n structure array, where n is the number of
%                     runs
%
%       b.scriptdir = fullpath string to the directory where the memolab
%                     scripts
%
%   output arguments:
%
%   b = memolab qa batch structure containg the new fields:
%
%       b.rundir(n).files = a character array containg the full paths to
%                           the recently converted .*\.nii files
%
%
% See also: find_nii, spm_dicom_headers, spm_dicom_convert

%%
% Default Maureen way didn't work for me
%%
% for irun = 1:length(b.runs)
%     
%     rundir   = fullfile(b.dataDir, b.runs{irun});
%     dcmfiles = spm_select('FPList', rundir, '.*dcm');
%     fprintf('In directory %s:\n%0.0f dcm files found...\n', rundir, size(dcmfiles,1));
%     
%     % Check whether there are already nifti files
%     niifiles = spm_select('FPList', rundir, '.*\.nii');
%     if size(niifiles, 1) > 0
%         fprintf('There are already %0.0f nii files in this folder.\n', size(niifiles,1));
%         response = input('Are you sure you want to use dicom files? y/n \n', 's');
%         if strcmp(response,'y') == 1
%             disp('Continuing running dicom conversion')
%         else
%             error('Change fileType to ''NII''')
%         end
%     end
%     
%     % Convert dicom images
%     dcmhdr    = spm_dicom_headers(dcmfiles);
%     cd(rundir);
%     dcmoutput = spm_dicom_convert(dcmhdr, 'all', 'flat', 'nii');
%     
%     b.rundir(irun).files = cell2mat(dcmoutput.files);
%     fprintf('%0.0f files converted to nii.\n', size(b.rundir(irun).files, 1));
%     
%     
%     %%%%%% added by wbr to adopt naming convention
%     matlabbatch{1}.spm.util.cat.vols = cellstr(spm_select('FPListRec', rundir, '^*.nii'));
%     matlabbatch{1}.spm.util.cat.name = sprintf('%s.%s.bold.nii',b.curSubj, b.runs{irun});
%     matlabbatch{1}.spm.util.cat.dtype = 4;
%     spm('defaults','fmri');
%     spm_jobman('initcfg');
%     spm_jobman('run',matlabbatch);
%     
%     delete f*.nii
%     b.rundir(irun).files = sprintf('%s/%s/%s.%s.bold.nii',b.dataDir,b.runs{irun}, b.curSubj, b.runs{irun});
%     
%     cd(b.scriptdir);
%     
% end
% 
% 
% end

for irun = 1:length(b.runs)
    
    rundir   = fullfile(b.dataDir, b.runs{irun});
    dcmfiles = spm_select('FPList', rundir, '.*dcm');
    fprintf('In directory %s:\n%0.0f dcm files found...\n', rundir, size(dcmfiles,1));
    
    % Check whether there are already nifti files
    niifiles = spm_select('FPList', rundir, '.*\.nii');
    if size(niifiles, 1) > 0
        fprintf('There are already %0.0f nii files in this folder.\n', size(niifiles,1));
        response = input('Are you sure you want to use dicom files? y/n \n', 's');
        if strcmp(response,'y') == 1
            disp('Continuing running dicom conversion')
        else
            error('Change fileType to ''NII''')
        end
    end
    
    % Convert dicom images
    dcmhdr    = spm_dicom_headers(dcmfiles);
    cd(rundir);
    dcmoutput = spm_dicom_convert(dcmhdr, 'all', 'flat', 'nii');
    
    b.rundir(irun).files = cell2mat(dcmoutput.files);
    fprintf('%0.0f files converted to nii.\n', size(b.rundir(irun).files, 1));
    
    
    %%%%%% added by wbr to adopt naming convention
    matlabbatch{1}.spm.util.cat.vols = cellstr(spm_select('FPListRec', rundir, '^*.nii'));
    matlabbatch{1}.spm.util.cat.name = sprintf('%s.%s.bold.nii',b.curSubj, b.runs{irun});
    matlabbatch{1}.spm.util.cat.dtype = 4;
    spm('defaults','fmri');
    spm_jobman('initcfg');
    spm_jobman('run',matlabbatch);
    
    delete f*.nii
    b.rundir(irun).files = spm_select('ExtFPListRec', b.dataDir, ['^.*'  b.runs{irun} '.*bold\.nii']);

    cd(b.scriptdir);
    
end


% need to convert mprage too

% Check whether there are already nifti files
ragedir   = fullfile(b.dataDir,'mprage_sag_NS_g3');
ragefiles = spm_select('FPList', ragedir, '.*\.nii');
if size(ragefiles, 1) > 0
    fprintf('There are already %0.0f nii files in mprage folder.\n', size(ragefiles,1));
    response = input('Are you sure you want to use dicom files? y/n \n', 's');
    if strcmp(response,'y') == 1
        disp('Continuing running dicom conversion')
    else
        error('Found NII mprage Change fileType to ''NII''')
    end
end

% Convert dicom images
ragedir   = fullfile(b.dataDir,'mprage_sag_NS_g3');
dcmfiles = spm_select('FPList', ragedir, '.*dcm');
dcmhdr    = spm_dicom_headers(dcmfiles);
cd(ragedir)
dcmoutput = spm_dicom_convert(dcmhdr, 'all', 'flat', 'nii');
b.mprage = cell2mat(dcmoutput.files);
fprintf('%0.0f files converted to nii (mprage).\n', size(b.mprage, 1));
cd(b.scriptdir);
end