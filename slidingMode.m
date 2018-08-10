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

run('initPendulum.m')

k1 = K(1);
k2 = K(2);
k3 = K(3);

%updating omega(x) with numerical values
rho = subs(rho);

rho = vpa(simplify(rho),2)

%%

bound = pi/2;

x0   = [  0       0       0       0     ];
x_lo = [ -bound, -bound, -bound, -bound ];
x_up = [  bound,  bound,  bound,  bound ];

Aieq = [];
bieq = [];
Aeq  = [];
beq  = [];

[ x_max, rho_neg ] = fmincon( @maximizeRho, ...
                               x0, Aieq, bieq, Aeq, beq, x_lo, x_up );

rho = -rho_neg;

epsilon = 0.03

beta_0 = 2

beta = rho + beta_0

% sgn(s) ~ sat = min( 1, max(-1, (1/epsilon)*s))

% u = - (g_b^(-1))*beta0*sign(s)

s = vpa(s,2)

%phi = -k*eta;
%s = xi + phi;




