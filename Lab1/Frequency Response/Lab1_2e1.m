%ECE 481: Lab#1
%Group 12: Sebastien Blanchet, Bo Wang
%31/05/2017

close all
clear 
clc

% parameters
s=tf('s');
K_p=20;

% Calculate natural frequency and damping (using ident tool)
w_n=sqrt(2.543612067878663e+02);
z=23.209620771542717/(2*w_n);

% Frequency vectors [Hz]
f_theo_hz=0.5:0.1:50;
f_theo_rad=2*pi*f_theo_hz;

filenames={'01','05','10','20','25','35','50','100'};
n=length(filenames);

f_exp_hz=[0.1; 0.5; 1; 2.0; 2.5; 3.5; 5.0; 10];
f_exp_rad=2*pi*f_exp_hz;

del_x=zeros(n,1);
del_xr=zeros(n,1);
t_ph=zeros(n,1);
G_g=zeros(n,1);
G_ph=zeros(n,1);

for i=1:n
    txt=strcat(filenames(i));
    [del_x(i),del_xr(i),t_ph(i),G_g(i), G_ph(i)]=calcs(txt,f_exp_hz(i));
end

Table_title={'f','delta x','delta xr','t phi','G gain','G phase'};
Table_data=[f_exp_hz,del_x,del_xr,t_ph,G_g,G_ph];
Table_1=[Table_title;num2cell(Table_data)];
xlswrite('Plots\Table1_notdb_Data',Table_1,'Sheet1','A1');

%Theoretical transfer function
G_s=(w_n^2)/((s^2)+(2*z*w_n*s)+(w_n^2));
[Gain_Sim,Phase_Sim]=bode(G_s,f_theo_rad);

subplot(2,1,1)
hold on
G_sim=reshape(Gain_Sim(1,1,:),1,496);
scatter(f_exp_rad,G_g);
plot(f_theo_rad,G_sim);
title('Closed Loop Freqency Responses')
ylabel('Gain [mm/mm]');
set(gca,'xticklabel',{[]});
legend('Exp.', 'Theo.');
hold off

subplot(2,1,2)
hold on
Ph_sim=reshape(Phase_Sim(1,1,:),1,496);
scatter(f_exp_rad,G_ph);
plot(f_theo_rad,Ph_sim);
ylabel('Phase [deg]');
xlabel('Frequency [rad/s]');
legend('Exp.', 'Theo.');
hold off

print(1,'-djpeg','Plots\Plot_1c_rev1');
