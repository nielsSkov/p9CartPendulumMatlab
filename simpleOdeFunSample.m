clear all; close all; clc                                                  %#ok<CLALL>
%tricking bspwm rule to tile the window as I want right now
pause(1.5)
figure

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

%set LaTeX as default interpreter
set( groot, 'defaultAxesTickLabelInterpreter',      'latex' );
set( groot, 'defaultLegendInterpreter',             'latex' );
set( groot, 'defaultTextInterpreter',               'latex' );
set( groot, 'defaultColorbarTickLabelInterpreter',  'latex' );
set( groot, 'defaultPolaraxesTickLabelInterpreter', 'latex' );
set( groot, 'defaultTextarrowshapeInterpreter',     'latex' );
set( groot, 'defaultTextboxshapeInterpreter',       'latex' );

m = 1;
g = 9.82;
l = 1;

theta_0          = pi/2;
theta_dot_0      = 0;
theta_dot_dot_0  = -(m*g*l/(m*(l^2)))*sin(theta_0);

tspan = [ 0 10 ];
init  = [ theta_0 theta_dot_0 theta_dot_dot_0 ];

[t, q] = ode45(@simSimpleOdeFun, tspan, init);

theta         = q(:,1);
theta_dot     = q(:,2);
theta_dot_dot = q(:,3);

%simulink model of same system for comparrison
sim('simplePendulumSample')

%comparring simulink and ode45
close all
figure
subplot(3,1,1), plot(t,theta, 'linewidth', 1.5)
hold on
subplot(3,1,1), plot(theta_sl.time,theta_sl.data, '.', 'markersize', 8)
grid on, grid minor
title('$\theta$')

subplot(3,1,2), plot(t,theta_dot, 'linewidth', 1.5)
hold on
subplot(3,1,2), plot(theta_d_sl.time,theta_d_sl.data, '.', 'markersize', 8)
grid on, grid minor
title('$\dot{\theta}$')

subplot(3,1,3), plot(t,theta_dot_dot, 'linewidth', 1.5)
hold on
subplot(3,1,3), plot(theta_d_d_sl.time,theta_d_d_sl.data, '.', 'markersize', 8)
grid on, grid minor
title('$\ddot{\theta}$')