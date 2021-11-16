%% data pre-processing

close all;

verbose = 1;        % ask for more output
location = "C:\Users\Karel\Documents\Leuven\Master\Regeltechniek\Mecotron\Assignment 1\Measured Data\StepInput\singleStep\";
%location = "C:\Users\mschi\Documents\Unief\Sem M1\Control Theory\mecotron_assignment\Assignment 1\Measured Data\StepInput\singleStep\";
len = 80;
shift = 10;
Ts = 0.01;
voltage = 3;

for i = 1:3
    for j = 1:5
        
        file = append(int2str(i*voltage),"_",int2str(j),".csv");
        filename = append(location,file);
        
        csvfile = filename;
        labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
        labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
        data_temp = dlmread(csvfile, ',', 2, 0); % Data follows the labels
        
        i_start = find(data_temp(:,4)>0,1);
        data(:,:,((i-1)*5+j)) = data_temp(((i_start-shift):(i_start+len-1-shift)),:);
        
    end
end

if verbose

    t = data(:,1,1)/1000;
    figure (1)
    hold on

    for i=1:15   
    %plot(t, data(:,2,((i-1)*5+j)))
    plot(t, data(:,3,i));
    xlabel('t [s]')
    title('3V step')
    end

end

%onderstaande berekeningen gelden voor de 3V input!! Dit aanpassen als we de
%inputspanning gewijzigd wordt, plus aanpassingen maken aan
%Model_Identification zodat daar ook alles klopt

t = Ts*(0:1:(len-1));
th_mean = [mean(data(:,2,(1:5)),3), mean(data(:,2,(6:10)),3), mean(data(:,2,(10:15)),3)];
v_mean = [mean(data(:,3,(1:5)),3), mean(data(:,3,(6:10)),3), mean(data(:,3,(10:15)),3)];
u_mean = [mean(data(:,4,(1:5)),3)*3, mean(data(:,4,(6:10)),3)*6, mean(data(:,4,(10:15)),3)*9];

figure(10)
hold on
box on
plot(t,th_mean)
plot(t,v_mean)
stairs(t,u_mean)
xlabel('t [s]')
legend('th','v','u')
title('Measurements')


%% lineariteit check

model = sys_32z;

resp_3 = lsim(model,u_mean(:,1),t);
resp_6 = lsim(model,u_mean(:,2),t);
resp_9 = lsim(model,u_mean(:,3),t);

% som van 3 en 6 moet overeen komen met 9

resp_sup = resp_3 + resp_6;

figure(310)
subplot(2,1,1)
hold on
plot(t,resp_sup')
plot(t,v_mean(:,3))
legend('lsim', 'meas')

subplot(2,1,2)
plot(t,(resp_sup'-v_mean(:,3)'))
