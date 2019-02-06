function [b] = subfunk_bandaid_coreg(b)

% mean image as the reference 
path1 = '/Users/wbr/walter/fmri/rsfc_glasser_preprocessed';
path2 = sprintf('005_bold_rest_5minX5/mean%s.005_bold_rest_5minX5.bold.nii', b.curSubj);
ref_img = fullfile(path1, b.curSubj, path2);

%loop through masks
for irun=1:5
    matlabbatch{irun}.spm.spatial.coreg.write.ref = cellstr(ref_img);
    matlabbatch{irun}.spm.spatial.coreg.write.source = b.allfiles{irun};
    % nearest neighbor interp
    matlabbatch{irun}.spm.spatial.coreg.write.roptions.interp = 0;
    matlabbatch{irun}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    matlabbatch{irun}.spm.spatial.coreg.write.roptions.mask = 0;
    matlabbatch{irun}.spm.spatial.coreg.write.roptions.prefix = 'coreg_';
end

%run
spm('defaults','fmri');
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);

end