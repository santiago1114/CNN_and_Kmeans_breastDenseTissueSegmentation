function [rho, pval] = PDcorrel(fullNames, method, methodName, gtPD)
% Statistics differences and correlation
% Sintax:
%     [rho, pval] = PDcorrel(groundTruth, method, methodName)
% Inputs:
%     fullNames,     Nx1 cells with filenames of mammograms in string
%     method,        Nx1 vector with values of PD by other method
%     methodName,    String with method name to display
%     gtPD,          Nx1 vector with values of PD by Ground Truth
% Outputs:
%     rho,           Correlation coeficient method vs ground truth
%     pval,          P-value of correlation test

% Correlation test
if (nargin<4)||isempty(gtPD)
    N = length(method);
    gtPD = zeros(N,1);
    for i = 1:N
        [~,name,~] = fileparts(fullNames{i});
        breastMask  = imread(['.\data\GroundTruthMasks\CC\originalSizeArea\' name '.png']);
        denseMask   = imread(['.\data\GroundTruthMasks\CC\originalSizeDense\' name '.png']);
        gtPD(i) = sum(denseMask)/sum(breastMask);
    end
end

[rho,pval] = corr(gtPD,method,'Type','Spearman');

% Plot scatter diagram
width=4.25; x0=5;
height=4.25; y0=5;
figure('Units','centimeters',...
'Position',[x0 y0 width height],...
'PaperPositionMode','auto');
x = 0:1/100:1; y = x;
hold on, grid on
plot(x,y,'LineWidth',2)
sz = 10;
scatter(gtPD,method,sz,'k','filled')
hold off
set(gca,'defaulttextinterpreter','latex',...
    'Units','normalized',...
    'YTick',0:.2:1,...
    'XTick',0:0.2:1,...
    'Position',[.21 .2 .75 .7],...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',8,...
    'FontName','Times')
dim = [.2 .5 .3 .3];
str = ['$\rho = $' num2str(rho)];
ylabel(methodName,...
'FontUnits','points',...
'FontSize',10,...
'FontName','Times')
xlabel('Ground Truth',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',10,...
'FontName','Times')
annotation('textbox',dim,'String',str,'FitBoxToText','on',...
    'FontSize',8,...
    'FontName','Times',...
    'Interpreter','latex');
% legend(,'s','Location','northwest')