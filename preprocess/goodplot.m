function goodplot(papersize, margin, fontsize)
% function which produces a nice-looking plot
% and sets up the page for nice printing
if nargin == 0
papersize = 6;
margin = 0.5;
fontsize = 18;
elseif nargin == 1
margin = 0.5;
fontsize = 18;
elseif nargin == 2
fontsize = 18;
end
set(get(gca,'xlabel'),'FontSize', fontsize,'FontName','Times');
set(get(gca,'ylabel'),'FontSize', fontsize,'FontName','Times');
set(get(gca,'title'),'FontSize', fontsize,'FontName','Times');
%axis square;
set(gca,'LineWidth',0.5);
set(gca,'FontSize',6);
set(gca,'FontWeight','normal');
set(gcf,'color','w');
set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperSize', [6 4]);
set(gcf,'PaperSize', [8 6]);
set(gcf,'PaperPosition',[margin margin 8-2*margin 6-2*margin]);
set(gcf,'PaperPositionMode','Manual');
