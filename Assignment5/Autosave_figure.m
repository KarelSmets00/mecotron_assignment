function Autosave_figure(name,width,height)
    fig = gcf
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 width height];
    print(name,'-dpng','-r0')
    movefile(".\"+name+".png", ".\figs")
end 