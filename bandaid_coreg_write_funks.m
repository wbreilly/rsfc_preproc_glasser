% reslice, threshold, rename, each subjects' masks
clear all
clc


dataDir     = '/Users/wbr/walter/fmri/rsfc_glasser_preprocessed';
scriptdir   = '/Users/wbr/walter/fmri/rsfc_preproc_glasser';
% good subs only n = 42/47
subjects = {'s202','s204','s205','s206','s207','s208','s209','s210','s211',...
            's212','s213','s214','s216','s218','s219','s220','s221',...
            's223','s224','s225','s226','s227','s228','s229','s230','s231',...
            's233','s234','s235','s236','s237','s238','s240','s241','s243',...
            's244','s245','s246','s247','s248','s249','s250'};
runs        = {'005_bold_rest_5minX5' '006_bold_rest_5minX5' '007_bold_rest_5minX5' '008_bold_rest_5minX5' '009_bold_rest_5minX5'}; 




% Loop over subjects
parfor isub = 2:length(subjects)
    b.curSubj   = subjects{isub};
    b.dataDir   = fullfile(dataDir, b.curSubj);
    b.runs      = runs;
    
    for irun  = 1:length(b.runs)
        b.nifty = fullfile(b.dataDir,b.runs{irun});
        b.rundir(irun).sfiles = spm_select('ExtFPListRec', b.nifty, ['^s.*' '.*bold\.nii']);
        fprintf('%02d:   %0.0f files found.\n', irun, length(b.rundir(irun).sfiles))
    end
    
    b.allfiles = {};
    for i = 1:length(b.runs)
        b.allfiles{i} = cellstr(b.rundir(i).sfiles); 
    end
    
    [b] = subfunk_bandaid_coreg(b);
     
end % end isubd