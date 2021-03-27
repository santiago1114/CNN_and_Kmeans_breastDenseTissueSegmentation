function [median, hyp, pVal, iqrange, dsc] = compareDSC(groundTruth, T, source)
% Load data training
% Sintax:
%     [M, h, p] = compareStat(method1, method2, groundTruth)
% Inputs:
%     groundTruth, Mx1 cell array with ground truth binary masks
%     T,           MxN table with segmented masks by diferents methods
%     
% Outputs:
%     hyp,         Result hypothesis test for similarity
%     pVal,        P-value of test for similarity
%     M,           Mean or median of simirality distribution

varNames = T.Properties.VariableNames;
[M,N] = size(T);
dsc = zeros(M,N); 
median = zeros(N,1); hyp = zeros(N,1);pVal = zeros(N,1);

for j=1:N
    for i=1:M    
        dsc(i,j) = dice(logical( T.(varNames{j}){i}),logical(mat2gray(groundTruth{i})));
        if strcmp(varNames{j},'LIBRA')
            if dsc(i,j) < .2 %.2 for FGT libra .55 for breast area LIBRA
                dsc(i,j) = dice(fliplr(logical(T.(varNames{j}){i})),logical(mat2gray(groundTruth{i})));
            end
        end
    end
end

% Evaluate normality test
for i=1:N
%     while min(dsc(:,i))== 0
%         [~,I] = min(dsc(:,i));
%         dsc(I,:) = [];
%     end
    [median(i), hyp(i), pVal(i)] = normTest(dsc(:,i), varNames{i});
    iqrange(i) =iqr(dsc(:,i));
end
% [DSC,~] = ranksum(dsc(:,1),dsc(:,3));
% Box plot
width=6; x0=5;
height=5; y0=5;
figure('Units','centimeters',...
'Position',[x0 y0 width height],...
'PaperPositionMode','auto');
boxplot(dsc,'notch','on','labels',varNames,'OutlierSize',4)

set(gca,'defaulttextinterpreter','latex',...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',8,...
'FontName','Times')

ylabel({'DSC'},...
'FontUnits','points',...
'FontSize',10,...
'FontName','Times')

sourcediff(source,dsc(:,end)); % Source differences

function [M, h, p] = normTest(DSCDistribution, name)

M = mean(DSCDistribution);
S = std(DSCDistribution);
x = (DSCDistribution-M(1))/S;
[h,p] = kstest(x);   
if h
   M = median(DSCDistribution);
   disp([ name ' DSC distribution is not normal.'])
else
   M = median(DSCDistribution); %Only for current project
   disp([ name ' DSC distribution is normal.'])
end