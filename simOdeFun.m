function [ q_dot, theta_dot_dot, x_dot_dot ] = simOdeFun( t, q, m, M,   ...
                                                          l, g, k_tan,  ...
                                                          b_p_c, b_p_v, ...
                                                          b_c_c, b_c_v  )
  theta         = q(1);
  x             = q(2);
  theta_dot     = q(3);
  x_dot         = q(4);
  
  x1 = theta;
  x2 = x;
  x3 = theta_dot;
  x4 = x_dot;
  
  a = m*(l^2);
  c = m*l;
  d = M+m;
  e = m*g*l;
  
  %controller
  epsilon = 0.03;
  beta_0 = 2;
  %rho = 337930000;
  rho = 8;
  beta = rho + beta_0;
  k = [ -12.2200  8.0510  20.1040 ];
  s = x3 + k(1)*x2 + k(2)*(0.33*x3 - 1.0*x4*cos(x1)) + k(3)*x1;
  u = -min( 1, max(-1, (1/epsilon)*s))*beta;
  
%   
%   
%   
%   beta0 = 10;
%   
%   g_b_inv = (a*d - c^2*cos(x1)^2)/(c*cos(x1));
%   
%   (m*(l^2)*(M+m) - (m*l)^2*cos(x1)^2)/((m*l)*cos(x1));
%   
%   k = [ -12.2200  5.7241  20.1040 ];
%   
%   s = x3 - 1.0*k(1)*x2 - 1.0*k(3)*x1 - 1.0*k(2)*(0.47*x3 - 1.4*x4*cos(x1));
%   
%   epsilon = 0.03;
% 
%   u = -g_b_inv*beta0*min( 1, max(-1, (1/epsilon)*s));
  
  MM = [  m*(l^2)          -m*l*cos(theta)  ;
         -m*l*cos(theta)    M+m            ];

  G = [ 0
        m*l*sin(theta)*theta_dot^2 ];

  C = [ -m*g*l*sin(theta)  ;
         0                ];

  F = [ 0  ;
        u ];

  B = [ b_p_c*tanh(k_tan*theta_dot) + b_p_v*theta_dot  ;
        b_c_c*tanh(k_tan*x_dot) + b_c_v*x_dot         ];
  
  
  q_dot = [ theta_dot            ; % =   theta_dot
            x_dot                ; % =       x_dot
            MM\(F - G - C - B ) ]; % = [ theta_dot_dot
                                   %         x_dot_dot ]
  theta_dot_dot = q_dot(3);
  x_dot_dot     = q_dot(4);
  
end