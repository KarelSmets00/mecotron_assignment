close all; clear all;
file = "C:\Users\Karel\Documents\Leuven\Master\Regeltechniek\Mecotron\Assignment4\measured data\SDcovaraince\sideDistanceMeasurement15.csv";
%file = "C:\Users\Karel\Documents\Leuven\Master\Regeltechniek\Mecotron\Assignment4\measured data\SDcovaraince\sideDistanceMeasurement23.csv";

filename = file
        
        csvfile = filename;
        labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
        labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
        data = dlmread(csvfile, ',', 2, 0); % Data follows the labels


cov(data(:,2))

plot(data(:,1), data(:,2))

histogram(data(:,2), 100)