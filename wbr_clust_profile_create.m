% Create a cluster profile object:
cluster_profile= parallel.cluster.Local()
 
% Set up the directory for local user DCS job storage
ident_csiro = getenv('USER')
jsl = [ '/home/' ident_csiro '/.matlab/local_cluster_jobs/R2016a' ]
if ((isdir([jsl]) == 0))
    mkdir(jsl)
end
set(cluster_profile, 'JobStorageLocation', jsl)
  
% Set Matlab root
matlab_home= getenv('MATLAB_HOME')
set(cluster_profile,'ClusterMatlabRoot',matlab_home)
% The NumWorkers value should be set to the maximum number of workers potentially needed.
% NumWorkers needs to be used in conjunction with ClusterInfo.setNTasks() value that requests the resources from SLURM
set(cluster_profile, 'NumWorkers', 64);  % set to greater number once the profile has been tested.
% set(cluster_profile, 'OperatingSystem', 'unix');
% set(cluster_profile, 'IndependentSubmitFcn', @independentSubmitFcn);
% set(cluster_profile, 'CommunicatingSubmitFcn', @communicatingSubmitFcn);
% set(cluster_profile, 'GetJobStateFcn', @getJobStateFcn); 
% set(cluster_profile, 'DeleteJobFcn', @deleteJobFcn);
% set(cluster_profile, 'HasSharedFilesystem', true)
 
% Save the profile for use in Matlab DCS jobs
saveAsProfile(cluster_profile, 'big_mem')