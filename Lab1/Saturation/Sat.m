% ECE 481: Lab#1
% Group 12, Station 5: Sebastien Blanchet, Bo Wang
% 01/06/2017

%clear workspace
clear
close all
clc

%load data
load('Simulink.mat');
% Get experimental data
Data_ThRef = xlsread('N:\GitHub\ECE481\Lab1\Data\05-31-17\Saturation\ThRef.xlsx');
Data_ref = xlsread('N:\GitHub\ECE481\Lab1\Data\05-31-17\Saturation\Ref.xlsx');
Data_ang = xlsread('N:\GitHub\ECE481\Lab1\Data\05-31-17\Saturation\ang.xlsx');
Data_v = xlsread('N:\GitHub\ECE481\Lab1\Data\05-31-17\Saturation\v.xlsx');


%Create Subplots
%Position Trajectory Plots

subplot(4,1,1)
hold on

%ref
plot(Data_ref(:,1),Data_ref(:,2),'--','linewidth',1);
plot(ref(:,1),ref(:,2),'linewidth',1);
hold off
str = sprintf('Saturation plots for K_p=20');
title(str);
xlabel('');
ylabel('ref [rad]');
set(gca,'xticklabel',{[]});
legend('Exp.', 'Sim.'); 

%Saturation
subplot(4,1,2)
hold on
plot(Data_ThRef(:,1),Data_ThRef(:,2),'--','linewidth',1);
plot(ThRef_Sim(:,1),ThRef_Sim(:,2),'linewidth',1);
hold off
title('');
xlabel('');
ylabel('ThRef [rad]');
legend('Exp.','Sim.');

%Control Signal
subplot(4,1,3)
hold on
plot(Data_v(:,1),Data_v(:,2),'--','linewidth',1);
plot(u_sim(:,1),u_sim(:,2),'linewidth',1);
hold off
title('');
xlabel('');
ylabel('u [V]');
legend('Exp.','Sim.');


% Gear Angle
subplot(4,1,4)
hold on
plot(Data_ang(:,1),Data_ang(:,2),'--','linewidth',1);
plot(ServoAng_Sim(:,1),ServoAng_Sim(:,2),'linewidth',1);
hold off
title('');
set(gca,'xticklabel',{[]});
xlabel('Time [sec]');
ylabel('ServoAng [rad]');
legend('Exp.','Sim.');

print(1,'-djpeg','Plots\Tracking');