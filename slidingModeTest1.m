clear all; close all; clc                                                  %#ok<CLALL>

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

run('latexDefaults.m')

%----------data import and crop--------------------------------------------

data = csvread('test1slidingModeANDmodelTest.csv',474,0); %read from reset

%-----data from sliding mode test-----
x2_est = data(1741:13670,1);      %                     x_est_correction[0]
x1_est = data(1741:13670,2);      %                     x_est_correction[1]
x4_est = data(1741:13670,3);      %                     x_est_correction[2]
x3_est = data(1741:13670,4);      %                     x_est_correction[3]

x2     = data(1741:13670,5);      %                      posSled
x1     = data(1741:13670,6);      %                      posPend1
t      = data(1741:13670,7)./1e6; %  micro sec -> [ s ]  time_stamp
i_a1   = data(1741:13670,8);    %amature current  [ A ]  setOutSledNoComp
i_a2   = data(1741:13670,9);    %amature current  [ A ]  setOutSled

%-----data from swing test------------
x2_2   = data(13770:end,1);       %                       posSled
x1_2   = data(13770:end,2);       %                       posPend1
t_2    = data(13770:end,3)./1e6;  %  micro sec -> [ s ]   time_stamp
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

%----------plotting--------------------------------------------------------

%creating 1st figure
%slidingModeTest1_h = figure;

%plotting

figure
plot(t, x1_est, 'linewidth', 1.2, 'color', [ 0 0 1 ])
hold on
plot(t, x1, 'linewidth', 1.2, 'color', [ 1 0 0 ])
title('$x1_est$ and x1')
figure
plot(t, x2_est, 'linewidth', 1.2, 'color', [ 0 0 1 ])
title('$x2_est$ and x2')
hold on
plot(t, x2, 'linewidth', 1.2, 'color', [ 1 0 0 ])
figure
plot(t, x3_est, 'linewidth', 1.2, 'color', [ 0 0 1 ])
title('$x3_est$')
figure
plot(t, x4_est, 'linewidth', 1.2, 'color', [ 0 0 1 ])
title('$x4_est$')

figure
plot(t, i_a1, 'linewidth', 1.2, 'color', [ 0 0 1 ])
hold on
plot(t, i_a2, 'linewidth', 1.2, 'color', [ 1 0 0 ])
title('$i_a1$ and $i_a2$')



figure
plot(t_2, x1_2, 'linewidth', 1.2, 'color', [ 0 0 1 ])
title('$x1_2$')
figure
plot(t_2, x2_2, 'linewidth', 1.2, 'color', [ 0 0 1 ])
title('$x2_2$')



%xlim([  ])

%plot settings
% grid on, grid minor
% xlabel('$t$ [s]')
% ylabel('$\theta$ [rad]')
% legend( 'Measured', 'location', 'southeast')














%----------save and crop figures-------------------------------------------

%remember to float the windows before saving (for consistent scale)
if 0  
  figurePath1='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/figures/Original/';                 %#ok<UNRCH>
  figurePath2='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/figures/';
  fileTypeOrig="fig";

  for jj = 1:1
    switch jj
    case 1
      figHandle = slidingModeTest1_h;
      fileName='slidingModeTest1';
      saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,0);
      case 2
      figHandle = h;
      fileName='';
      saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,0);
    end
  end
end