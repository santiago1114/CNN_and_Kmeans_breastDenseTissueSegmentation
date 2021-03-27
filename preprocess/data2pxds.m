function [] = data2pxds(pxdsLoaded, imds, pixelLabelID, partition)
% Perform partition data for breast area and FGT, save on .mat file
% Sintax:
%     objectsData(pxdsLoaded, imds, pixelLabelID, partition)
% Inputs:
%     pxdsLoaded,    Pixel Label Datastore object
%     imds,          Images Datastore object
%     pixelLabelID,  ID for pixels labeled
%     partition,     1X2 Vector with partition desired
% Outputs:
%

[imdsCell, pxdsD] = partitionData(imds,...
    pxdsLoaded, pixelLabelID, partition);

% Augment data
augmenter = imageDataAugmenter('RandXReflection',true,...
    'RandXTranslation',[-32 32],'RandYTranslation',[-32 32]);

% Create PixelLabelDatastore TRAINING for FGT areas.
trainingFGT = pixelLabelImageDatastore(imdsCell{1},pxdsD{1}, ...
    'DataAugmentation',augmenter);

% Create PixelLabelDatastore VALIDATION for FGT areas.
validationFGT = pixelLabelImageDatastore(imdsCell{2},pxdsD{2});

% Create PixelLabelDatastore TESTING for FGT areas.
testingFGT = pixelLabelImageDatastore(imdsCell{3},pxdsD{3});

% Export to .mat file
pxdsDataset = table(trainingFGT,validationFGT,testingFGT);
wspath = [pwd filesep 'data' filesep 'workspace'];
mkdir(wspath)
savepath = fullfile(wspath, 'pxdsDataset');
save( savepath ,'pxdsDataset');

