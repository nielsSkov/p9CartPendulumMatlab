clear all; close all; clc                                                  %#ok<CLALL>

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

run('latexDefaults.m')

run('initPendulum.m')

%initial conditions for ode45
theta_0          = 0.203;
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
                           b_p_c, b_p_v, b_c_c, b_c_v ),      ...
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
                                           b_p_c, b_p_v, b_c_c, b_c_v    );
end

%-----plotting results of simulation using ode45---------------------------

subplot(4,2,1), plot(t, x, 'linewidth', 1.5)
hold on
title('$x$')
grid on, grid minor

subplot(4,2,2), plot(t, theta, 'linewidth', 1.5)
hold on
grid on, grid minor
title('$\theta$')

subplot(4,2,3), plot(t, x_dot, 'linewidth', 1.5)
hold on
grid on, grid minor
title('$\dot{x}$')

subplot(4,2,4), plot(t, theta_dot, 'linewidth', 1.5)
hold on
grid on, grid minor
title('$\dot{\theta}$')

subplot(4,2,5), plot(t, x_dot_dot, 'linewidth', 1.5)
hold on
grid on, grid minor
title('$\ddot{x}$')

subplot(4,2,6), plot(t, theta_dot_dot, 'linewidth', 1.5)
hold on
grid on, grid minor
title('$\ddot{\theta}$')

subplot(4,2,7:8), plot(t, i_a, 'linewidth', 1.5)
hold on
grid on, grid minor
title('$\i_a$')

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



