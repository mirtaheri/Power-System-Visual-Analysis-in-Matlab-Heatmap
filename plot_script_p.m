% definitions for plotting figures
grid_color = .75*[1 1 1];
set(groot, 'DefaultTextInterpreter', 'Latex');
set(groot, 'DefaultLegendInterpreter', 'Latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultFigureRenderer','painters');
set(0,'defaultAxesLineWidth',1.0);
set(0,'defaultLineLineWidth',1.5);

set(0,'defaultAxesGridLineStyle',':');
set(0,'defaultAxesYGrid','on');
set(0,'defaultAxesXGrid','on');
set(0,'defaultAxesZGrid','on');

set(0,'defaultAxesFontSize',10);
set(0,'defaultTextFontSize',2);
set(0,'defaultAxesBox','on');
set(0,'defaultAxesXAxisLocation','bottom');

set(0,'defaultAxesYMinorGrid', 'off');

set(0,'defaultAxesXColor', 0*[1 1 1]);
set(0,'defaultAxesYColor', 0*[1 1 1]);
set(0,'defaultAxesZColor', 0*[1 1 1]);

width = 12; height = 10;
width_sq = 14; height_sq = 12;
set(0,'defaultFigureUnits','centimeters');
set(0,'defaultFigurePosition',[5 5 width height]);


figure('name', 'Load and Genereation Profile','NumberTitle','off');
set(gcf,'units','normalized','outerposition',[0 0 1 1])

subplot(3,2,1)
plot(res/peak_factor, 'r');
ylabel('Active Power [p.u.]'), title('Residential'), xlim([1 num_hours])

subplot(3,2,2)
plot(hydr, 'color', [0, 0.5, 0]);
ylabel('Active Power [p.u.]'), title('Hydro Power'), xlim([1 num_hours])

subplot(3,2,3)
plot(ind, 'r');
ylabel('Active Power [p.u.]'), title('Industrial'), xlim([1 num_hours]), ylim([0 max(ind)*1.1])

subplot(3,2,4)
plot(PV, 'color', [0, 0.5, 0]);
ylabel('Active Power [p.u.]'), title('Photovoltaics'), xlim([1 num_hours]), ylim([-0.1 max(PV)*1.1])

subplot(3,2,5)
plot(ter, 'r');
ylabel('Active Power [p.u.]'), title('Tertiary'), xlim([1 num_hours]), ylim([0 max(ind)*1.1])

subplot(3,2,6)
plot(WT, 'color', [0, 0.5, 0]);
ylabel('Active Power [p.u.]'), title('Wind Power'), xlim([1 num_hours]), ylim([min(WT)-0.1 max(WT)*1.1])
