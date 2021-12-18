function Autosave_figure(name,height)
    fig = gcf
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 6 height];
    print(name,'-dpng','-r0')
    movefile(".\"+name+".png", ".\figs")
end 