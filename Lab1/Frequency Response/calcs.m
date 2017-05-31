function [delta_x,delta_xr,t_phi,G_gain, G_phase] = calcs(filename,freq)

    str=strcat('N:\GitHub\ECE481\Lab1\Data\05-31-17\Freqency Resp\',filename,' hz\');
    str=char(str);
    load(str);

    delta_x=max(x_exp)-min(x_exp);
    delta_xr=max(xr_exp)-min(xr_exp); 
    G_gain=abs(delta_x)/abs(delta_xr);
%     G_db=20*log(G_gain);
    T=1/freq;
  
    n1=2001;
    n2=find(t_exp==(2+(4*T)));
    
    if isempty(n2)==true
        n2=3001;
    end
      
    %Prompt user for ginput
    figure1=figure;
    hold on
    plot(t_exp(n1:n2),xr_exp(n1:n2),'--','linewidth',1);
    plot(t_exp(n1:n2),x_exp(n1:n2),'linewidth',1);
    hold off
    freq_str=num2str(freq);
    str = strcat('Lab 3.1.b Plot for f=', freq_str, ' [Hz]');
    title(str);
    xlabel('');
    ylabel('Position [mm]');
    legend('X_r', 'X');
    %Manually click
    t=zeros(1,2);
    [t,~]=ginput(2);
    plotstr=strcat('Plots\Plot_',filename);
    plotstr=char(plotstr);
 
    print(figure1,'-djpeg',plotstr);
    close all
    
    %Continue w/ output parameter calculations
    t_phi=t(2)-t(1);  
    G_phase=(-360*t_phi)/T;

end

