function [] = prepareData(datasetdir, datasetTable, inSize)
% Saving ground truth masks on .png files. path: ./data/groundTruthMask
% Sintax:
%     prepareData(datasetdir, datasetTable, size)
% Inputs:
%     datasetdir,  Dataset path
%     datasetT,    Table with dataset info
%     size,        [m n] vector with mxn images size
% Outputs:
% 
srcdir = pwd;
n = height(datasetTable);

% Create folders
mkdir('data/target/fgt');
mkdir('data/target/fgt_resized');
mkdir('data/input/images');
mkdir('data/input/images_resized');

disp('File saved: ');
for imgNumber = 1:n
    % Modify DICOM path
    file                         = datasetTable.path{imgNumber};   
    datasetTable.path{imgNumber} = [datasetdir filesep file];
    % Create filename output
    [~,name,~]       = fileparts(file);
    fileName         = [name, '.png'];

%%%%%%%%%%%%%%%%%%%%%%% Saving .png ground-truth masks %%%%%%%%%%%%%%%%%%%%
    % Extract ground-truth area and dense tissue segmentation
    [~, mask1, ~] = groundtruth(datasetTable(imgNumber,:));
    
    % Discard null dense masks
    if sum(mask1(:)) < round(inSize(1)*inSize(2)*0.001)
        disp("Discarting image");
        disp(imgNumber);
        continue
    end
    
    fgtPath_resized = fullfile(srcdir,'data','target',...
        'fgt_resized', fileName);
    fgtPath = fullfile(srcdir,'data','target',...
        'fgt', fileName);
    
    % Saving masks on .PNG format
    imwrite(imresize(mask1,inSize), fgtPath_resized);
    imwrite(mask1, fgtPath);
%%%%%%%%%%%%%%%%%%%%%%% Saving .png images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Read DICOM file
    impath     = datasetTable.path{imgNumber};
    info       = getinfo(impath);
    im         = ffdmRead(impath, info);
    
    % Breast Segmentation with OpenBreast
    mask = segBreast(im, info.ismlo);
    im = im.*mask;
    im = adapthisteq(im,'clipLimit',0.02,'Distribution','rayleigh');
    im = im.*mask;
    im = imresize(im, inSize);

    % Create paths
    baseFileNameIm = [name,'.png'];
    imPath_resized = fullfile(srcdir,'data','input',...
        'images_resized', baseFileNameIm);
    
    % Choose number of channels
    imwrite(im2uint8(im), imPath_resized);
    
    disp(imgNumber);
end
disp('All files saved!');
