clear all; close all; clc                                                  %#ok<CLALL>

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

%designing linear control for reduced order system
run('reducedOrderSystem.m')

%K = place(A, B, [ -3; -5; -8 ]);
K = [ -12.2200  8.0510  20.1040 ];

syms k1 k2 k3 u
syms eta1 eta2 eta3 xi

k = [ k1 k2 k3 ];
      
eta = [ eta1  ;
        eta2  ;
        eta3 ];

phi = -k*eta;

s = xi - phi;

%previous attempt with reduced notation
%s = subs( s, { eta1, eta2, eta3, xi }, { x2, a*x3-c*cos(x1)*x4, x1, x3 } )

s = subs( s, { eta1, eta2, eta3, xi }, { x2, l*x3-cos(x1)*x4, x1, x3 } )


%changing to states (x1,...,x4) as cooredinates
eta_dot = f_a;
xi_dot = f_b + g_b*u;

% s_dot = xi_dot + k*eta_dot;

rho = (k*f_a + f_b)/g_b;

%%

run('initPendulum.m')

k1 = K(1);
k2 = K(2);
k3 = K(3);

%updating omega(x) with numerical values
rho = subs(rho);

rho = vpa(simplify(rho),2)

%%
close all
deg_bound = 5;

angle_bound = 0.06; %  deg_bound*(2*pi)/100;
aVel_bound  = 0;
x_bound     = 0;
xVel_bound  = 0;

x0   = [  0       0       0       0     ];
x_lo = [ -angle_bound, -x_bound, -aVel_bound, -xVel_bound ];
x_up = [  angle_bound,  x_bound,  aVel_bound,  xVel_bound ];

Aieq = [];
bieq = [];
Aeq  = [];
beq  = [];

%[X,FVAL,EXITFLAG,OUTPUT,LAMBDA]
[ x_max, rho_neg ] = fmincon( @maximizeRho, ...
                               x0, Aieq, bieq, Aeq, beq, x_lo, x_up );

rho = -rho_neg;

epsilon = 0.03

beta_0 = 2

beta = rho + beta_0

x_max

% sgn(s) ~ sat = min( 1, max(-1, (1/epsilon)*s))

% u = - (g_b^(-1))*beta0*sign(s)

s = vpa(s,2)

%phi = -k*eta;
%s = xi + phi;



iter  = 100;
res   = 0.001;
start = 0.01;

rho_bound = zeros(iter,1);
i_a_bound = zeros(iter,1);

theta_init = ( start+res : res : iter*res+start )';

for i = 1:iter
  
  x_init = [ theta_init(i) 0 0 0 ];

  [ rho_bound(i), i_a_bound(i) ] = rhoIa( x_init, epsilon, beta_0, K, k_tau, r );

end

ia_max     = 4.58; % [A]
rho_max    = ia_max*k_tau/r - beta_0
theta_max  = theta_init(rho_bound>=rho_max-.1 & rho_bound<=rho_max+.1)

figure;
[AX, rho, ia] = plotyy( theta_init, rho_bound, theta_init, abs(i_a_bound) );
set(rho, 'LineWidth', 1.4 )
set(ia, 'LineWidth', 1.4 )

hold(AX(1));
hold(AX(2));

theta_span = theta_init(theta_init<=.1 & theta_init>=theta_max);
line_ia_max = ones(size(theta_span))*ia_max;
plot(AX(2), theta_span, line_ia_max, 'linestyle', ':', 'linewidth', 1.5, 'color', '[ .8 0 0 ]');

theta_span = theta_init(theta_init<=theta_max & theta_init>=0.02);
line_rho_max = ones(size(theta_span))*rho_max;
plot(AX(1), theta_span, line_rho_max, 'linestyle', ':', 'linewidth', 1.5, 'color', '[ 0 0 .8 ]');

plot(AX(2), [theta_max theta_max], [0 ia_max]);

