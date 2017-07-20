function [Re, Im, thetadeg] = zone(OS, t_set )

    thetarad = atan((-1/pi)*log(OS/100));
    thetadeg = thetarad*180/pi;
    Re = 4/t_set;
    Im = (4/t_set)./ tan(thetarad);

end

