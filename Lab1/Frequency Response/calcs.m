function [delta_th,delta_thref,t_phi,G_gain, G_phase] = calcs(filename,freq)
    
    % All frequency response saved in this folder
    str=strcat('N:\GitHub\ECE481\Lab1\Data\05-31-17\Freqency Resp\',filename,' hz\');
   
    % Get experimental data
    Data_ref = xlsread(char(strcat(str,'ref.xlsx')));
    Data_ang = xlsread(char(strcat(str,'ang.xlsx')));
    Data_v = xlsread(char(strcat(str,'v.xlsx')));
    
    % Ignore first bit of data (ignore transients)
    N1= ceil(length(Data_ref(:,1))/4);
    N2= length(Data_ref(:,1));
    
    % Get relevant t, ref angle and gear angle
    t = Data_ref(N1:N2,1);
    th_ref = Data_ref(N1:N2,2);
    th = Data_ang(N1:N2,2);
    clear Data_ref Data_ang Data_v
    
    % Gain 
    delta_th=max(th)-min(th);
    delta_thref=max(th_ref)-min(th_ref); 
    G_gain=abs(delta_th)/abs(delta_thref);
    T=1/freq;
    
    %Prompt user for ginput for time phase calculation
    figure1=figure;
    hold on
    plot(t,th_ref,'--','linewidth',3);
    plot(t,th,'linewidth',1);
    hold off
    freq_str=num2str(freq);
    str = strcat('Lab 1 Frequency Plot for f=', freq_str, ' [Hz]');
    title(str);
    xlabel('');
    ylabel('\theta [rad]');
    legend('\theta_ref', '\theta');
    
    %Manually click
    t = zeros(1,2);
    [t,~]=ginput(2);
    plotstr=strcat('Plots\Plot_',filename);
    plotstr=char(plotstr);
    print(figure1,'-djpeg',plotstr);
    close all
    
    %Continue w/ output parameter calculations
    t_phi=t(2)-t(1);  
    G_phase=(-360*t_phi)/T;

end

