clear all; close all;

export_fig = 1
%% design
%
K = 55;
Ts = 0.01;
R = 0.0325;

A = 1;
C = -1;
L = acker(A, A*C, exp(-Ts*R*K/10))

p_ed = exp(-Ts*R*K/10)


%% plots
[data,files,t,Ts,len] = Data_Preprocessing('.\measured data\Vraag3F\',2500,'vraagf');

figure
hold on
plot(t, data(:, 9))
plot(t, data(:,10))
xlabel("t [s]",'Interpreter','Latex')
ylabel('-$\hat{x}$ [m] , y [m]','Interpreter','Latex')
legend("Measured front distance", "Estimated state",'Interpreter','Latex')

measurementName = 'vraag3f';

if export_fig
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 6 4];
    print(measurementName,'-dpng','-r0')
    movefile(".\"+measurementName+".png", ".\figs")
end 


