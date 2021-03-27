%% Perform hyperparameters sweep
load('.\data\net\unetdepth4_64_dice_trained.mat')
load('.\data\workspace\pxdsDataset.mat')
d = load(fullfile('data','dataset.mat'));
datasetDir = 'D:\dataset';

[T] = valsweep(net, pxdsDataset.validationFGT, datasetDir,...
    d.dataset, d.pd);

save('.\data\workspace\sweep.mat','T');

%% Plot data
load('.\data\workspace\sweep.mat')
plotsweep(T)