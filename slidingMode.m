clear all; close all; clc                                                  %#ok<CLALL>

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

%designing linear control for reduced order system
run('reducedOrderSystem.m')

%K = place(A, B, [ -3; -5; -8 ]);
%wrong:
%K = [ -12.2200  8.0510  20.1040 ];
%K = [ -12.2200    8.1755   20.3620 ];

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

%rho including g_b in bound
%rho = (k*f_a + f_b)/g_b;

%rho not including g_b in bound
rho = k*f_a + f_b

g_b_inv = 1/g_b

%%

run('initPendulum.m')

%updating omega(x) with numerical values
rho = subs(rho);
s = subs(s);

rho = vpa(simplify(rho),2);
s = vpa(simplify(s),2);

%%
close all
deg_bound = 5;

angle_bound = 0.1; %  deg_bound*(2*pi)/100;
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

rho = -rho_neg

epsilon = 0.03

beta_0 = .1

beta = rho + beta_0

x_max

% sgn(s) ~ sat = min( 1, max(-1, (1/epsilon)*s))

% u = - (g_b^(-1))*beta0*sign(s)

% s = vpa(s,2)

%phi = -k*eta;
%s = xi + phi;



iter  = 250;
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
%rho_max    = (ia_max*k_tau/r - beta_0);
%theta_max  = theta_init(rho_bound>=rho_max-.1 & rho_bound<=rho_max+.1)
theta_max  = theta_init(i_a_bound>=-ia_max-.04 & i_a_bound<=-ia_max+.04)
rho_max    = (ia_max*k_tau/r - beta_0)/(l*(M + m - m*cos(theta_max)^2))/cos(theta_max)

%-----PLOTTING-------------------------------------------------------------

chooseRho_h = figure;
[AX, rho, ia] = plotyy( theta_init, rho_bound, theta_init, abs(i_a_bound) );
set(rho, 'LineWidth', 1.4 )
set(ia, 'LineWidth', 1.4 )

hold(AX(1));
hold(AX(2));

theta_span = theta_init(theta_init<=.25 & theta_init>=theta_max);
line_ia_max = ones(size(theta_span))*ia_max;
plot(AX(2), theta_span, line_ia_max, 'linestyle', ':', 'linewidth', 1.5, 'color', '[ .8 0 0 ]');

theta_span = theta_init(theta_init<=theta_max & theta_init>=0.02);
line_rho_max = ones(size(theta_span))*rho_max;
plot(AX(1), theta_span, line_rho_max, 'linestyle', ':', 'linewidth', 1.5, 'color', '[ 0 0 .8 ]');

plot(AX(2), [theta_max theta_max], [0 ia_max]);

limx = [ .02 0.15 ];

%setting options for radian axis
set(AX(1),...
    'Xgrid', 'on',...
    'Ygrid', 'on',...
    'XMinorGrid', 'on',...
    'YMinorGrid', 'off',...
    'ytick', (0:5:25),...
    'YLim', [ 0 25],...
    'XLim', limx,...
    'GridLineStyle',':',...
    'GridColor', 'k',...
    'GridAlpha', .6)

%turning off degree plot since it is now alligned with the radian plot
%set(ADC,'Visible','off')
 
%setting options for degree axis
set(AX(2),...
    'Xgrid', 'off',...
    'Ygrid', 'on',...
    'XMinorGrid', 'off',...
    'YMinorGrid', 'off',...
    'ytick', ( 0:1:7 ),...
    'YLim', [ 0 7 ],...
    'XLim', limx,...
    'GridLineStyle', ':',...
    'GridColor', 'k',...
    'GridAlpha', .6)

%adding axes labels
xlabel('$\theta_\mathbf{init}$ [rad]')
ylabel(AX(1), '$\varrho(\mathbf{\eta},\xi)$')
ylabel(AX(2), '$|i_{a,\mathrm{peak}}|$ [A]')

%adding legend
legend( [ rho, ia ], '$\varrho(\mathbf{\eta},\xi)$', '$|i_{a,\mathrm{peak}}|$', 'Location', 'southeast' )




%remember to float the windows before saving (for consistent scale)
if 0  
  figurePath1='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/reportCorrections/figures/Original/';                 %#ok<UNRCH>
  figurePath2='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/reportCorrections/figures/';
  fileTypeOrig="fig";
  
  for jj = 1:1
    switch jj
    case 1
      figHandle = chooseRho_h;
      fileName='chooseRho';
      saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2, 0);
    end
  end
end






