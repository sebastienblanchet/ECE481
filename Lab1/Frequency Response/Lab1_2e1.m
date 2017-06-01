% ECE 481: Lab#1
% Group 12, Station 5: Sebastien Blanchet, Bo Wang
% 01/06/2017

% Initialize workspace
close all
clear 
clc

% Define constants (wn and z from System ID)
K_p=20;
w_n = 35.36;
z = 0.6;

% Frequency vectors [Hz]
f_theo_hz=0.5:0.1:25;
f_theo_rad=2*pi*f_theo_hz;

% Folder names of respective experimental frequencies
filenames={'01','05','10','20','25','50','100'};
n=length(filenames);
f_exp_hz=[0.1; 0.5; 1; 2.0; 2.5; 5.0; 10];
f_exp_rad=2*pi*f_exp_hz;

% Initialize phase and gain margin resutls
del_th=zeros(n,1);
del_thref=zeros(n,1);
t_ph=zeros(n,1);
G_g=zeros(n,1);
G_ph=zeros(n,1);

% Call calc() function to peform all frequency response calculations
for i=1:n
    txt=strcat(filenames(i));
    [del_th(i),del_thref(i),t_ph(i),G_g(i), G_ph(i)]=calcs(txt,f_exp_hz(i));
end

% Create table for data export
Table_title={'f','delta th','delta thref','t phi','G gain','G phase'};
Table_data=[f_exp_hz,del_th,del_thref,t_ph,G_g,G_ph];
Table_1=[Table_title;num2cell(Table_data)];
xlswrite('Plots\Table1_notdb_Data',Table_1,'Sheet1','A1');

% Theoretical transfer function for comparison with experimental
s=tf('s');
G_s=(w_n^2)/((s^2)+(2*z*w_n*s)+(w_n^2));
[Gain_Sim,Phase_Sim]=bode(G_s,f_theo_rad);

% Plot results
% Gain  subplot
subplot(2,1,1)
hold on
G_sim=reshape(Gain_Sim(1,1,:),1,246);
scatter(f_exp_rad,G_g);
plot(f_theo_rad,G_sim);
title('Closed Loop Freqency Responses')
ylabel('Gain [rad/rad]');
set(gca,'xticklabel',{[]});
legend('Exp.', 'Theo.');
hold off

% Phase subplot
subplot(2,1,2)
hold on
Ph_sim=reshape(Phase_Sim(1,1,:),1,246);
scatter(f_exp_rad,G_ph);
plot(f_theo_rad,Ph_sim);
ylabel('Phase [deg]');
xlabel('Frequency [rad/s]');
legend('Exp.', 'Theo.');
hold off

% Save plot
print(1,'-djpeg','Plots\overplay');
