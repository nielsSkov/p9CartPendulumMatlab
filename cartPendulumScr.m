clear all; close all; clc                                                  %#ok<CLALL>

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

run('latexDefaults.m')

run('initPendulum.m')

%initial conditions for ode45
theta_0          = 0.05;
x_0              = 0;
theta_dot_0      = 0;
x_dot_0          = 0;

%visualize initial values
% clear all; close all; clc;
% alpha = pi/2; x2=0+(cos(alpha));
% y2=0+(sin(alpha));
% plot([0 x2],[0 y2]);
% hold on; clear all;
% alpha = pi/2+.77; x2=0+(cos(alpha));
% y2=0+(sin(alpha));
% plot([0 x2],[0 y2]);
% axis equal

%----CONTROLLER CHOISE-----------------------------------------------------
%control off
con = -1;
%sliding mode controller on
%con = 0;
%trajectory1 on
%con = 1;
%trajectory2 on
%con = 2;
%trajectory3 on
%con = 3;
%all trajectories on
%con = 4;
%--------------------------------------------------------------------------

%sample time and final time [s]
Ts = .01;
T_final = 10;

%initialization for ode45
tspan = 0:Ts:T_final;
init  = [ theta_0 x_0 theta_dot_0 x_dot_0 ];

%lowering relative tollerence (default 1e-3) to avoid drifting along x
options = odeset('RelTol',1e-7);

%simulating system using ode45
[t, q] = ode45( @(t,q)                                        ...
                simOdeFun( t,q, m, M, l, g, k_tan, r, k_tau,  ...
                           b_p_c, b_p_v, b_c_c, b_c_v, con ),      ...
                tspan, init, options                          );

%assigning results of ode45 simulation
theta         = q(:,1);
x             = q(:,2);
theta_dot     = q(:,3);
x_dot         = q(:,4);

%initializing 2nd derivatives and amature current
theta_dot_dot = zeros(size(t));
x_dot_dot     = zeros(size(t));
i_a           = zeros(size(t));

%calculating/simulating 2nd derivatives
for i = 1:length(t)
  [ ~, theta_dot_dot(i), ...
       x_dot_dot(i),     ...
       i_a(i) ] = simOdeFun( t(i), q(i,:), m, M, l, g, k_tan, r, k_tau, ...
                                           b_p_c, b_p_v, b_c_c, b_c_v, con );
end

%-----plotting results of simulation using ode45---------------------------

slidingModeSIMtheta_h = figure;
subplot(3,1,1), plot(t, theta, 'linewidth', 1.5)
%xlim([ 0 10 ])
%ylim([ -.1 .1 ])
grid on, grid minor
xlabel('$t$ [s]')
ylabel('$\theta$ [rad]')

subplot(3,1,2), plot(t, theta_dot, 'linewidth', 1.5)
%xlim([ 0 10 ])
%ylim([ -2 2 ])
grid on, grid minor
xlabel('$t$ [s]')
ylabel('$\dot{\theta}$ [rad$\cdot$ s$^{-1}$]')

subplot(3,1,3), plot(t, theta_dot_dot, 'linewidth', 1.5)
%xlim([ 0 10 ])
%ylim([ -2 2 ])
grid on, grid minor
xlabel('$t$ [s]')
ylabel('$\ddot{\theta}$ [rad$\cdot$ s$^{-2}$]')


slidingModeSIMx_h = figure;
subplot(3,1,1), plot(t, x, 'linewidth', 1.5)
%xlim([ 0 10 ])
%ylim([ -.3 .3 ])
grid on, grid minor
xlabel('$t$ [s]')
ylabel('$x$ [m]')

subplot(3,1,2), plot(t, x_dot, 'linewidth', 1.5)
%xlim([ 0 10 ])
grid on, grid minor
xlabel('$t$ [s]')
ylabel('$\dot{x}$ [m$\cdot$ s$^{-1}$]')

subplot(3,1,3), plot(t, x_dot_dot, 'linewidth', 1.5)
%xlim([ 0 25 ])
grid on, grid minor
xlabel('$t$ [s]')
ylabel('$\ddot{x}$ [m$\cdot$ s$^{-2}$]')


slidingModeSIMia_h = figure;
plot(t, i_a, 'linewidth', 1.5)
%xlim([ 0 10 ])
%ylim([ -5 5 ])
%yticklabels({'','-4','','-2','','0','','2','','4',''})
grid on, grid minor
xlabel('$t$ [s]')
ylabel('$i_a$ [rad]')

if 0
%simulating using simulink
sim('cartPendulumModel.slx')

%assigning results of simulation using simulink
t_sl             = theta_sl.time;
theta_sl         = theta_sl.data;
x_sl             = x_sl.data;
theta_dot_sl     = theta_dot_sl.data;
x_dot_sl         = x_dot_sl.data;
theta_dot_dot_sl = theta_dot_dot_sl.data;
x_dot_dot_sl     = x_dot_dot_sl.data;

%-----adding simulink results to plots for comparrison---------------------

subplot(3,2,1), plot(t_sl, x_sl,             '.', 'markersize', 5)
subplot(3,2,2), plot(t_sl, theta_sl,         '.', 'markersize', 5)
subplot(3,2,3), plot(t_sl, x_dot_sl,         '.', 'markersize', 5)
subplot(3,2,4), plot(t_sl, theta_dot_sl,     '.', 'markersize', 5)
subplot(3,2,5), plot(t_sl, x_dot_dot_sl,     '.', 'markersize', 5)
subplot(3,2,6), plot(t_sl, theta_dot_dot_sl, '.', 'markersize', 5)
end

if 0  
  figurePath1='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/Presentation/figures/Original/';                 %#ok<UNRCH>
  figurePath2='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/Presentation/figures/';
  fileTypeOrig="fig";

  for jj = 1:3
    switch jj
    case 1
      figHandle = slidingModeSIMtheta_h;
      fileName='slidingModeSIMtheta';
      saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,0);
      case 2
      figHandle = slidingModeSIMx_h;
      fileName='slidingModeSIMx';
      saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,0);
      case 3
      figHandle = slidingModeSIMia_h;
      fileName='slidingModeSIMia';
      saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,0);
    end
  end
end

