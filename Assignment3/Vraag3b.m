close all; clear all;

[data_temp,files,t,Ts,len] = Data_Preprocessing('.\measured data\K_tuning\',400,'vraagb'); 

% t = data(:,1);                  
% VoltA = data(:,2);             
% VoltB = data(:,3);             
% DesiredVelocity = data(:,4);    
% Phat = data(:,5);              
% L = data(:,6);                 
% vA = data(:,7);                 
% vB = data(:,8);                
% FrontDistance = data(:,9);      
% xhat = data(:,10);
% xref = data(:,11);
% nu = data(:,12);                
% S = data(:,13);                

%rearranging data
data(:,:,1:4) = data_temp(:,:,5:8);
data(:,:,5:8) = data_temp(:,:,1:4);

%stepinput
stepinput = zeros(size(t));
i_start = find(data_temp(:,11)==-0.2,1);
stepinput(1:i_start-1) = 0.15;
stepinput(i_start:end) = 0.2;


figure
hold on;
plot(t, stepinput);
[~,~,c] = size(data);
for i=1:c
    plot(t, data(:,9,i));
end
xlabel("time [s]")
ylabel("measured distance [m]")
legend("step input","K = 50","K = 55","K = 60","K = 80","K = 100","K = 150","K = 200","K = 300")

figure
hold on
plot(t, stepinput)
for i=1:c
    plot(t, data(:,2,i))
end
xlabel("time [s]")
ylabel("Controle signal motor A [V]")
legend("K = 50","K = 55","K = 60","K = 80","K = 100","K = 150","K = 200","K = 300", "Location","best")
