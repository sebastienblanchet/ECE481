%ME360: Lab#3 1.c
%Group #26: Sebastien Blanchet, Adrian Novotny, Timothy Wulff, Jason Zhang

clear all
close 
clc

%parameters
s=tf('s');
K_p=1;
K_v=113.367;
tau_v=0.079;

%Calculate natural frequency and damping
w_n=sqrt((K_p*K_v)/tau_v);
z=1/(2*tau_v*w_n);

%Frequency vectors [Hz]
f_exp_hz=[0.5,1,2.5,5,10,25,50];
f_theo_hz=0.1:0.5:50;

%Theoretical transfer function
G_s=(w_n^2)/((s^2)+(2*z*w_n*s)+(w_n^2));

figure1=figure;
hold on
bode(G_s,f_theo_hz*2*pi), grid;
hold off

print(1,'-djpeg','Plots\Plot_1c');

[gn,ph]=bode(G_s,f_theo_hz*2*pi);


% figure2=figure;
% plot(gn);


% % w = logspace(-1,2);
% % [mag, phase] = bode(G_s,w);
% % loglog(w,squeeze(mag)),grid;
% % semilogx(w,squeeze(phase)),grid;
