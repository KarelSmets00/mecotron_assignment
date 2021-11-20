%% data pre-processing

clear all; close all;

motor = 'B';                % choose wich motor to analyse
folder = "singleStepCart";  % folder in wich loaded motor experiments are stored

[data,t,u_mean_,th_mean_,v_mean_] = Data_Preprocessing(folder,motor);



%% lineariteit check

% som van 3 en 6 moet overeen komen met 9

resp_sup_9 = v_mean_(:,2) + v_mean_(:,1);
resp_sup_3 = v_mean_(:,2) - v_mean_(:,1);

figure(310)
subplot(2,1,1)
hold on
plot(t,resp_sup_3)
plot(t,v_mean_(:,1))
legend('meas 6v - meas 3v', 'meas 3v','Location','southeast')

subplot(2,1,2)
plot(t,(resp_sup_3-v_mean_(:,1)))

figure(320)
subplot(2,1,1)
hold on
plot(t,resp_sup_9)
plot(t,v_mean_(:,3))
legend('meas 6v + meas 3v', 'meas 9v','Location','southeast')

subplot(2,1,2)
plot(t,(resp_sup_9-v_mean_(:,3)))

% som van 4 keer 3V of 2 keer 6V moet overeen komen met 12V
figure(330)
subplot(2,1,1)
hold on
plot(t,4*v_mean_(:,1))
plot(t, 2*v_mean_(:,2))
plot(t,v_mean_(:,4))
legend('4x meas 3v', '2x meas 6v', 'meas 12v','Location','southeast')

subplot(2,1,2)
hold on
plot(t,(4*v_mean_(:,1)-v_mean_(:,4)))
plot(t,(2*v_mean_(:,2)-v_mean_(:,4)))
legend('error 4x 3V', 'error 2x 6V')

%% linearity check calculating the gradients

for i = 1:3
    grad(:,i) = v_mean_(:,i+1)-v_mean_(:,i);
end

figure(340)
hold on 
surf([1 2 3]',t, grad)
title('gradients')

figure(350)
hold on 
surf([3, 6, 9, 12]', t, v_mean_)
title('surface of responses')