[data,files,t,Ts,len] = Data_Preprocessing('.\measured data\Vraag3C\R9.5199e_7\',400);

figure()
hold on
[a b c] = size(data);

for i = 1:c
plot(t,data(:,10,i))
end

labels = convertStringsToChars(files)'
legend(labels(3:end))