%setting options for radian axis
set(AX(1),...
    'Xgrid', 'on',...
    'Ygrid', 'on',...
    'XMinorGrid', 'on',...
    'YMinorGrid', 'on',...
    'ytick', (0:5:25),...
    'YLim', [ 0 25],...
    'XLim', [ .02 .1 ],...
    'GridLineStyle',':',...
    'GridColor', 'k',...
    'GridAlpha', .6)

%turning off degree plot since it is now alligned with the radian plot
%set(ADC,'Visible','off')
 
%setting options for degree axis
set(AX(2),...
    'Xgrid', 'off',...
    'Ygrid', 'off',...
    'XMinorGrid', 'off',...
    'YMinorGrid', 'off',...
    'ytick', ( 0:1:7 ),...
    'YLim', [ 0 7 ],...
    'XLim', [ .02 .1 ],...
    'GridLineStyle', ':',...
    'GridColor', 'k',...
    'GridAlpha', .6)

%adding axes labels
xlabel('$\theta_{init}$')
ylabel(AX(1), '$|\varrho(\mathbf{\eta},\xi)|$')
ylabel(AX(2), '$|i_{a,max}|$')

%adding legend
legend('$|\varrho(\mathbf{\eta},\xi)|$', '$|i_{a,max}|$', 'Location', 'southeast' )


% 
% b = figure;
% [AX, rad1, deg1] = plotyy(time,rad,time,deg);
% 
% hold on;%------------ PLOTTING REFFERENCE LINES ---------------------------
% 
% YminRad = (Ymin - equVolt) * resRadVolt;
% plot(AX(1), time, YminRad,...
% 'linestyle', '--', 'linewidth', 1.2, 'color', '[ .2 .2 .2 ]');
% 
% YmaxRad = (Ymax - equVolt) * resRadVolt;
% plot(AX(1), time, YmaxRad,...
% 'linestyle', '--', 'linewidth', 1.2, 'color', 'r');
% 
% YequRad = (Yequ - equVolt) * resRadVolt;
% plot(AX(1), time, YequRad,...
% 'linestyle', '--', 'linewidth', 1.2, 'color', '[ 0 .6 0 ]');
% 
% YmiddleRad = (Ymiddle - equVolt) * resRadVolt;
% plot(AX(1), time, YmiddleRad,...
% 'linestyle', '--', 'linewidth', 1.2, 'color', '[ .6 0 .6 ]');
% 
% hold off;%-----------------------------------------------------------------
% 
% %% ----------------------- PLOT SETTINGS ----------------------------------
% 
% set(rad1,'LineWidth', 1.4 )
% 
% %setting options for radian axis
% set(AX(1),...
%     'Xgrid', 'on',...
%     'Ygrid', 'on',...
%     'XMinorGrid', 'on',...
%     'YMinorGrid', 'on',...
%     'ytick', (-.9:.1:.9),...
%     'YLim', [ -.785395694 .95992832 ],...     <-- Crummy allignment of
%     'XLim', [ 0  5 ],...                          the two graphs, by
%     'GridLineStyle',':',...                       moving the radian graph
%     'GridColor', 'k',...
%     'GridAlpha', .6)
% 
% %turning off degree plot since it is now alligned with the radian plot
% set(deg1,'Visible','off')
% 
% %setting options for degree axis
% set(AX(2),...
%     'Xgrid', 'off',...
%     'Ygrid', 'off',...
%     'XMinorGrid', 'off',...
%     'YMinorGrid', 'off',...
%     'ytick', (-50:5:50),...
%     'YLim', [ -45 55 ],...
%     'XLim', [ 0  5 ],...
%     'GridLineStyle', ':',...
%     'GridColor', 'k',...
%     'GridAlpha', .6)
% 
% %adding title and axes labels
% title('Angle Range of Cubli')
% xlabel('Time (s)')
% ylabel(AX(1), 'Angular Position (rad)')
% ylabel(AX(2), 'Angular Position (^\circ)')
% 
% %adding legend
% legend('Angular movement',...
%        'Lower limmit',...
%        'Upper limmit',...
%        'Equlibrium point',...
%        'Mid-range',...
%        'Location', 'northwest' )

































