%% plot to check model coverage

model = sys_32z;

figure
subplot(3,1,1);
hold on 
resp = lsim(model, u_meanBackup(:,1), t);
plot(t, resp);
plot(t,v_meanBackup(:,1));

subplot(3,1,2);
hold on 
resp = lsim(model, u_meanBackup(:,2), t);
plot(t, resp);
plot(t,v_meanBackup(:,2));

subplot(3,1,3);
hold on 
resp = lsim(model, u_meanBackup(:,3), t);
plot(t, resp);
plot(t,v_meanBackup(:,3));
