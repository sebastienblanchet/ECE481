function [fig] = trackplot3(sim, exp, ms, fignum)
    
    tlt = sprintf('Tracking Plots for T_s = %0.f ms of %s vs. %s', ...
        ms, sim.txt, exp.txt);

    fig = figure(fignum);
    subplot(5,1,1)
    hold on

    %yref
    plot(sim.yref(:,1),sim.yref(:,2), '--','linewidth',1);
    plot(exp.t,exp.yref, 'linewidth', 1) ;
    hold off
    title(tlt);
    xlabel('');
    ylabel('y_{ref} [m]');
    set(gca,'xticklabel',{[]});
    legend(sim.txt, exp.txt); 

    %ThRef
    subplot(5,1,2)
    hold on
    plot(sim.ThRef(:,1),sim.ThRef(:,2),'--','linewidth',1);
    plot(exp.t,exp.ThRef,'linewidth',1);
    hold off
    title('');
    xlabel('');
    ylabel('\theta_{ref} [rad]');
    legend(sim.txt, exp.txt); 
    
    %Control Signal
    subplot(5,1,3)
    hold on
    plot(sim.u(:,1),sim.u(:,2),'--','linewidth',1);
    plot(exp.t,exp.u,'linewidth',1);
    hold off
    title('');
    xlabel('');
    ylabel('u [V]');
    legend(sim.txt, exp.txt); 

    % Gear Angle
    subplot(5,1,4)
    hold on
    plot(sim.ServoAng(:,1),sim.ServoAng(:,2),'--','linewidth',1);
    plot(exp.t, exp.ServoAng, 'linewidth',1);
    hold off
    title('');
    set(gca,'xticklabel',{[]});
    ylabel('ServoAng [rad]');
    legend(sim.txt, exp.txt); 
    
    
    % Ball Psn
    subplot(5,1,5)
    hold on
    plot(sim.BallPosn(:,1),sim.BallPosn(:,2),'--','linewidth',1);
    plot(exp.t, exp.BallPosn,'linewidth',1);
    hold off
    title('');
    set(gca,'xticklabel',{[]});
    xlabel('Time [sec]');
    ylabel('BallPosn [m]');
    legend(sim.txt, exp.txt); 
    
    ms = num2str(ms);
    plotstr=strcat('Plots\Tracking_',sim.txt,'_',exp.txt, '_', ms, 'ms');   
    plotstr=char(plotstr);
    print(fignum,'-djpeg',plotstr);

end

