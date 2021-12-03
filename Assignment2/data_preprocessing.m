close all; clear all;

PI_controller   %make sure PM=80!!!!


folder = "V2withFilter"       % "withFilter" or "withoutFilter"
slope = 'f10'                 % "s7"=slope or ... 

verbose = 0; 
plot_report = 1;


location = ".\Measured Data\" + folder + "\" ;


shift = 10;
Ts = 0.01;
len = 200;

%voltageInterval = 3;


for i = 1:3
    
    file = slope + "_PM80_" + int2str(i) +".csv"
    %file = append(slope,"_",int2str(i),".csv");
    filename = append(location,file);
    
    csvfile = filename;
    labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
    labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
    data_temp = dlmread(csvfile, ',', 2, 0); % Data follows the labels
    
    i_start = find(data_temp(:,3)>9);
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

t = 0:Ts:Ts*(len-1);

if verbose 
    
    figure (10)
    hold on

    for i=1:3 
    plot(t, data(:,4,i));       %reference
    plot(t, data(:,2,i));       %vA   
    plot(t, data(:,3,i));       %vB
    %plot(t, data(:,7,i));
    %plot(t, data(:,8,i));
    xlabel('t [s]')
    title('step responses')
    end
    
end

if plot_report
    % closed loop response
    vsim = lsim(sys_CL, data(:,4,i),t);

    figure (11)
    hold on
    plot(t, data(:,4,1));       %reference 
    plot(t, data(:,3,1));       %vB
    plot(t,vsim);
    %plot(t, data(:,7,i));
    %plot(t, data(:,8,i));
    xlabel('t [s]')
    ylabel('Angular velocity [rad/s]')
    legend('reference', 'measured closed-loop response', 'simulated closed-loop response', 'Location', 'SouthEast')

    % tracking error
    figure(12)
    hold on;
    plot(t, data(:,6,1))
    plot(t, (data(:,4,1)-vsim))
    xlabel(['t [s]'])
    ylabel('Tracking error [rad/s]')
    legend('measured tracking error', 'simulated tracking error')

    % control signal
    error_sim = data(:,4,1)-vsim;
    u_sim=lsim(sys_D, error_sim, t);

    figure(13)
    hold on;
    plot(t, data(:,8,1))
    plot(t,u_sim)
    xlabel('t [s]')
    ylabel('Control signel [V]')
    legend('measured control signal', 'simulated control signal')

end