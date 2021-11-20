%% Data pre-processing (with cart)
clear all; close all;

motor = 'A';
verbose = 1; 

location = ".\Measured Data\StepInput\singleStepCartCurrent\";
len = 80;
shift = 10;
Ts = 0.01;
voltageInterval = 3;

i = 4;
for j = 1:5
    
    file = append(int2str(i*voltageInterval),"_",int2str(j),".csv");
    filename = append(location,file);
    
    csvfile = filename;
    labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
    labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
    data_temp = dlmread(csvfile, ',', 2, 0); % Data follows the labels
    
    i_start = find(data_temp(:,4)>0,1);
    dataCart(:,:,((i-1)*5+j)) = data_temp(((i_start-shift):(i_start+len-1-shift)),:);
    
end


% if verbose
% 
%     t = dataCart(:,1,1)/1000;
%     figure (2)
%     hold on
% 
%     for i=1:20  
%     %plot(t, data(:,2,((i-1)*5+j)))
%     plot(t, dataCart(:,3,i));
%     xlabel('t [s]')
%     title('3V step')
%     end
% 
% end

%onderstaande berekeningen gelden voor de 3V input!! Dit aanpassen als we de
%inputspanning gewijzigd wordt, plus aanpassingen maken aan
%Model_Identification zodat daar ook alles klopt

t = Ts*(0:1:(len-1));

switch motor
    case 'A'
        th_mean_ = mean(dataCart(:,2,(16:20)),3);
        v_mean_ = mean(dataCart(:,3,(16:20)),3);
        u_mean_ = mean(dataCart(:,4,(18:20)),3)*3;
        i_mean_ = mean(dataCart(:,7,(16:20)),3);
    case 'B'
        th_mean_ = mean(dataCart(:,5,(1:5)),3);
        v_mean_ = mean(dataCart(:,6,(1:5)),3);
        u_mean_ = mean(dataCart(:,4,(1:5)),3)*3;
        i_mean_ = mean(dataCart(:,8,(1:5)),3);
end
    


figure(11)
hold on
box on
yyaxis left
%plot(t,th_mean_)
plot(t,v_mean_)
%stairs(t,u_mean_)
xlabel('t [s]')
ylabel('velocity [rad/s?]')

yyaxis right
hold on
plot(t, i_mean_)
ylabel('current')
legend('vCart','iCart')
title('Measurements')