function lc_DynamicFC_InterROI_LC(allSubjPath,pathResult,window_step,window_length,opt)
% ����һ�鱻�Ե�ROI wise�Ķ�̬�������Ӻ��˾�̬��������
% input��
%   allVolume��һ�鱻�Ե�ʱ�����о���ÿһ�����Ե�����sizeΪ��T*N��TΪʱ��������NΪROI�ĸ���
%   window_step,window_length�������Ϳ�
%   opt:options
% output
%   ZFC_dynamic �ļ�����Ϊÿ�����ԵĶ�̬�������ӣ�Fisher R to Z
% �任������size=N*N*W��NΪROI������WΪslide window ����
%   ZFC_static �ļ�����Ϊÿ�����Եľ�̬�������ӣ�Fisher R to Z �任����
tic
%% 
if nargin<6
    opt.if_calc_dynamic=0;
    opt.if_calc_static=1;
end

if nargin<5
    window_length=20;
end

if nargin<4
    window_step=1;
end

% ������б���mat��·��
if nargin<2
    allSubjPath='D:\WorkStation_2018\WorkStation_dynamicFC\Data\ROISignals_testing';
    allSubjPath=dir(allSubjPath);
    folder={allSubjPath.folder};
    name={allSubjPath.name};
    allSubjPath=cell(length(name),1);
    for i =1:length(name)
        allSubjPath{i}=fullfile(folder{i},name{i});
    end
     allSubjPath= allSubjPath(3:end);
end
% ���Ŀ¼
if nargin<1
    pathResult='D:\WorkStation_2018\WorkStation_dynamicFC\Data\zStatic\testing';
end
mkdir(fullfile(pathResult,'zStaticFC'));
mkdir(fullfile(pathResult,'zDynamicFC'));
pathResult_dynamic=fullfile(pathResult,'zDynamicFC');
pathResult_static=fullfile(pathResult,'zStaticFC');

%% calculate both the static and dynamic Inter-ROI FC
fprintf('==================================\n');
fprintf(' Calculating dynamic FC\n');
nSubj=length(allSubjPath);
for s=1:nSubj
    fprintf('���ڼ����%d/%d������...\n',s,nSubj);
    matPath=allSubjPath{s};
    allVolume=importdata(matPath);
    if opt.if_calc_dynamic==1 && opt.if_calc_static==1
        [zDynamicFC,zStaticFC]=DynamicFC_interROI_oneSubj(allVolume,window_step,window_length);
        % save
        [~,name,format]=fileparts(matPath);
        save([pathResult_dynamic,filesep,name,format],'zDynamicFC');
        save([pathResult_static,filesep,name,format],'zStaticFC');
    elseif opt.if_calc_dynamic==1 && opt.if_calc_static==0
        [zDynamicFC,~]=DynamicFC_interROI_oneSubj(allVolume,window_step,window_length);
        % save
        [~,name,format]=fileparts(matPath);
        save([pathResult_dynamic,filesep,name,format],'zDynamicFC');
    elseif opt.if_calc_dynamic==0 && opt.if_calc_static==1
        [~,zStaticFC]=DynamicFC_interROI_oneSubj(allVolume,window_step,window_length);
        % save
        [~,name,format]=fileparts(matPath);
        save([pathResult_static,filesep,name,format],'zStaticFC');
    else
        fprintf('do nothing!\n')
        return
    end
end
fprintf('==================================\n');
fprintf('Dynamic FC calculating completed!\n');
toc
end

function [zDynamicFC,zStaticFC]=...
            DynamicFC_interROI_oneSubj(allVolume,window_step,window_length)
% ����һ������ROI wise�Ķ�̬�������Ӻ;�̬��������
% input��
%   һ�����Ե�ʱ�����о���allVolume��sizeΪ��T*N��TΪʱ��������NΪROI�ĸ���
% output
%   zDynamicFC�� �ļ�����Ϊ�Ķ�̬�������ӣ�Fisher R to Z
%   �任������size=N*N*W��NΪROI������WΪslide window ����
%   zStaticFC�� �ļ�����Ϊ��̬�������ӣ�Fisher R to Z �任����
%   stdOfZDynamicFC: ��̬FC�ı�׼��
%%
%����dynamic FC���ڸ���
window_end=window_length;
volume=size(allVolume,1);% dynamic FC parameters
nWindow=1;
while window_end <volume
    window_end=window_end+window_step;
    nWindow=nWindow+1;%������ٸ����������ٸ���̬����,��������ռ��ZFC_dynamic,�Ӷ��ӿ��ٶ�
end

% allocate space
nRegion=size(allVolume,2);
% static FC
staticR=corrcoef(allVolume);
zStaticFC=0.5*log((1+staticR)./(1-staticR));%Fisher R-to-Z transformation
% dynamic FC
window_star=1;
window_end=window_length;%����,��ʼ��
count=1;
zDynamicFC=zeros(nRegion,nRegion,nWindow);
while window_end<=volume
    windowedTimecourse=allVolume(window_star:window_end,:);
    dynamicR=corrcoef(windowedTimecourse);
    zDynamicFC(:,:,count)=0.5*log((1+dynamicR)./(1-dynamicR));%Fisher R-to-Z transformation
    window_star=window_star+window_step;
    window_end=window_end+window_step;
    count=count+1;
end
% stdOfZDynamicFC=std(zDynamicFC,0,3);%���ڻ���������ı�׼�
end