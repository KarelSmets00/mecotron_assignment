% -- NIS SNIS calculation sreamlining script
clear all; close all


% --------------------------
% -- INPUT FOR FILES HERE --
export_fig = 1;

confidence = 0.95;   % confidence bound
M = 5;               % samples for SNISS
% -- FILES --
files = [".\measured data\Vraag3C\R9.5199e_7\Qe_1.csv",         9.1599e-7;
         ".\measured data\Vraag3C\R9.5199e_7\Qe_3.csv",         9.1599e-7;
         ".\measured data\Vraag3C\R9.5199e_7\Qe_5.csv",         9.1599e-7;
         ".\measured data\Vraag3C\R9.5199e_7\Qe_7.csv",         9.1599e-7;
         ".\measured data\Vraag3C\R9.5199e_7\Qe_8.csv",         9.1599e-7;
         ".\measured data\Vraag3C\R9.5199e_7\Qe_9.csv",         9.1599e-7;
         ".\measured data\Vraag3C\R9.5199e_7\Qe_11.csv",        9.1599e-7;
         ".\measured data\Vraag3C\R9.5199e_7\Q95199e_11.csv",   9.1599e-7;
         ".\measured data\Vraag3C\Qe_8\Re_0.csv",                       1;
         ".\measured data\Vraag3C\Qe_8\Re_2.csv",                    1e-2;
         ".\measured data\Vraag3C\Qe_8\Re_4.csv",                    1e-4;
         ".\measured data\Vraag3C\Qe_8\Re_6.csv",                    1e-6];

% -- processing --

for i = 1:length(files(:,1))
    
    % clean up
    clear readdata readlabels obj
    
    filename = files(i,1);
    R = files(i,2);
    csvfile = convertStringsToChars(filename);
    
    % label order: P11, P12, P13, P22, P23, P33, x1, x2, x3, y1, y2
    labels = {'P11','P12','P13','P22','P23','P33','x1','x2','x3','y1','y2'}; 
    
    datastartline = 3;  % depends on QRC version
    delimiter = ',';    % depends on QRC version
    
    readlabels = strsplit(fileread(csvfile),{'\r','\n'});                % Split and fetch the labels
    readlabels = strsplit(readlabels{:,datastartline-1},[delimiter ' ']);
    readdata = dlmread(csvfile, delimiter, datastartline-1, 0);  % data

    i_start = find(readdata(:,10)==-0.15,1)+1;
    readdata = readdata((i_start:end),:);
    
    [lia,locb] = ismember(labels,readlabels);
    readdata = readdata(:,[1 locb]);
    
    R = repmat(R,[1 1 size(readdata,1)]);
    u = zeros(0,size(readdata,1));
    
    obj = KalmanExperiment(readdata(:,1)/1000, readdata(:,3)', permute(readdata(:,2),[2 3 1]), readdata(:,4)', R, u, readdata(:,5)', permute(readdata(:,6),[2 3 1]));     
    [prob_nis, prob_snis] = analyzeconsistency(obj, confidence, M);
    
    filename = strsplit(filename,'\');
    measurementName = erase(filename(end),'.csv');
    
    if export_fig
        fig = gcf;
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 6 3];
        print(measurementName,'-dpng','-r0')
        movefile(".\"+measurementName+".png", ".\NIS_SNISS")
    end 
    
end


