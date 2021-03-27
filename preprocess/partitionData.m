function [imagesDatastore, pxdsD]...
    = partitionData(imds, pxdsLoaded, labelIDs, partition)
% Partition data

pxdsD = pxdsLoaded;

% Set initial random state for example reproducibility.
rng(0); 
numFiles = numel(imds.Files);
shuffledIndices = randperm(numFiles);

% Images for training
numTrain = round(partition(1) * numFiles);
trainingIdx = shuffledIndices(1:numTrain);

% Images for validation
numVal = round(partition(2) * numFiles);
valIdx = shuffledIndices(numTrain+1:numTrain+numVal);

% Use the rest for testing.
testIdx = shuffledIndices(numTrain+numVal+1:end);

% Create image datastores for training and test.
trainingImages = imds.Files(trainingIdx);
valImages = imds.Files(valIdx);
testImages = imds.Files(testIdx);

imagesDatastore = cell(3,1);
%1 for training, 2 for validation and 3 for test
imagesDatastore{1} = imageDatastore(trainingImages);
imagesDatastore{2} = imageDatastore(valImages);
imagesDatastore{3} = imageDatastore(testImages);

% Extract class and label IDs info
classesD = pxdsD.ClassNames;

% Create pixel label datastores for training and test.
trainingLabelsD = pxdsD.Files(trainingIdx);
valLabelsD = pxdsD.Files(valIdx);
testLabelsD = pxdsD.Files(testIdx);

% Declare partitions
pxdsD = cell(3,1);

pxdsD{1} = pixelLabelDatastore(trainingLabelsD, classesD, labelIDs);
pxdsD{2} = pixelLabelDatastore(valLabelsD, classesD, labelIDs);
pxdsD{3} = pixelLabelDatastore(testLabelsD, classesD, labelIDs);
