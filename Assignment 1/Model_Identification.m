% -------------------------------------------------------------------------
% -- Description -- 
% Script for the model identification of the dc motor and cart, 
% part of the control theory exam assignement.
% -- Date -- 
% November 2021
% -- Authors -- 
% Schietecat Mathias
% Smets Karel
% -------------------------------------------------------------------------

clear all; close all;

%% data pre-processing

verbose = 1;        % ask for more output
filename = "C:\Users\Karel\Documents\Leuven\Master\Regeltechniek\Mecotron\Assignment1\filename.csv";

csvfile = filename;
labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
data = dlmread(csvfile, ',', 2, 0); % Data follows the labels

if verbose
    figure(10)
    hold on
    
    t = data(:,1);
    
    for i = 2:(length(data(1,:))-1)
        plot(data(:,1),data(:,i))
    end
    xlabel('t [s]')
    
    legend(labels)
    
end

%% identification of the simple model



%% identification of the exacter model