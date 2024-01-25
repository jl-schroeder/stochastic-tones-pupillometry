%% import modules
addpath('/Users/scanlab/Documents/internship_luca/model-folder/drex-model/')

%% load preprocessed data
% T = readtable('/Users/scanlab/Documents/internship_luca/pupildata/pp_dfs/preprocs/sub-004.csv');
% T.Var1 = []; % remove first column, as it includes doubled indices
% sub_names = {'sub-005','sub-008','sub-013','sub-007','sub-009','sub-011','sub-010','sub-014','sub-004'};%T.Properties.VariableNames;
sub_names = {'sub-008','sub-007','sub-009','sub-011','sub-010','sub-004'};%T.Properties.VariableNames;


%% apply d-rex model
% go trough all 9 participant and calculate suprise for each

% pre-build structure
% data_struct = struct('sub-005',[],'sub-008',[],'sub-013',[],'sub-007',[],'sub-009',[],'sub-011',[],'sub-010',[],'sub-014',[],'sub-004',[]);
% table_struct = struct('sub-005',[],'sub-008',[],'sub-013',[],'sub-007',[],'sub-009',[],'sub-011',[],'sub-010',[],'sub-014',[],'sub-004',[]);

for i= 1:length(sub_names)-2
    behav_data = readtable(append('/Users/scanlab/Documents/internship_luca/pupildata/',sub_names{i},'/main/main_behdf_',sub_names{i},'.csv'));
    T = readtable(append('/Users/scanlab/Documents/internship_luca/pupildata/pp_dfs/preprocs/',sub_names{i},'.csv'));
    T.Var1 = []; % remove first column, as it includes doubled indices
    T.block = zeros(length(T.pupil),1); % add empty block-column
    
    % add block descriptions to data
    block = 0;
    for k=1:length(behav_data.block)-1
        if behav_data.block(k) ~= block || behav_data.block(k) ~= behav_data.block(k+1) || k==length(behav_data.block)-1
            
            if k==length(behav_data.block)-1
                block = behav_data.block(k+1);
                val = behav_data.timing_meg(k+1);
            else
                block = behav_data.block(k);
                val = behav_data.timing_meg(k);
            end
            % go trough time and 
            for j=2:length(T.time)
                if T.time(j)>=val && T.time(j-1)<=val
                    T.block(j) = block;
                end
            end
        end
    end
    
    % go through each block and fill in block info for each block
    blk_data = [];
    blk_model = [];
    for blk = 1:24
        idxs = find(T.block==blk);
        pos = idxs(1);
        while pos ~= idxs(2)
            T.block(pos) = blk;
            pos = pos+1;
        end
    end
    
    % write data to csv
    writetable(T,append('/Users/scanlab/Documents/internship_luca/pupildata/pp_dfs/preprocs/with_blk/',sub_names{i},'_pupil.csv'),'Delimiter',',')
end