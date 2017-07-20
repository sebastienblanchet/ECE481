clear; close all; clc;

% Import experimental data
nostic.data = xlsread('N:\GitHub\ECE481\Lab3\Data\170720_3f_nostic.xlsx');
nostic.t = nostic.data(:,1);
nostic.yref = nostic.data(:,2);
nostic.ServoAng = nostic.data(:,3);
nostic.BallPosn = nostic.data(:,4);
nostic.u = nostic.data(:,5);
nostic.ThRef = nostic.data(:,6);
nostic.txt = 'No Stiction';

stic.data = xlsread('N:\GitHub\ECE481\Lab3\Data\170720_3f.xlsx');
stic.t = stic.data(:,1);
stic.yref = stic.data(:,2);
stic.ServoAng = stic.data(:,3);
stic.BallPosn = stic.data(:,4);
stic.u = stic.data(:,5);
stic.ThRef = stic.data(:,6);
stic.txt = 'Stiction';

% Tracking plot
trackplot3(stic, nostic, 1, 2);
