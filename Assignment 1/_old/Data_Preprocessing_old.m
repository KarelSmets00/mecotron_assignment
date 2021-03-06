%% Data pre-processing (without cart, no 'load')

verbose = 1;        % ask for more output
location = ".\Measured Data\StepInput\singleStep\";
len = 80;
shift = 10;
Ts = 0.01;
voltageInterval = 3;
voltage = 6

for i = 1:4
    for j = 1:5
        
        file = append(int2str(i*voltageInterval),"_",int2str(j),".csv");
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
th_mean = mean(data(:,2,(1:5)),3);
v_mean = mean(data(:,3,(1:5)),3);
u_mean = mean(data(:,4,(1:5)),3)*voltageInterval;

figure(10)
hold on
box on
plot(t,th_mean)
plot(t,v_mean)
stairs(t,u_mean)
xlabel('t [s]')
legend('th','v','u')
title('Measurements')








