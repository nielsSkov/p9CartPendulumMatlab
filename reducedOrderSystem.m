clear all; close all; clc                                                  %#ok<CLALL>

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

run('latexDefaults.m')

%run('initPendulum.m')

syms x1 x2 x3 x4 u
syms k_tan b_p_v b_p_c b_c_v b_c_c
syms a c d e;


%state vector,
% [ x1 ]    [ theta       ]
% [ x2 ]  = [  x          ]
% [ x3 ]    [  theta_dot  ]
% [ x4 ]    [  x_dot      ]

MM = [  a             -c*cos(x1)  ;
       -c*cos(x1)      d         ];

C = [ 0               ;
      c*sin(x1)*x4^2 ];

G = [ -e*sin(x1)  ;
       0         ];

B = [ b_p_c*tanh(k_tan*x4) + b_p_v*x3  ;
      b_c_c*tanh(k_tan*x3) + b_c_v*x4 ];

%----full nonliner system--------------------------------------------------

f_x = [ x3                 ;
        x4                 ;
        MM\(- G - C - B ) ];

g_x = [ 0                                    ;
        0                                    ;
        c*cos(x1)/( a*d-(c^2)*(cos(x1)^2) )  ;
        a/( a*d-(c^2)*(cos(x1)^2) )         ];

x_dot = f_x + g_x*u;

%-----on regular form------------------------------------------------------

f_a = [ x4                                          ;
        a*f_x(3) + c*sin(x1)*x3 - c*cos(x1)*f_x(4)  ;
        x3                                         ];

f_b = f_x(3);

g_b = c*cos(x1)/( a*d-(c^2)*(cos(x1)^2) );

%regular form
eta_dot = f_a;
xi_dot  = f_b + g_b*u;

%------regular form with change of cooredinates----------------------------

syms eta1 eta2 eta3 xi
%x1 = eta3;
%x2 = eta1;
%x3 = xi;
%x4 = ( a*xi - eta2 )/( c*cos(eta3) );

etaXi = { eta3, eta1, xi, ( a*xi - eta2 )/( c*cos(eta3) ) };

eta_dot = subs(eta_dot, { x1, x2, x3, x4 }, etaXi );
eta_dot = simplify(eta_dot)

xi_dot  = subs(xi_dot,  { x1, x2, x3, x4 }, etaXi );

%-----symbolic linearization-----------------------------------------------

syms m M l g

eta = [ eta1 
        eta2 
        eta3];

J_eta = jacobian(eta_dot, eta);

A = subs( J_eta, { eta1, eta2, eta3, xi, k_tan }, { 0, 0, 0, 0, 1 } );

A = simplify(A);

A = subs( A, { a, c, d, e}, { m*(l^2), m*l, M+m, m*g*l } );

A = simplify(A);

J_xi = jacobian(eta_dot, xi);

B = subs( J_xi, { eta1, eta2, eta3, xi, k_tan }, { 0, 0, 0, 0, 1 } );

B = simplify(B);

B = subs( B, { a, c, d, e}, { m*(l^2), m*l, M+m, m*g*l } );

B = simplify(B);

%-----designing linear state feedback controller---------------------------

run('initPendulum.m')

A = [ 0     -1/c    0  ;
      0  b_p_c/c    e  ;
      0        0    0 ];

B = [  a/c
      -(a*b_p_c + b_p_v*c)/c
       1                     ];

C = [ 1 1 1 ];

D = [ 0 ];

linSys = ss(A,B,C,D);

%setting nr of iterations ( >1 to tune pole placement     )
iter = 10;     %          ( <1 to compare with linear sim )

leg = char({'.......................'});

for i = 2:iter+1
  %control gain
  if iter > 1
    poles = [ -i*.5; -i*.75; -i*1.25 ];
    k = place(A, B, poles);
  else
    k = placa(A, B, [ -5; -6; -7 ]);
  end

  %-----simulation of reduced state system, eta_dot, using ode45-----------

  %initial conditions for ode45
  eta1_0 = 1;
  eta2_0 = 1;
  eta3_0 = 0;

  %sample time and final time [s]
  Ts = .01;
  T_final = 10;

  %initialization for ode45
  tspan = 0:Ts:T_final;
  init  = [ eta1_0 eta2_0 eta3_0 ];

  %lowering relative tollerence (default 1e-3) to avoid drifting along x
  options = odeset('RelTol',1e-7);

  %simulating system using ode45
  [t, eta] = ode45( @(t,eta)                                            ...
                    simReducedOrderSystemOdeFun( t, eta, k, a, c, d,    ...
                                                 e, k_tan,              ...
                                                 b_p_c, b_p_v,          ...
                                                 b_c_c, b_c_v       ),  ...
                                                 tspan, init, options    );

  %assigning results of ode45 simulation
  eta1 = eta(:,1);
  eta2 = eta(:,2);
  eta3 = eta(:,3);


  %linear system simulation for comparison
  sys_cl = ss(A-B*k,B,C,D);

  u = zeros(size(tspan));

  [ yy, tt, eta_lin ] = lsim(sys_cl,u,tspan,init);

  %linear simulation resolution
  res = 10; %plotting every 10th data-point

  eta1_lin = eta_lin(1:res:end,1);
  eta2_lin = eta_lin(1:res:end,2);
  eta3_lin = eta_lin(1:res:end,3);
  tt = tt(1:res:end);

  %marker size for linear simulation
  markerZ = 10;
  
  %generating legends for iterations >1
  str=sprintf('[ \\ %.2f \\ \\ %.2f \\ \\ %.2f \\ ]',...
                 poles(1),  poles(2),  poles(3));
  leg(i,1:length(str))=str;
  
  %plotting results
  subplot(3,1,1), plot(t, eta1, 'linewidth', 1.5)
  hold on
  title('$\eta_1$')
  if iter == 1
    subplot(3,1,1), plot(tt, eta1_lin, '.', 'markersize', markerZ)
  end
  if i == 11
    legend( leg(2,:), leg(3,:), leg(4,:), leg(5,:), leg(6,:),  ...
            leg(7,:), leg(8,:), leg(9,:), leg(10,:), leg(11,:) )
    xlim([0 2])
  end
  grid on, grid minor

  subplot(3,1,2), plot(t, eta2, 'linewidth', 1.5)
  hold on
  title('$\eta_2$')
  if iter == 1
    subplot(3,1,2), plot(tt, eta2_lin, '.', 'markersize', markerZ)
  end
  if i == 11
    legend( leg(2,:), leg(3,:), leg(4,:), leg(5,:), leg(6,:),  ...
            leg(7,:), leg(8,:), leg(9,:), leg(10,:), leg(11,:) )
    xlim([0 2])
  end
  grid on, grid minor

  subplot(3,1,3), plot(t, eta3, 'linewidth', 1.5)
  hold on
  title('$\eta_3$')
  if iter == 1
    subplot(3,1,3), plot(tt, eta3_lin, '.', 'markersize', markerZ)
  end
  if i == 11
    legend( leg(2,:), leg(3,:), leg(4,:), leg(5,:), leg(6,:),  ...
            leg(7,:), leg(8,:), leg(9,:), leg(10,:), leg(11,:) )
    xlim([0 2])
  end
  grid on, grid minor
end












