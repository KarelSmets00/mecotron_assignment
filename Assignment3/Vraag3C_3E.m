close all; clear all;

figC = 0;
figE = 1;
figE_individual = 0;

[data_R_temp,files_R,t,Ts,len] = Data_Preprocessing('.\measured data\Vraag3C\R9.5199e_7\',400,0);      %_R means for cte R, Q is variating
[data_Q,files_Q,t,Ts,len] = Data_Preprocessing('.\measured data\Vraag3C\Qe_8\',400,0);            %_Q means for cte R, R is variating

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
% nu = data(:,12);                
% S = data(:,13);           

%rearranging data_R
data_R = data_R_temp(:,:,[2 4:8 3]);
files_R = files_R([2 4:8 3]);
titles_R = ["Q = 1e-1m^2" "Q = 1e-3m^2" "Q = 1e-5m^2" "Q = 1e-7m^2" "Q = 1e-8m^2" "Q = 1e-9m^2" "Q = 1e-11m^2"];

titles_Q = ["R = 1e0m^2","R = 1e-2m^2","R = 1e-4m^2","R = 1e-6m^2"];

% -------- VRAAG C --------
if figC
    figure
    [~,~,c] = size(data_R);
    hold on
    title("Constant R = 9.5199e-7")
    for i = 1:c
        plot(t, data_R(:,5,i))
        xlabel("t [s]")
        ylabel("P_{k|k} [m^2]")
    end
    legend("Q = 1e-1m^2", "Q = 1e-3m^2","Q = 1e-5m^2","Q = 1e-7m^2","Q = 1e-8m^2",...
        "Q = 1e-9m^2","Q = 1e-11m^2", "Location","best")
    
    figure
    [~,~,c] = size(data_Q);
    hold on
    title("Constant Q = 1e-8")
    for i = 1:c
        plot(t, data_Q(:,5,i))
        xlabel("t [s]")
        ylabel("P_{k|k} [m^2]")
    end
    legend("R = 1e0m^2","R = 1e-2m^2","R = 1e-4m^2","R = 1e-6m^2", "Location","best")
    
    figure
    [~,~,c] = size(data_R);
    hold on
    title("Constant R = 9.5199e-7")
    for i = 1:c
        plot(t, data_R(:,6,i))
        xlabel("t [s]")
        ylabel("L_k [-]")
    end
    legend("Q = 1e-1m^2", "Q = 1e-3m^2","Q = 1e-5m^2","Q = 1e-7m^2","Q = 1e-8m^2",...
        "Q = 1e-9m^2","Q = 1e-11m^2", "Location","best")
    
    figure
    [~,~,c] = size(data_Q);
    hold on
    title("Constant Q = 1e-8")
    for i = 1:c
        plot(t, data_Q(:,6,i))
        xlabel("t [s]")
        ylabel("L_k [-]")
    end
    legend("R = 1e0m^2","R = 1e-2m^2","R = 1e-4m^2","R = 1e-6m^2", "Location","best")
end

Linfinity = data_R(399, 6, :);

if figE
    if figE_individual
        %-------- VRAAG E --------
        [~,~,c] = size(data_R);
        for i = 1:c
            figure
            hold on 
            title(titles_R(i))
            plot(t, data_R(:,9,i))
            plot(t, -data_R(:,10,i))
            xlabel("t [s]")
            ylabel("State [m]")
            legend("Measured front distance", "estimated state")
            
        end
        
        [~,~,c] = size(data_Q);
        for i = 1:c
            figure
            hold on 
            title(titles_Q(i))
            plot(t, data_Q(:,9,i))
            plot(t, -data_Q(:,10,i))
            xlabel("t [s]")
            ylabel("State [m]")
            legend("Measured front distance", "estimated state")
            
        end
    end
    
    % ---- subplots ----
    [~,~,c] = size(data_R);
    figure
    hold on
    title("constant R, varying Q")
    for i = 1:c
        subplot(4,2,i)
        hold on
        title(titles_R(i))
        plot(t, data_R(:,9,i))
        plot(t, -data_R(:,10,i))
        xlabel("t [s]")
        ylabel("State [m]")
        legend("Measured front distance", "estimated state")
        
    end
    
    [~,~,c] = size(data_Q);
    figure
    hold on
    title("constant Q, varying R")
    for i = 1:c
        subplot(c,1,i)
        hold on 
        title(titles_Q(i))
        plot(t, data_Q(:,9,i))
        plot(t, -data_Q(:,10,i))
        xlabel("t [s]")
        ylabel("State [m]")
        legend("Measured front distance", "estimated state")
        
    end
end
