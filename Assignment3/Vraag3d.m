% -- NIS SNIS calculation sreamlining script
clear all; close all

export_fig = 1;

measurementName = "Qe_11"

data = KalmanExperiment.createfromQRC3()

confidence = 0.95   % confidence bound
M = 5               % samples for SNISS

figure()
[prob_nis, prob_snis] = analyzeconsistency(data, confidence, M)

if export_fig
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 6 3];
    print(measurementName,'-dpng','-r0')
    movefile(".\"+measurementName+".png", ".\NIS_SNISS")
end 