function [data,t,u_mean_,th_mean_,v_mean_] = Data_Preprocessing(folder, motor)
% -- Data pre-processing --

verbose = 1; 

location = ".\Measured Data\StepInput\" + folder + "\";
len = 80;
shift = 10;
Ts = 0.01;
voltageInterval = 3;

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
    figure (2)
    hold on

    for i=1:20  
    plot(t, data(:,3,i));
    xlabel('t [s]')
    title('step responses')
    end

end


t = Ts*(0:1:(len-1));

switch motor
    case 'A'
        th_mean_ = [mean(data(:,2,(1:5)),3), mean(data(:,2,(6:10)),3), ...
                    mean(data(:,2,(11:15)),3), mean(data(:,2,(16:20)),3)];
        v_mean_ = [mean(data(:,3,(1:5)),3), mean(data(:,3,(6:10)),3), ...
                    mean(data(:,3,(11:15)),3), mean(data(:,3,(16:20)),3)];
        u_mean_ = [mean(data(:,4,(1:5)),3)*3, mean(data(:,4,(6:10)),3)*6, ...
                    mean(data(:,4,(11:15)),3)*9, mean(data(:,4,(16:20)),3)*12];
    case 'B'
        th_mean_ = [mean(data(:,5,(1:5)),3), mean(data(:,5,(6:10)),3), ...
                    mean(data(:,5,(11:15)),3), mean(data(:,5,(16:20)),3)];
        v_mean_ = [mean(data(:,6,(1:5)),3), mean(data(:,6,(6:10)),3), ...
                    mean(data(:,6,(11:15)),3), mean(data(:,6,(16:20)),3)];
        u_mean_ = [mean(data(:,4,(1:5)),3)*3, mean(data(:,4,(6:10)),3)*6, ...
                    mean(data(:,4,(11:15)),3)*9, mean(data(:,4,(16:20)),3)*12];
end
    


figure(11)
hold on
box on
plot(t,th_mean_)
plot(t,v_mean_)
stairs(t,u_mean_)
xlabel('t [s]')
legend('th Cart','vCart','uCart')
title('Measurements')

end