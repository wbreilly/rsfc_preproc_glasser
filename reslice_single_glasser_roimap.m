% reslice, threshold, rename, each subjects' masks
clear all
clc


dataDir     = '/Users/wbr/walter/fmri/rsfc_glasser_ROIs';
scriptdir   = '/Users/wbr/walter/fmri/rsfc_preproc_glasser';
subjects = {'s202','s204','s205','s206','s207','s208','s209','s210','s211',...
            's212','s213','s214','s215','s216','s217','s218','s219','s220','s221',...
            's223','s224','s225','s226','s227','s228','s229','s230','s231','s232',...
            's233','s234','s235','s236','s237','s238','s240','s241','s242','s243',...
            's244','s245','s246','s247','s248','s249','s250'};
b.scriptdir = scriptdir;



% Loop over subjects
for isub = 4:length(subjects)
    b.curSubj   = subjects{isub};
    b.dataDir   = fullfile(dataDir, b.curSubj);
    
    
    % unzip all masks
    cd(b.dataDir)
    % check for unzipped already 
    if size(spm_select('ExtFPListRec', b.dataDir, '.*.nii'),1) == 0
        gunzip('*.nii.gz');
    end
    cd(scriptdir)
        
    
   % grab the masks
    b.masks = cellstr(spm_select('ExtFPListRec', b.dataDir, '.*.nii'));
    
    % mean image as the reference 
    path1 = '/Users/wbr/walter/fmri/qa_rsfc_glasser_data.2mm';
    path2 = sprintf('005_bold_rest_5minX5/mean%s.005_bold_rest_5minX5.bold.nii', b.curSubj);
    ref_img = fullfile(path1, b.curSubj, path2);
    
    %loop through masks
    for imask = 1:size(b.masks,1)
        matlabbatch{imask}.spm.spatial.coreg.write.ref = cellstr(ref_img);
        matlabbatch{imask}.spm.spatial.coreg.write.source = b.masks(imask,:);
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.interp = 0;
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.mask = 0;
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.prefix = 'reslice_';
    end % end imask
    
    %run
    spm('defaults','fmri');
    spm_jobman('initcfg');
    spm_jobman('run',matlabbatch);
    
    % clean up
    cd(b.dataDir)
    delete('H*.nii')
    delete('P*.nii')
    gzip('reslice*.nii')
%     system(['gzip ', 'reslice*.nii'])
%     gunzip('reslice*.nii.gz')

    cd(scriptdir)
    
    % grab all the resliced masks
%     b.sliced = (spm_select('FPListRec', b.dataDir, '^reslice.*.nii'));
    
%     for imask = 1:size(b.sliced,1) 
%         [x,y,z] = fileparts(b.sliced(imask,:));
%         input_img = b.sliced(imask,:);
%         output_img = fullfile(b.dataDir, newnames(imask));
%         spm_imcalc(char(input_img),char(output_img), 'i1 ~= 0'); 
%     end % imask
end % end isub

% y = {};
% for iroi = 1:size(b.masks,1)
%     [x,y{iroi},z] = fileparts(b.masks{iroi,:});
% end
