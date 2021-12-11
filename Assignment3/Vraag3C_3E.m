close all; clear all;

[data_R,files_R,t,Ts,len] = Data_Preprocessing('.\measured data\Vraag3C\R9.5199e_7\',400);      %_R means for cte R, Q is variating
[data_Q,files_Q,t,Ts,len] = Data_Preprocessing('.\measured data\Vraag3C\Qe_8\',400);            %_Q means for cte R, R is variating

% t_R = data_R(:,1);                  
% VoltA_R = data_R(:,2);             
% VoltB_R = data_R(:,3);             
% DesiredVelocity_R = data_R(:,4);    
% Phat_R = data_R(:,5);              
% L_R = data_R(:,6);                 
% vA_R = data_R(:,7);                 
% vB_R = data_R(:,8);                
% FrontDistance_R = data_R(:,9);      
% xhat_R = data_R(:,10);             
% nu_R = data_R(:,12);                
% S_R = data_R(:,13);                

% -------- VRAAG C --------
figure
[~,~,c] = size(data_R);
hold on
title("Vraag C voor cte R")
for i = 1:c
    plot(t, data_R(:,5,i))
    xlabel("t [s]")
    ylabel("P_{k|k}")
    legend("Q = 1e-1","Q = 1e-11","Q = 1e-3","Q = 1e-5","Q = 1e-7","Q = 1e-9")
end

figure
[~,~,c] = size(data_Q);
hold on
title("Vraag C voor cte Q")
for i = 1:c
    plot(t, data_Q(:,5,i))
    xlabel("t [s]")
    ylabel("P_{k|k}")
    legend("R = 1e0","R = 1e-2","R = 1e-4","R = 1e-6")
end

figure
[~,~,c] = size(data_R);
hold on
title("Vraag C voor cte R")
for i = 1:c
    plot(t, data_R(:,6,i))
    xlabel("t [s]")
    ylabel("L_k")
    legend("Q = 1e-1","Q = 1e-11","Q = 1e-3","Q = 1e-5","Q = 1e-7","Q = 1e-9")
end

figure
[~,~,c] = size(data_Q);
hold on
title("Vraag C voor cte Q")
for i = 1:c
    plot(t, data_Q(:,6,i))
    xlabel("t [s]")
    ylabel("P_{k|k}")
    legend("R = 1e0","R = 1e-2","R = 1e-4","R = 1e-6")
end

%% -------- VRAAG E --------
[~,~,c] = size(data_R);
for i = 1:c
    figure
    hold on 
    title(files_R(i+2))
    plot(t, data_R(:,9,i))
    plot(t, -data_R(:,10,i))
    xlabel("t [s]")
    ylabel("State 1 [m]")
    legend("Measured front distance", "estimated state")
    
end

[~,~,c] = size(data_Q);
for i = 1:c
    figure
    hold on 
    title(files_Q(i+2))
    plot(t, data_Q(:,9,i))
    plot(t, -data_Q(:,10,i))
    xlabel("t [s]")
    ylabel("State 1 [m]")
    legend("Measured front distance", "estimated state")
    
end

% ---- subplots ----
[~,~,c] = size(data_R);
figure
hold on
title("constant R, varying Q")
for i = 1:c
    subplot(c,1,i)
    hold on
    title(files_R(i+2))
    plot(t, data_R(:,9,i))
    plot(t, -data_R(:,10,i))
    xlabel("t [s]")
    ylabel("State 1 [m]")
    legend("Measured front distance", "estimated state")
    
end

[~,~,c] = size(data_Q);
figure
hold on
title("constant Q, varying R")
for i = 1:c
    subplot(c,1,i)
    hold on 
    title(files_Q(i+2))
    plot(t, data_Q(:,9,i))
    plot(t, -data_Q(:,10,i))
    xlabel("t [s]")
    ylabel("State 1 [m]")
    legend("Measured front distance", "estimated state")
    
end