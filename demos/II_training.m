%% Train or load network

load('.\data\workspace\pxdsDataset.mat') % Load dataset
imgSize = [512 512];
% Declare flags
loadNetFlag = false;
trainFlag = true;

net = netinit(imgSize, pxdsDataset.trainingFGT,...
    pxdsDataset.validationFGT, loadNetFlag, trainFlag);
save('./data/net/unetdepth_dsc_no_clahe.mat','net') % Save DAG network trained