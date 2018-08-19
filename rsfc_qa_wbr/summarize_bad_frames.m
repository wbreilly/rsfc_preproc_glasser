
subjects = {'s202','s203','s204','s205','s206','s207','s208','s209','s210','s211',...
            's212','s213','s214','s215','s216','s217','s218','s219','s220','s221',...
            's223','s224','s225','s226','s227','s228','s229','s230','s231','s232',...
            's233','s234','s235','s236','s237','s238','s240','s241','s242','s243',...
            's244','s245','s246','s247','s248','s249','s250'};


mean_fd = [];
for isub = 1:length(subjects)
load(sprintf('/Users/wbr/walter/fmri/qa_rsfc_glasser_data.2mm/%s/QA/%s_QA_summary_information.mat', subjects{isub}, subjects{isub}))
mean_fd(isub) = mean(cell2mat(summary_info(2,2:end)));
end

mean_bad_ts = [];
for isub = 1:length(subjects)
load(sprintf('/Users/wbr/walter/fmri/qa_rsfc_glasser_data.2mm/%s/QA/%s_QA_summary_information.mat', subjects{isub}, subjects{isub}))
mean_bad_ts(isub) = mean(cell2mat(summary_info(7,2:end)));
end