function [valSweep] = valsweep(net, pximdsVal, datasetDir, dataset,...
    pd)
% Perform K and Fth sweep on validation partition with GLT
% Sintax:
%     [validationSweep] = valsweep(net, pximdsVal, datasetDir)
% Inputs:
%     net,             DAG network trained  
%     pximdsVal,       pixelLabelImageDatastore validation object
%     datasetDir,      dataset path
% Outputs:
%     validationSweep, table with validation sweep results
%

N = pximdsVal.NumObservations;
th = 0.1:0.05:0.8; K = [2 4 6 8];
DSC = zeros(N,length(th)); PD = zeros(N,length(th));
PDgt = zeros(N,1);
imgSource = strings(N,1);
fileName = strings(N,1);
for k=0:length(K)-1
    for j=1:length(th)
        for i = 1 : N
            [~,name,~] = fileparts(pximdsVal.PixelLabelData{i});
            if imgSource(end)==""
                impath = [datasetDir filesep name '.dcm'];
                info = getinfo(impath);
                imgSource(i) = string(info.source);
                fileName(i) = [name '.dcm'];
                PDgt(i) = pd(strcmp(dataset.path,fileName(i)));
            elseif  ~exist('valSweep','var')
                valSweep = table({fileName},{imgSource},{th},{PDgt});
            end
            I = imread(pximdsVal.Images{i});
            
            unetMask  = semanticseg(I, net) == pximdsVal.ClassNames(2);
            
            % Make files path for original target and image size
            gtPath = fullfile('data','target',...
                'fgt',[name '.png']);
            gtMask = imread(gtPath);

            breastMask = segBreast(mat2gray(I), false); % CC
            fgtMask    = logical(kmeansfgt(unetMask,I,K(k+1),th(j)));
            
            PD(i,j)    = sum(fgtMask(:))/sum(breastMask(:));
            
            fgtMask    = imresize(fgtMask,size(gtMask));
            
            DSC(i,j)   = dice(fgtMask,gtMask);

            fprintf('# %d | th = %4.2f | K = %d | PD = %4.2f | GT_PD = %4.2f| DSC = %4.2f\n',...
                i,th(j),K(k+1),PD(i,j),PDgt(i),DSC(i,j))
        end
    end
    valSweep = addvars(valSweep,{DSC},{PD}); % Variables: DSC odd, PD even
end
%Replacing NaN values since 5 to last column
for i=5:width(valSweep), valSweep.(i){1}(isnan(cell2mat(valSweep.(i)))) = 0; end
