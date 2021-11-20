%% Checking the coverage of the model
% Model was calculated using only the RampUp
% Here it is also compared with the RampDown
window = 'RampDown'
Data_Preprocessing_Cart

model = sys_31z;

figure
subplot(4,1,1);
hold on; grid on;
resp = lsim(model, u_mean_(:,1), t);
error_3V_abs = resp - v_mean_(:,1);
error_3V_rel = error_3V_abs./v_mean_(:,1);
plot(t, resp);
plot(t,v_mean_(:,1));


subplot(4,1,2);
hold on; grid on; 
resp = lsim(model, u_mean_(:,2), t);
error_6V_abs = resp - v_mean_(:,2);
error_6V_rel = error_6V_abs./v_mean_(:,2);
plot(t, resp);
plot(t,v_mean_(:,2));

subplot(4,1,3);
hold on; grid on  
resp = lsim(model, u_mean_(:,3), t);
error_9V_abs = resp - v_mean_(:,3);
error_9V_rel = error_9V_abs./v_mean_(:,3);
plot(t, resp);
plot(t,v_mean_(:,3));

subplot(4,1,4);
hold on; grid on  
resp = lsim(model, u_mean_(:,4), t);
error_12V_abs = resp - v_mean_(:,4);
error_12V_rel = error_12V_abs./v_mean_(:,4);
plot(t, resp);
plot(t,v_mean_(:,4));

% error plot:
figure
subplot(4,2,1)
hold on; grid on 
plot(t, error_3V_abs)
ylabel('abs err 3V')

subplot(4,2,2)
hold on; grid on; 
plot(t, error_3V_rel)
ylabel('abs rel 3V')

subplot(4,2,3)
hold on; grid on
plot(t, error_6V_abs)
ylabel('abs err 6V')

subplot(4,2,4)
hold on; grid on; 
plot(t, error_6V_rel)
ylabel('abs rel 6V')

subplot(4,2,5)
hold on; grid on; 
plot(t, error_9V_abs)
ylabel('abs err 9V')

subplot(4,2,6)
hold on; grid on; 
plot(t, error_9V_rel)
ylabel('abs rel 9V')

subplot(4,2,7)
hold on; grid on; 
plot(t, error_12V_abs)
ylabel('abs err 12V')

subplot(4,2,8)
hold on; grid on; 
plot(t, error_12V_rel)
ylabel('abs rel 12V')
