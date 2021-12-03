close all;


folder = "V2withFilter"       % "withFilter" or "withoutFilter"
slope = 'f10'                 % "s7"=slope or ... 

verbose = 1; 

location = ".\Measured Data\" + folder + "\" ;


shift = 10;
Ts = 0.01;
len = 250;

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



if verbose

    t = 0:Ts:Ts*(len-1);
    figure (2)
    hold on

    for i=1:4  
    plot(t, data(:,4,i));       %reference
    %plot(t, data(:,2,i));      %vA    
    plot(t, data(:,3,i));       %vB
    lsim()
    %plot(t, data(:,7,i));
    %plot(t, data(:,8,i));
    xlabel('t [s]')
    title('step responses')
    end

end