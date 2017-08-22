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

set(0,'defaultAxesFontSize',8);
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


figure('name', 'Voltage Profiles','NumberTitle','off');
set(gcf,'units','normalized','outerposition',[0 0 1 1])

sub_plot_num = ceil(sqrt(length(v)));
min_lim = abs(min(min(v)))/1.1;

for i = 1 : length(v)
    subplot(sub_plot_num,sub_plot_num,i)
    if abs(min(v(i,:))) < 0.8
        color = 'r';
    elseif abs(min(v(i,:))) < 0.9
        color = [1 1 0];
    else
        color = 'b';
    end
    plot(abs(v(i,:)), 'color', color);
    ylabel('V [p.u.]'), title(strcat('Bus',{' '}, num2str(i))), xlim([1 num_hours]), ylim([min_lim 1])
end

