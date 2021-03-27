function [] = dicom2png(datasetdir, size, ch, OBflag, K)
% Read DICOM image and save as .png with 1 or 3 channels
% Sintax:
%    dicom2png(datasetdir, size, ch, K)
% Inputs:
%     datasetdir, Dataset path
%     size,       [m n] vector with mxn images size
%     ch,         1 for one channel image, otherwise for RGB image
%     OBflag,     Boolean flag for OpenBreast segmentation
%     K,          Scalar for K clusters (Optional)
% Outputs:
% 
srcdir = pwd;
flagDirCC = false; flagDirMLO = false;
% Find actually path and list of DICOM files
fileList = dir([datasetdir filesep '*.dcm']);

disp('Saving images... ');
for i=1:length(fileList)
    %Read DICOM file
    [~,name,~] = fileparts(fileList(i).name);
    impath     = [datasetdir filesep fileList(i).name];
    info       = getinfo(impath);
    im         = ffdmRead(impath, info);
    im         = imresize(im, size);
    
    % Breast Segmentation with OpenBreast
    if OBflag
        mask = segBreast(im, info.ismlo);
        se = strel('disk',5);
        mask = imerode(mask,se);
        im = im.*mask;
    end
    % Create image out path 
    if  strcmp(string(info.view), "CC")
        if ~flagDirCC
            mkdir('data/trainImages/CC');
            flagDirCC = true;
        end
        baseFileNameIm = [name,'.png'];
        fullFileNameIm = fullfile(srcdir,'data',...
            'trainImages','CC', baseFileNameIm);
    else
        if ~flagDirMLO
            mkdir('data/trainImages/MLO');
            flagDirMLO = true;
        end
        baseFileNameIm = [name,'.png'];
        fullFileNameIm = fullfile(srcdir,'data',...
            'trainImages','MLO', baseFileNameIm);
    end
    
    % Adapt and convert image
    im = double(im); im = imresize(im,size);              % Resize img
    im = (im - min(im(:)))*(255/(max(im(:))-min(im(:)))); % Normalize img
    
%    [L,NumLabels] = superpixels(im,1000);
    
    % K-MEANS CLUSTERING
    if nargin==5
        im = round(im);
        C = linspace(0,255,K)';
        idx = kmeans(im(:),K,'Start',C,'MaxIter',1000);
        outClusters = reshape(idx,size);
        for k=1:K
            outClusters(outClusters == k) = C(k);
        end
        im = outClusters;
    end
    % Choose number of channels
    if ch == 1
        imwrite(uint8(im), fullFileNameIm);               % Save img
        disp(i);
    else
        im = cat(3, im, im, im);                          % RGB img
        imwrite(uint8(im), fullFileNameIm);               % Save img
        disp(i);
    end
end
disp('Images saved in ./data/trainImages');