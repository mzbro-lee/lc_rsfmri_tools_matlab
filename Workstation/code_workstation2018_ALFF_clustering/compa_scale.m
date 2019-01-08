%% 比较被聚类模型分为2类的被试的量表差异
%% input
scale_path_test='D:\WorkStation_2018\WorkStation_2018_11_machineLearning_Psychosi_ALFF\REST-meta-MDD-PhenotypicData_WithHAMDSubItem_S20.xlsx';
predict_label_path='D:\WorkStation_2018\WorkStation_2018_11_machineLearning_Psychosi_ALFF\predictLabel_testData.xlsx';
%% load
[scale_data,header]=xlsread(scale_path_test);
header=header(1,2:end);
[predict_label]=xlsread(predict_label_path);

%% 分组
scale_data_a=scale_data(predict_label==1,:);
scale_data_noa=scale_data(predict_label==0,:);


%% 各个量表的ind,筛选
[~,ind_age]=ismember('年龄',header);
[~,ind_edu]=ismember('教育年限',header);
[~,ind_duration]=ismember('病程（月）',header);
[~,ind_hamd]=ismember('HAMD',header);
[~,ind_hama]=ismember('HAMA',header);
[~,ind_first]=ismember('是否首发',header);
[~,ind_drug]=ismember('是否正在用药',header);

% age
age_a=scale_data_a(:,ind_age);
age_noa=scale_data_noa(:,ind_age);
% edu
edu_a=scale_data_a(:,ind_edu);
edu_noa=scale_data_noa(:,ind_edu);
%duration
duration_a=scale_data_a(:,ind_duration);
duration_noa=scale_data_noa(:,ind_duration);
%hamd
hamd_a=scale_data_a(:,ind_hamd);
hamd_noa=scale_data_noa(:,ind_hamd);
%hama
hama_a=scale_data_a(:,ind_hama);
hama_noa=scale_data_noa(:,ind_hama);
%first
first_a=scale_data_a(:,ind_first);
first_noa=scale_data_noa(:,ind_first);
%drug
drug_a=scale_data_a(:,ind_drug);
drug_noa=scale_data_noa(:,ind_drug);

%% compare
age_describe=[[mean(age_a),std(age_a)];[mean(age_noa),std(age_noa)]];
[h_age,p_age]=ttest2(age_a(~isnan(age_a)),age_noa(~isnan(age_noa)));

edu_describe=[[mean(edu_a),std(edu_a)];[mean(edu_noa),std(edu_noa)]];
[h_edu,p_edu]=ttest2(edu_a(~isnan(edu_a)),edu_noa(~isnan(edu_noa)));

duration_describe=[mean(duration_a(~isnan(duration_a))),std(duration_a(~isnan(duration_a)));
                    mean(duration_noa(~isnan(duration_noa))),std(duration_noa(~isnan(duration_noa)))];
[h_duration,p_duration]=ttest2(duration_a(~isnan(duration_a)),duration_noa(~isnan(duration_noa)));

hamd_describe=[mean(hamd_a(~isnan(hamd_a))),std(hamd_a(~isnan(hamd_a)));mean(hamd_noa(~isnan(hamd_noa))),std(hamd_noa(~isnan(hamd_noa)))];
[h_hamd,p_hamd]=ttest2(hamd_a(~isnan(hamd_a)),hamd_noa(~isnan(hamd_noa)));

hama_describe=[mean(hama_a(~isnan(hama_a))),std(hama_a(~isnan(hama_a)));
                mean(hama_noa(~isnan(hama_noa))),std(hama_noa(~isnan(hama_noa)))];
[h_hama,p_hama]=ttest2(hama_a(~isnan(hama_a)),hama_noa(~isnan(hama_noa)));

first_describe=[sum(first_a==1),sum(first_a==-1); sum(first_noa==1),sum(first_noa==-1)];
[p_first, Q_first]= chi2test_LiuFeng([sum(first_a==1),sum(first_a==-1); sum(first_noa==1),sum(first_noa==-1)]);

drug_describe=[sum(drug_a==1),sum(drug_a==-1); sum(drug_noa==1),sum(drug_noa==-1)];
[p_drug, Q_drug]= chi2test_LiuFeng([sum(drug_a==1),sum(drug_a==-1); sum(drug_noa==1),sum(drug_noa==-1)]);
%%
% function sel_data=comp(item,data,header)
%     [~,ind]=ismember(item,header);
%      sel_data=data(:,ind);
% end