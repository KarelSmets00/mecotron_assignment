%% plot to check model coverage

model = sys_32z;

figure
subplot(3,1,1);
hold on; grid on;
resp = lsim(model, u_mean_(:,1), t);
error_3V_abs = resp - v_mean_(:,1);
error_3V_rel = error_3V_abs./v_mean_(:,1);
plot(t, resp);
plot(t,v_mean_(:,1));


subplot(3,1,2);
hold on; grid on; 
resp = lsim(model, u_mean_(:,2), t);
error_6V_abs = resp - v_mean_(:,2);
error_6V_rel = error_6V_abs./v_mean_(:,2);
plot(t, resp);
plot(t,v_mean_(:,2));

subplot(3,1,3);
hold on; grid on  
resp = lsim(model, u_mean_(:,3), t);
error_9V_abs = resp - v_mean_(:,3);
error_9V_rel = error_9V_abs./v_mean_(:,3);
plot(t, resp);
plot(t,v_mean_(:,3));

figure
subplot(3,2,1)
hold on; grid on 
plot(t, error_3V_abs)
ylabel('abs err 3V')

subplot(3,2,2)
hold on; grid on; 
plot(t, error_3V_rel)
ylabel('abs rel 3V')

subplot(3,2,3)
hold on; grid on
plot(t, error_6V_abs)
ylabel('abs err 6V')

subplot(3,2,4)
hold on; grid on; 
plot(t, error_6V_rel)
ylabel('abs rel 6V')

subplot(3,2,5)
hold on; grid on; 
plot(t, error_9V_abs)
ylabel('abs err 9V')

subplot(3,2,6)
hold on; grid on; 
plot(t, error_9V_rel)
ylabel('abs rel 9V')

