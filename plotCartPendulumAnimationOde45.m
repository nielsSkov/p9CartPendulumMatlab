clear all; close all; clc                                                  %#ok<CLALL>

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

run('latexDefaults.m')

run('initPendulum.m')

% m   = m*10;
% M   = M*10;
% l   = l*10;
% g   = 9.82;

%----------SIMULATION ODE45------------------------------------------------

%initial conditions for ode45
theta_0          = pi;
x_0              = 0;
theta_dot_0      = 0;
x_dot_0          = 0;

%sample time and final time [s]
Ts = .001;
T_final = 2;

%initialization for ode45
tspan = 0:Ts:T_final;
init  = [ theta_0 x_0 theta_dot_0 x_dot_0 ];

%lowering relative tollerence (default 1e-3) to avoid drifting along x
options = odeset('RelTol',1e-5);

con = 4; %select control in sim, first trajectory

[t, q] = ode45( @(t,q)                                        ...
                simOdeFun( t,q, m, M, l, g, k_tan, r, k_tau,  ...
                           b_p_c, b_p_v, b_c_c, b_c_v, con ), ...
                tspan, init, options                          );

%assigning results of ode45 simulation
theta         = q(:,1);
x             = q(:,2);
theta_dot     = q(:,3);
x_dot         = q(:,4);

%initializing 2nd derivatives and amature current
% theta_dot_dot = zeros(size(t));
% x_dot_dot     = zeros(size(t));
% i_a           = zeros(size(t));
% %calculating/simulating 2nd derivatives
% for i = 1:length(t)
%   [ ~, theta_dot_dot(i), ...
%        x_dot_dot(i),     ...
%        i_a(i) ] = simOdeFun( t(i), q(i,:), m, M, l, g, k_tan, r, k_tau, ...
%                                            b_p_c, b_p_v, b_c_c, b_c_v, con );
% end
% 
% plot(t, x_dot_dot, 'linewidth', 1.5)
% %xlim([ 0 25 ])
% grid on, grid minor
% xlabel('$t$ [s]')
% ylabel('$\ddot{x}$ [m$\cdot$ s$^{-2}$]')


% x  = x_c.data;
% xp = x_p.data;
% yp = y_p.data;
% t  = x_c.time;

%%

xp = x -l*sin(theta);
yp = l*cos(theta);

%Initializing Animation Figure
figure
grid on, grid minor
axis equal
axis([ -4 8 -2 2 ])
hold on

%Drawing obstacles
rectangle('Position',[ 2-.2  -4.12 .4 4 ], 'FaceColor', [ .5 .5 .5 ], 'EdgeColor', [.5 .5 .5]);
rectangle('Position',[ 2-.2  .27 .4 4 ], 'FaceColor', [ .5 .5 .5 ], 'EdgeColor', [.5 .5 .5]);

%Initializing Moving Objects and Trajectory
scatter(xp(1), yp(1), '.', 'b')
xpLast = xp(1);
ypLast = yp(1);
cart = rectangle('Position',[ x(1)-.15 0-.07 .3 .14 ]);
rod = plot( [ x(1) xp(1) ] , [ 0 yp(1) ], 'k', 'linewidth', 2);
drawnow

%--------------------------------------------------------------------------

t_old = 0;

%for testing timing
% t_test1 = zeros(length(t),1);
% t_test2 = zeros(length(t),1);

tic;

res = 1; % deviding resolution of simulation data with res

%Animation Loop
for i = 2:length(t)  /res
  
  i = i*res;

  delete(cart)
  cart = rectangle('Position',[ x(i)-.15 0-.07 .3 .14 ], 'FaceColor', [ .9 .9 .9 ]);

  delete(rod)
  rod = plot( [ x(i) xp(i) ] , [ 0 yp(i) ], 'k', 'linewidth', 2 );

  if sqrt( (xpLast-xp(i))^2 + (ypLast-yp(i))^2 ) >= .1 %<-setting distance
    %scatter(xp(i),yp(i), '.', 'b')                     %  resolution between
    %plot([xp(i-1); xp(i)], [yp(i-1); yp(i)])
    plot(xp(i),yp(i), '.', 'color', 'b')
    xpLast = xp(i);                                   %  points on the
    ypLast = yp(i);                                   %  trajectory
  end  

  runT = toc;
  
  %for testing timing
  % t_test1(i/res) = t(i);
  % t_test2(i/res) = runT;

  if runT < t(i)
    pauses(t(i)-runT)
  end

  drawnow
end

%for testing timing
% figure;
% plot(t_test1(1:round(i/res)))
% hold on
% plot(t_test2(1:round(i/res)))



