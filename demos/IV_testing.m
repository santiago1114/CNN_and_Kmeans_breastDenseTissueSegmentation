%% Test trained net
load('C:\Users\BENITEZ\MATLAB Drive\FCN\data\net\unetdepth4_64_dice_trained.mat')
load('.\data\workspace\pxdsDataset.mat') % Load dataset
datasetDir = 'D:\dataset';
imgNum = 20; th = 0.5; K = 8;

seg(datasetDir, net, pxdsDataset.testingFGT, th, K);

%% Perform MAG and LIBRA segmentation (demo05 of OpenBreast was modified).


run demo05
