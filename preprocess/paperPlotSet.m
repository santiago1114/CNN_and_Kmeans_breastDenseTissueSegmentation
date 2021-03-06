function [] = paperPlotSet(ax, xlab, xT, ylab, yT )
axis(ax)
set(gca,'defaulttextinterpreter','latex',...
    'Units','normalized',...
    'YTick',yT,...
    'XTick',xT,...
    'yticklabel',{'-1.0','-0.5','0.0','0.5','1.0'},...
    'xticklabel',{'0.2','0.3','0.4','0.5','0.6','0.7','0.8'},... 
    'Position',[.17 .2 .75 .7],...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',8,...
    'FontName','Times',...
    'Box','on')
ylabel(ylab,...
    'FontUnits','points',...
    'FontSize',10,...
    'FontName','Times')
xlabel(xlab,...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',10,...
    'FontName','Times')
