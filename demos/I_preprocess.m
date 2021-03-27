%% Save masks and images .png files
imgSize = [512 512];
% Add dataset path
datasetDir = 'D:\dataset';
% Load metadata table
datasetTable = load(fullfile('data','dataset.mat')).dataset;

prepareData(datasetDir, datasetTable, imgSize);

%% Create data objects for train network

showImgLabeled = 1;    % Show image labeled sample
[pxdsLoaded, imdsCC, pixelLabelID] = loaddata(showImgLabeled);
partition = [.66 .17]; % Training 66%, validation 17%, testing remaining
% Create PixelLabelDatastore objects for one view (CC or MLO)
data2pxds(pxdsLoaded, imdsCC, pixelLabelID, partition);