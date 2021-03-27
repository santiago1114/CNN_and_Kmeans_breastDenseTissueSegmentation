function [net] = netinit(size, trainingData, ...
    pximdsVal, loadFlag, trainFlag)
% Create FCN and train
% Sintax:
%     [net] = netInit(checkpointdir, size, trainingData, pximdsVal, loadFlag, trainFlag)
% Inputs:
%     size,          MxN Train image size
%     trainingData,  Training pixelLabelImageDatastore object
%     pximdsVal,     Validation pixelLabelImageDatastore object
%     loadFlag,      Boolean value to load network from last checkpoint
%     trainFlag,     Boolean value to start training
% Outputs:
%     net,          DAG network trained

% Configure training options
if (nargin<5)||isempty(trainFlag)
   trainFlag = false;
end
NumClasses = 2;
netpath = [pwd filesep 'data' filesep 'net'];
maxEpochs = round(8000/trainingData.NumObservations);
options = trainingOptions('adam', ...
    'InitialLearnRate',1e-4, ...
    'L2Regularization',0.0001, ...
    'ValidationData',pximdsVal,...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',1, ...
    'ValidationFrequency',trainingData.NumObservations,...
    'Shuffle','every-epoch',...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',5,...
    'LearnRateDropFactor',0.1,...   
    'ExecutionEnvironment','gpu',...
    'Plots','training-progress',...
    'CheckpointPath','D:\checkpoints\',...
    'GradientThresholdMethod','global-l2norm');

% Train the FCN network
if loadFlag
    % Load last checkpoint
    MyFolderInfo = dir(fullfile(netpath,'*.mat'));
    dagNet = load(fullfile(netpath,MyFolderInfo(end).name));
    if trainFlag
        lgraph = layerGraph(dagNet.net);
        % Train UNET
        net = trainNetwork(trainingData,lgraph,options);
    else
        % Load UNET
        net = dagNet.net;
        disp('Load network: ')
        disp(MyFolderInfo(end).name)
    end
else
    mkdir(netpath)
    load('C:\Users\BENITEZ\MATLAB Drive\FCN\data\net\unetdepth4_64_lgraphDice.mat')
%    lgraph = unetLayers(size,NumClasses,'NumFirstEncoderFilters',100,...
%    'EncoderDepth',4);
    net = trainNetwork(trainingData,lgraph_1,options);
end
