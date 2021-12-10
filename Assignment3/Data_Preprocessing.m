function [data,files,t,Ts,len] = Data_Preprocessing(folder,len)
% -- Data pre-processing --


file_list = dir(folder);
files = repmat("",length(file_list),1);

for i = 1:length(file_list)
    files(i)= convertCharsToStrings(file_list(i).name);
end


Ts = 0.01;

for i = 3:length(files)
    
    filename = files(i);
    csvfile = convertStringsToChars(folder + filename);
    
    labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
    labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
    data_temp = dlmread(csvfile, ',', 2, 0); % Data follows the labels

    i_start = find(data_temp(:,10)==-0.15,1);
    data(:,:,(i-2)) = data_temp((i_start:(i_start+len-1)),:);
    
end

t = Ts*(0:1:(len-1));

end