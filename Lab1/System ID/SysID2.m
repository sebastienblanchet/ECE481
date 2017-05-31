% ECE 481: Lab 1
% Sebastien Blanchet & Bo Wang
% Group 12, Station 5
% June 1, 2017
clear
close all
clc

% Define constants
Kp = 20;        % 20 proportional gain constant
Ts = 10E-3;     % 10 ms sample time


%Import system data
Data_Vmot = xlsread('N:\GitHub\ECE481\Lab1\Data\05-31-17\Step\MotorV.xlsx');
Data_Og = xlsread('N:\GitHub\ECE481\Lab1\Data\05-31-17\Step\ang.xlsx');
Data_Oref = xlsread('N:\GitHub\ECE481\Lab1\Data\05-31-17\Step\ref.xlsx');

%Get first bit of data
vals = ceil(length(Data_Oref));

% Get data
t = Data_Oref(1:vals,1);
Og = Data_Og(1:vals,2);
Oref= Data_Oref(1:vals,2);
Vmot = Data_Vmot(1:vals,2);

%Clear data Import
clear Data_Vmot Data_Og Data_Oref

%Plots
figure(1)
subplot(2,1,1)
hold on
plot(t,Og);
plot(t,Oref);
hold off
ylabel('Angle [Rad]');
xlabel('Time [s]');
legend('Gear','Ref');

subplot(2,1,2)
plot(t,Vmot);
