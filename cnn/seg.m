function [] = seg(datasetDir, net, testingData, th, K, imgNum)
% Use network to segment test data
% Sintax:
%     seg(net, testingData, th);
% Inputs:
%     datasetDir,       DICOM Dataset path
%     net,              DAG network trained
%     testingData,      Pixellabeldatastore for FGT
%     th,               Threshold to segment imgNum image of imdsTest
%     K,                K groups for clustering
%     imgNum,           Number of image to segment
%
% Outputs:
%

classes = testingData.ClassNames;
filesCell = testingData.Images;
d = load('.\data\dataset.mat'); % Load dataset metadata (WITH PATH AND PD)
if (nargin<6)
    % Perform segmentation for all test data
    disp('Image tested: ');
    N = length(filesCell);
    FullName = cell(N,1);
    BreastArea = cell(N,1);
    FGTMask = cell(N,1);
    UNETMask = cell(N,1);
    PD = zeros(N,1);
    PDgt = zeros(N,1);
    PDUnet = zeros(N,1);
    FGTGTMask = cell(N,1);
    imgSource = strings(N,1);
    for i = 1 : N
        [~,name,~] = fileparts(filesCell{i});
        fullName = [name '.dcm'];
        FullName{i} = fullName; 
        I = imread(filesCell{i});
        
        % Extract mammographic system
        impath       = [datasetDir filesep name '.dcm'];
        info         = getinfo(impath);
        imgSource(i) = string(info.source);
        
        imD = ffdmRead(impath, info);
        imD = imresize(imD,size(I));
        
%         imOPath = fullfile(pwd, 'data', 'input',...
%             'images',[name '.png']);
%         imO = imread(imOPath);
        % Extract FGT ground truth mask
        gtPathFGT = fullfile(pwd, 'data', 'target',...
            'fgt',[name '.png']);
        gtFGT = imread(gtPathFGT);
        
        % Perform breast segmentation
        maskBA = segBreast(mat2gray(imD), false); % OpenBreast segmentation
        
        % Perform FGT segmentation
        Umask   = semanticseg(I, net) == classes{2};
        
        maskFGT = kmeansfgt(Umask,I,K,th); % Use GLT
        
        PD(i) = sum(maskFGT(:))/sum(maskBA(:));
        
        maskFGT = imresize(maskFGT,size(gtFGT));
        maskBA = imresize(maskBA,size(gtFGT));
        
        FGTMask{i} = maskFGT;
        
        % Extract breast ground truth mask
        BreastArea{i} = maskBA;
        

        UNETMask{i} = imresize(Umask, size(gtFGT));

        % Calculate PD
        PDUnet(i) = sum(UNETMask{i}(:))/sum(maskBA(:));
        
        
        
        % Ground truth
        FGTGTMask{i} = gtFGT;
        PDgt(i) = d.pd(strcmp(fullName,d.dataset.path));
        disp(i);
    end
    proposed = table(FullName,imgSource,BreastArea,UNETMask,FGTMask,PD,...
        PDUnet,FGTGTMask,PDgt);
    save('.\data\workspace\proposed.mat','proposed')
else
    
    [~,name,~] = fileparts(filesCell{imgNum});
    I = imread(filesCell{imgNum});

    % Extract FGT ground truth mask
    gtPathFGT = fullfile(pwd, 'data', 'ground_truth',...
        'full_size_fgt',[name '.png']);
    GTimage = logical(mat2gray(imread(gtPathFGT)));
    
    % Extract original DICOM and resize
    impath = ['D:\dataset\' name '.dcm'];
    info = getinfo(impath);
    im = fliplr(ffdmRead(impath, info));
    im = imresize(im,size(GTimage));
    imwrite(im,fullfile('papersaved','im.png'))
    
    % Perform UNET FGT segmentation
    maskUnetFGT = semanticseg(I, net) == classes{2};
    maskUnetFGTre = imresize(maskUnetFGT,size(GTimage));

    % BA openbreast segmentation
    maskBA = segBreast(mat2gray(I), false); % OpenBreast segmentation
    maskBA = imresize(maskBA,size(GTimage));
    se = strel('disk',5);
    maskBA2 = imerode(maskBA,se);
    maskBAperim2 = fliplr(bwperim(maskBA2,8));
    maskBAperim = fliplr(bwperim(maskBA,8));
    maskBAperim2 = imdilate(maskBAperim2, strel('disk',2));
    maskBAperim = imdilate(maskBAperim, strel('disk',2));
    preprocessed = imoverlay(double(im),double(maskBAperim),'red');
    preprocessed2 = imoverlay(double(im),double(maskBAperim2),'red');
    imwrite(preprocessed,fullfile('papersaved','prep.png'))
    imwrite(preprocessed2,fullfile('papersaved','prep2.png'))
    
    skewness = xfeatures((im),...
        {'iske'}, maskBA);
        
    % Show cnn seg
    cnnOut = double(maskBA);
    cnnOut(maskUnetFGTre) = 0.5;
    imwrite(fliplr(cnnOut),fullfile('papersaved','cnnOut.png'))
    
    % Use CS and K-MEANS
    [outMask,c,pmasks] = kmeansfgtshow(maskUnetFGT,I,K,th);
    c = imresize(c, size(GTimage));
    imwrite(fliplr(c),fullfile('papersaved','c.png'))
    for i=1:K
        pmasks{i} = imresize(pmasks{i}, size(GTimage));
        orange = [1.0000    0.4118    0.1608];
        pmasks{i} = imoverlay(c,pmasks{i},orange);
        imwrite(fliplr(pmasks{i}),fullfile('papersaved',['pmask' num2str(i) '.png']))
    end
    
    outMask = imresize(outMask, size(GTimage)); % Resize mask
    breast = cat(3, im, im, im + 0.25*fliplr(double(maskBA)));
    bareas = cat(3, im, im + 0.25*fliplr(double(outMask)), im + 0.25*fliplr(double(maskBA)));
    imwrite(breast,fullfile('papersaved','breast.png'))
    imwrite(bareas,fullfile('papersaved','breastAreas.png'))
    outOverC = imoverlay(c,outMask,'green');
    imwrite(fliplr(outOverC),fullfile('papersaved','outOverC.png'))
    CSout = cat(3, im, im + 0.25*fliplr(double(outMask)), im);
    imwrite(CSout,fullfile('papersaved','CSout.png'))
%     imshow(fliplr(outMask)), title(['Proposed segmentation mask, DSC= ',...
%         num2str(dice(outMask,GTimage))])
    
    % Show differences
    outMask2 = outMask;
    outMask(GTimage)=0; outMask2(outMask)=0;
    image = cat(3, im + 0.25*fliplr(double(outMask)),...
        im + 0.25*fliplr(double(outMask2)), im);
    image = imcrop(image,[0 0 700 length(image(:,1))-120]);
    imwrite(image,fullfile('papersaved','proposed.png'))
    
    outMask2 = maskUnetFGTre;
    maskUnetFGTre(GTimage)=0; outMask2(maskUnetFGTre)=0;
    image = cat(3, im + 0.25*fliplr(double(maskUnetFGTre)),...
        im + 0.25*fliplr(double(outMask2)), im);
    image = imcrop(image,[0 0 700 length(image(:,1))-120]);
    imwrite(image,fullfile('papersaved','unet.png'))
end
