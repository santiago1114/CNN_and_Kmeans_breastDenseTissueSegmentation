load('C:\Users\BENITEZ\MATLAB Drive\FCN\data\workspace\pxdsDataset.mat')
for i=1:length(pxdsDataset.trainingFGT.Images)
    im = imread(pxdsDataset.trainingFGT.Images{i});
    mask = imread(pxdsDataset.trainingFGT.PixelLabelData{i});
    [~,name,ext] = fileparts(pxdsDataset.trainingFGT.Images{i});
    imPath = fullfile(pwd,'unetpp','inputs','breast_fgt',...
        'images', [name ext]);
    maskPath = fullfile(pwd,'unetpp','inputs','breast_fgt',...
        'masks','0', [name ext]);
    imwrite(im2uint8(im),imPath);
    imwrite(im2uint8(mask),maskPath);
end