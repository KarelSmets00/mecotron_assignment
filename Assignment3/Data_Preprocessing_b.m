function [data,files,t,Ts,len] = Data_Preprocessing_b(folder,len)

    % -- Data pre-processing --

    dir_list = dir(folder);
    files = {};

    j = 1;
    for i = 1:length(dir_list)
        item = strsplit(convertCharsToStrings(dir_list(i).name),'.');
        if (length(item) >= 2)
            extension = item(2);
            if (extension == "csv")
                files(j) = {dir_list(i).name};
                j = j + 1;
            end
        end
    end


    Ts = 0.01;

    for i = 1:length(files)

        filename = convertCharsToStrings(files(i));
        csvfile = convertStringsToChars(folder + filename);

        labels = strsplit(fileread(csvfile), '\n'); % Split file in lines
        labels = strsplit(labels{:, 2}, ', '); % Split and fetch the labels (they are in line 2 of every record)
        data_temp = dlmread(csvfile, ',', 2, 0); % Data follows the labels

        %i_start = find(data_temp(:,10)==-0.15,1);
        i_start = 1;
        data(:,:,i) = data_temp((i_start:(i_start+len-1)),:);

    end

    t = Ts*(0:1:(len-1));

end