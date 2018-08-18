clear all; close all; clc                                                  %#ok<CLALL>

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

run('latexDefaults.m')

%----------data import and crop for test1----------------------------------

%data = csvread('test1slidingModeANDmodelTest.csv',474,0); %read from reset

%-----data from sliding mode test-----
% x2_est = data(1741:13670,1);      %                     x_est_correction[0]
% x1_est = data(1741:13670,2);      %                     x_est_correction[1]
% x4_est = data(1741:13670,3);      %                     x_est_correction[2]
% x3_est = data(1741:13670,4);      %                     x_est_correction[3]
% 
% x2     = data(1741:13670,5);      %                      posSled
% x1     = data(1741:13670,6);      %                      posPend1
% t      = data(1741:13670,7)./1e6; %  micro sec -> [ s ]  time_stamp
% i_a1   = data(1741:13670,8);    %amature current  [ A ]  setOutSledNoComp
% i_a2   = data(1741:13670,9);    %amature current  [ A ]  setOutSled
% 
% %-----data from swing test------------
% x2_2   = data(13770:end,1);       %                       posSled
% x1_2   = data(13770:end,2);       %                       posPend1
% t_2    = data(13770:end,3)./1e6;  %  micro sec -> [ s ]   time_stamp
%i_a1_2   = data(13770:end,4);  %amature current  [ A ]   setOutSledNoComp
%i_a2_2   = data(13770:end,5);  %amature current  [ A ]   setOutSled

%cropping end of data
% x2_est = x2_est(1:13767,1);
% x1_est = x1_est(1:13767,1);
% x4_est = x4_est(1:13767,1);
% x3_est = x3_est(1:13767,1);
% x2     = x2(1:13767,1);
% x1     = x1(1:13767,1);
% t2     = t(1:13767,1);
% i_a2   = i_a2(1:13767,1);

%----------data import and crop for test2----------------------------------

data = csvread('slidingModeTest2.csv',0,0);

%-----data from sliding mode test-----
x2_est = data(:,1);      %  x_est_correction[0]
x1_est = data(:,2);      %  x_est_correction[1]
x4_est = data(:,3);      %  x_est_correction[2]
x3_est = data(:,4);      %  x_est_correction[3]

x2     = data(:,5);      %                        posSled
x1     = data(:,6);      %                        posPend1
t      = data(:,7)./1e6-85; %    micro sec -> [ s ]  time_stamp
i_a1   = data(:,8);      %amature current  [ A ]  setOutSledNoComp
i_a2   = data(:,9);      %amature current  [ A ]  setOutSled

%----------plotting--------------------------------------------------------

slidingModeTest2theta_h =figure;
subplot(2,1,1), plot(t, x1_est, 'linewidth', 1.2, 'color', [ 0 0 1 ])
xlim([ 0 25 ])
ylim([ -.1 .1 ])
grid on, grid minor
xlabel('$t$ [s]')
ylabel('$\theta$ [rad]')

subplot(2,1,2), plot(t, x3_est, 'linewidth', 1.2, 'color', [ 0 0 1 ])
xlim([ 0 25 ])
ylim([ -2 2 ])
grid on, grid minor
xlabel('$t$ [s]')
ylabel('$\dot{\theta}$ [rad$\cdot$ s$^{-1}$]')

slidingModeTest2x_h = figure;
subplot(2,1,1), plot(t, x2_est, 'linewidth', 1.2, 'color', [ 0 0 1 ])
xlim([ 0 25 ])
ylim([ -.3 .3 ])
grid on, grid minor
xlabel('$t$ [s]')
ylabel('$x$ [m]')

subplot(2,1,2), plot(t, x4_est, 'linewidth', 1.2, 'color', [ 0 0 1 ])
xlim([ 0 25 ])
grid on, grid minor
xlabel('$t$ [s]')
ylabel('$\dot{x}$ [m$\cdot$ s$^{-1}$]')

slidingModeTest2ia_h = figure;
plot(t, i_a1, 'linewidth', 1.2, 'color', [ 0 0 1 ])
xlim([ 0 25 ])
ylim([ -5 5 ])
yticklabels({'','-4','','-2','','0','','2','','4',''})
grid on, grid minor
xlabel('$t$ [s]')
ylabel('$i_a$ [rad]')

%----------save and crop figures-------------------------------------------

%remember to float the windows before saving (for consistent scale)
if 0  
  figurePath1='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/Presentation/figures/Original/';                 %#ok<UNRCH>
  figurePath2='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/Presentation/figures/';
  fileTypeOrig="fig";

  for jj = 1:3
    switch jj
    case 1
      figHandle = slidingModeTest2theta_h;
      fileName='slidingModeTest2theta';
      saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,0);
      case 2
      figHandle = slidingModeTest2x_h;
      fileName='slidingModeTest2x';
      saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,0);
      case 3
      figHandle = slidingModeTest2ia_h;
      fileName='slidingModeTest2ia';
      saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,0);
    end
  end
end