function [b] = coregister_estimate(b)
% Batch coregister 
% Walter Reilly wrote this after one gui click too many

% Usage:
%
%	b = coregister_estimate(b)
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
%      b.rundir(n).rfiles = a character array with the full paths to
%                   the .*\.nii realigned and resliced functional images
%

runflag = 1;

% check if coregistration has been run
if exist(fullfile(b.dataDir,sprintf('coregistration_check_%s.txt',b.curSubj)), 'file') == 2 % check in the sub directory
    if b.auto_accept
        response = 'n';
    else
        response = input('Coregistration was already run. Do you want to run it again? y/n \n','s');
    end
    if strcmp(response,'y')==1
        disp('Continuing running coregistration')
    else
        disp('Skipping coregistration')
        runflag = 0;
    end
end


% if it hasn't been run, run coregistration
if runflag
    % First re-organize all realigned files into cell array
    b.allfiles = {};
    for i = 1:length(b.runs)
        b.allfiles{i} = cellstr(b.rundir(i).sfiles); 
    end

    % run coregister estimate 
    clear matlabbatch

    % initiate coreg params copied from a gui .m output
    % mprage location determined in find_nii
    % b.meanfunc made in realign script after meanfunc is made
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = cellstr(b.meanfunc);
    matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(b.mprage);
    matlabbatch{1}.spm.spatial.coreg.estimate.other = b.allfiles';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

    %try to run it
    try
        % run it
        spm('defaults','fmri');
        spm_jobman('initcfg');
        spm_jobman('run',matlabbatch);
        
        % make a text file to prove it ran without error
        fid = fopen(fullfile(b.dataDir,sprintf('coregistration_check_%s.txt',b.curSubj)), 'wt' );
        fclose(fid);
        
        % print success
        fprintf('Coregistration is complete for %s!!\n', b.curSubj)
    catch
        % if shit hits the floor
       error('whoops!! Coregistration did not complete without errors!')
    end % end trycatch
end % end if

end % end function
