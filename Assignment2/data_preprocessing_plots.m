close all; clear all;

I=1
PI = 0
verbose = 1; 

if PI
    folder = "V2withFilter"       % "withFilter" or "withoutFilter"
    slope = 'f10'                 % "s7"=slope or ... 
    PI_controller;
elseif I 
    folder = "I_controller_6_disturbance"
    I_controller;
end

location = ".\Measured Data\" + folder + "\" ;


shift = 10;
Ts = 0.01;
len = 250;

%voltageInterval = 3;


for i = 1:2
    if PI
        file = slope + "_PM80_" + int2str(i) +".csv";
    elseif I
        file = "I_" + int2str(i) + ".csv"
    end
    filename = append(location,file);
    csvfile = filename;
    labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
    labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
    data_temp = dlmread(csvfile, ',', 2, 0); % Data follows the labels
    
    i_start = find(data_temp(:,4)>5);
    data(:,:,i) = data_temp(((i_start-shift):(i_start+len-1-shift)),:);
   
end

%{
data(:,2,...) = vA
data(:,3,...) = vB
data(:,4,...) = r
data(:,5,...) = eA
data(:,6,...) = eB
data(:,7,...) = uA
data(:,8,...) = uB
%}



if verbose

    t = 0:Ts:Ts*(len-1);
    t=t';

    y = lsim(sys_CL, data(:,4,i),t);

    for i=1:1  
    figure (10)
    hold on
    plot(t, data(:,4,i));       %reference
    %plot(t, data(:,2,i));      %vA    
    plot(t, data(:,3,i));       %vB
    plot(t,y);
    xlabel('t [s]')
    ylabel("angular velocity [rad/s]")
    legend("reference", "measured closed-loop response", "simulated closed-loop response", 'Location','southeast')
    end

    for i=1:1  
    figure (11)
    hold on   
    plot(t, data(:,6,1))
    plot(t, (data(:,4,1)-y))
    xlabel('t [s]')
    ylabel("tracking error [rad/s]")
    legend("measured tracking error", "simulated tracking error", 'Location','northeast')
    end

    error_sim = data(:,4,1)-y;
    u_sim=lsim(sys_D, error_sim, t);

    for i=1:1
    figure(12)
    hold on;
    plot(t, data(:,8,1))
    plot(t,u_sim)
    xlabel('t [s]')
    ylabel('Control signel [V]')
    legend('measured control signal', 'simulated control signal', 'Location','southeast')
    end
end