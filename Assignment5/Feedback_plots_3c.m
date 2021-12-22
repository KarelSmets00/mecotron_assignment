close all; clear all;

%% -- Data pre-processing --

len = 1600;

files = {'.\measured data\22_12\fb_00.csv'
         '.\measured data\22_12\fb_22.csv'
         '.\measured data\22_12\fb_hoekfout.csv'};

Ts = 0.01;

for i = 1:length(files)

    csvfile = convertCharsToStrings(files(i));

    labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
    labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
    data_temp = dlmread(csvfile, ',', 2, 0); % Data follows the labels

    i_start = find(data_temp(:,2)==-0.3,1);
    data(:,:,i) = data_temp((i_start:(i_start+len-1)),:);

end

t = Ts*(0:1:(len-1));

%% -- Plotting and saving --

export_fig = 1

[~,~,p] = size(data);

for i = 1:p
    
    figure()
    subplot(1,3,1)
    plot(t,data(:,8,i))
    xlabel('time t [s]')
    ylabel('tracking error x [m]')
    
    subplot(1,3,2)
    plot(t,data(:,9,i))
    xlabel('time t [s]')
    ylabel('tracking error y [m]')
    
    subplot(1,3,3)
    plot(t,data(:,10,i))
    xlabel('time t [s]')
    ylabel('tracking error \theta [rad]')
    
end

if export_fig

    figs = findobj('Type','figure')
    fignames = ["te_hoekfout"
                "te_22"
                "te_00"];

    for i = 1:length(figs)
        
        measurementName = fignames(i)

        fig = figs(i);
        fig.PaperUnits = 'centimeters';
        fig.PaperPosition = [0 0 30 10];
        print(fig,measurementName,'-dpng','-r0')
        movefile(".\"+measurementName+".png", ".\FeedbackPlots")
        
    end
    oldfigs = length(figs);
end


for i = 1:p
    
    figure()
    subplot(1,2,1)
    plot(t,data(:,11,i))
    xlabel('time t [s]')
    ylabel('forward velocity v [m/s]')
    
    subplot(1,2,2)
    plot(t,data(:,12,i))
    xlabel('time t [s]')
    ylabel('angular speed \omega [rad/s]')
    
    
end

if export_fig

    figs = findobj('Type','figure')
    fignames = ["cs_hoekfout"
                "cs_22"
                "cs_00"];

    for i = 1:(length(figs)-oldfigs)
        
        measurementName = fignames(i)

        fig = figs(i);
        fig.PaperUnits = 'centimeters';
        fig.PaperPosition = [0 0 20 10];
        print(fig,measurementName,'-dpng','-r0')
        movefile(".\"+measurementName+".png", ".\FeedbackPlots")
        
    end
    oldfigs = length(figs);
end

