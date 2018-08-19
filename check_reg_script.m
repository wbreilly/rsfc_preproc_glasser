% check registration 
clear all
clc

subjects = {'s202','s203','s204','s205','s206','s207','s208','s209','s210','s211',...
            's212','s213','s214','s215','s216','s217','s218','s219','s220','s221',...
            's223','s224','s225','s226','s227','s228','s229','s230','s231','s232',...
            's233','s234','s235','s236','s237','s238','s240','s241','s242','s243',...
            's244','s245','s246','s247','s248','s249','s250'};
        
dataDir     = '/Users/wbr/walter/fmri/qa_rsfc_glasser_data.2mm/';

for i = 7:length(subjects)
    
    % Define variables for individual subjects - General
    b.curSubj   = subjects{i};
    b.dataDir   = fullfile(dataDir, b.curSubj);
    
    %find mprage
    ragedir   = fullfile(b.dataDir,'002_mprage_sag_NS_g3');
    ragefiles = spm_select('FPListRec', ragedir, ['^s.*' '.*.nii']);

    if size(ragefiles, 1) == 1
        fprintf('Found 1 mprage NII')
        b.mprage = ragefiles;
    else
        error('Could not find mprage NII')
    end
    
    % find EPI
    regularExp           = [ '^' b.curSubj '.*' '005_bold_rest_5minX5' '.*bold\.nii'];
    b.rundir.files = spm_select('ExtFPListRec', b.dataDir, regularExp, 1);
    
    % find meanfunc
    b.meanfunc = spm_select('FPListRec', b.dataDir, ['^mean.*' '005_bold_rest_5minX5' '.*bold\.nii']); % mean func is written only for first run
    fprintf('\nMean: %s\n', b.meanfunc)
    
    % put in a cell
    b.allfiles{1} = b.meanfunc;
    b.allfiles{2} = ragefiles;
%     b.allfiles{3} = b.rundir.files; 

    % build the batch
    matlabbatch{1}.spm.util.checkreg.data = cellstr(b.allfiles');
    
    % run
    spm('defaults','fmri');
    spm_jobman('initcfg');
    spm_jobman('run',matlabbatch);   
    
    keyboard
end


