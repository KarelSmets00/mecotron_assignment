export_fig = 1;

fig_a = figure()
x = 0:pi/100:2*pi;
y = sin(x);
plot(x,y)

if export_fig
    fig = fig_a
    % fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 6 3];
    print('exportedTestFigure','-dpng','-r0')
end 