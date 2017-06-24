function [fig] = trackplot(ref1, u1, y1, txt1, ref2, u2, y2, txt2, ms, fignum)
    
    tlt = sprintf('Tracking Plots for T_s = %0.f ms of %s vs. %s', ms, txt1, txt2);

    fig = figure(fignum);
    subplot(3,1,1)
    hold on

    %ref
    plot(ref1(:,1),ref1(:,2),'--','linewidth',1);
    plot(ref2(:,1),ref2(:,2),'linewidth',1);
    hold off
    title(tlt);
    xlabel('');
    ylabel('\theta_{ref} [rad]');
    set(gca,'xticklabel',{[]});
    legend(txt1, txt2); 

    %Control Signal
    subplot(3,1,2)
    hold on
    plot(u1(:,1),u1(:,2),'--','linewidth',1);
    plot(u2(:,1),u2(:,2),'linewidth',1);
    hold off
    title('');
    xlabel('');
    ylabel('u [V]');
    legend(txt1, txt2);

    % Gear Angle
    subplot(3,1,3)
    hold on
    plot(y1(:,1),y1(:,2),'--','linewidth',1);
    plot(y2(:,1),y2(:,2),'linewidth',1);
    hold off
    title('');
    set(gca,'xticklabel',{[]});
    xlabel('Time [sec]');
    ylabel('ServoAng [rad]');
    legend(txt1, txt2);
    
    ms = num2str(ms);
    plotstr=strcat('Plots\Tracking_',txt1,'_',txt2, '_', ms, 'ms');   
    plotstr=char(plotstr);
    print(fignum,'-djpeg',plotstr);

end

