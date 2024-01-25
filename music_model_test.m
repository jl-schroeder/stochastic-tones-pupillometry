%tones model
%% import modules
addpath('/Users/scanlab/Documents/internship_luca/model-folder/drex-model/')

%% load files
sub_names = {'sub-008','sub-007','sub-009','sub-011','sub-010','sub-004'};

for subj = 1:length(sub_names)
    % read behavioural data from respective subject
    behav_data = readtable(append('/Users/scanlab/Documents/internship_luca/pupildata/',sub_names{subj},'/main/main_behdf_',sub_names{subj},'.csv'));
    
    % define parameters
    params = [];
    params.distribution = 'gmm';
    params.max_ncomp = 2;%10;
    params.beta = 0.2;
    params.D = 1;
    
    params.maxhyp = inf;
    params.memory = inf;
    
    % go through each block
    for blk = 1:24
        idxs = find(behav_data.block==blk);
        
        x = behav_data.frequencies_oct(idxs(1):idxs(end));
        
        params.prior = estimate_suffstat(x,params);
        
        out = run_DREX_model(x,params);
        
        behav_data.drex_surp(idxs(1):idxs(end)) = out.surprisal;
        
        % display figure of model
        figure(blk); clf;
        display_DREX_output(out,x)
    end
    
    % save data on disk
    writetable(behav_data,append('/Users/scanlab/Documents/internship_luca/pupildata/pp_dfs/behav_data/',sub_names{subj},'.csv'))
end
