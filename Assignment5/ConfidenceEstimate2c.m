% -- NIS SNIS calculation sreamlining script
clear all; close all


% --------------------------
% -- INPUT FOR FILES HERE --
export_fig = 1;

states = [1 2 3];
confidence = 0.95;

% -- FILES --
files = [".\measured data\22_12\ff_00.csv"
         ".\measured data\22_12\ff_22.csv"
         ".\measured data\22_12\ff_hoekfout.csv"]

R = [1e-6 0
     0    1e-6];

% -- processing --

for i = 1:length(files(:,1))
    
    % clean up
    clear readdata readlabels obj
    
    filename = files(i);
    csvfile = convertStringsToChars(filename);
    
    % label order: P11, P12, P13, P22, P23, P33, x1, x2, x3, y1, y2
    labels = {'P11','P12','P13','P22','P23','P33','x1','x2','x3','y1','y2'}; 
    
    datastartline = 3;  % depends on QRC version
    delimiter = ',';    % depends on QRC version
    
    readlabels = strsplit(fileread(csvfile),{'\r','\n'});                % Split and fetch the labels
    readlabels = strsplit(readlabels{:,datastartline-1},[delimiter ' ']);
    readdata = dlmread(csvfile, delimiter, datastartline-1, 0);  % data

    i_start = find(readdata(:,2)==-0.3,1)+1;
    readdata = readdata((i_start:end),:);
    
    [lia,locb] = ismember(labels,readlabels);
    readdata = readdata(:,[1 locb]);
    
    r = repmat(R,[1 1 size(readdata,1)]);
    u = zeros(0,size(readdata,1));
    P = reshape([readdata(:,2:4) readdata(:,3) readdata(:,5:6) readdata(:,4) readdata(:,6) readdata(:,7)]', [3,3,size(readdata,1)]);
    
    figure()
    
    obj = KalmanExperiment(readdata(:,1)/1000, readdata(:,8:10)', P, readdata(:,11:12)', r, u);      
    plotstates(obj, states, confidence);
    
end

if export_fig

    figs = findobj('Type','figure')
    fignames = ["ff_hoekfout_th"
                "ff_hoekfout_y"
                "ff_hoekfout_x"
                "ff_22_th"
                "ff_22_y"
                "ff_22_x"
                "ff_00_th"
                "ff_00_y"
                "ff_00_x"];

    for i = 1:length(figs)
        
        measurementName = fignames(i)

        fig = figs(i);
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 6 3];
        print(fig,measurementName,'-dpng','-r0')
        movefile(".\"+measurementName+".png", ".\StatePlots")
        
    end
end
