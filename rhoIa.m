function [ rho, i_a] = rhoIa( x_init, epsilon, beta_0, k, k_tau, r )
  x1 = x_init(1);
  x2 = x_init(2);
  x3 = x_init(3);
  x4 = x_init(3);
  
  run('initPendulum')
  
  %wrong
%   rho = -(6.8e-18*(4.4e18*x4 - 7.3e18*x3 + 4.1e18*sin(3.0*x1) +      ...
%          1.2e16*tanh(255.0*x4) - 4.6e19*sin(x1) +                    ...
%          4.2e17*tanh(255.0*x3)*cos(x1) + 2.1e18*x3*cos(2.0*x1) -     ...
%          1.3e18*x4*cos(2.0*x1) - 2.4e15*cos(2.0*x1)*tanh(255.0*x4) + ...
%          2.5e17*x4*cos(x1) + 1.0e17*x4^2*sin(2.0*x1) -               ...
%          3.3e18*x3*x4*sin(x1) + 4.1e17*x3*x4*sin(3.0*x1)))/cos(x1)   ;
 
%   rho = -(3.4e-28*(3.4e29*x4 - 2.6e29*x3 + 1.2e28*sin(3.0*x1) +       ...
%          8.6e27*tanh(255.0*x4) - 1.4e30*sin(x1) +                     ...
%          8.5e27*tanh(255.0*x3)*cos(x1) + 4.9e27*x3*cos(2.0*x1) -      ...
%          6.3e27*x4*cos(2.0*x1) - 1.4e26*cos(2.0*x1)*tanh(255.0*x4) +  ...
%          5.0e27*x4*cos(x1) + 1.0e26*x4^2*sin(2.0*x1) -                ...
%          1.3e29*x3*x4*sin(x1) + 1.2e27*x3*x4*sin(3.0*x1)))/cos(x1)    ;
 

rho = (l*(M + m - m*cos(x1)^2)*(k2*(x3*x4*sin(x1) -...
  (M*b_p_v*x3 + b_p_v*m*x3 + M*b_p_c*tanh(k_tan*x4) +...
  b_p_c*m*tanh(k_tan*x4) - g*l*m^2*sin(x1) + ...
  b_c_c*l*m*tanh(k_tan*x3)*cos(x1) + l^2*m^2*x4^2*cos(x1)*sin(x1) -...
  M*g*l*m*sin(x1) + b_c_v*l*m*x4*cos(x1))/(l*m*(M + m - m*cos(x1)^2)) +...
  (cos(x1)*(b_p_v*x3*cos(x1) + b_p_c*tanh(k_tan*x4)*cos(x1) + ...
  b_c_v*l*x4 + b_c_c*l*tanh(k_tan*x3) + l^2*m*x4^2*sin(x1) -...
  g*l*m*cos(x1)*sin(x1)))/(l*(M + m - m*cos(x1)^2))) + k1*x4 + k3*x3 -...
  (M*b_p_v*x3 + b_p_v*m*x3 + M*b_p_c*tanh(k_tan*x4) +...
  b_p_c*m*tanh(k_tan*x4) - g*l*m^2*sin(x1) +...
  b_c_c*l*m*tanh(k_tan*x3)*cos(x1) + l^2*m^2*x4^2*cos(x1)*sin(x1) -...
  M*g*l*m*sin(x1) + b_c_v*l*m*x4*cos(x1))/(l^2*m*(M + m -...
  m*cos(x1)^2))))/cos(x1)  ;
 
  
  %controller
  beta = rho + beta_0;
  
  %wrong
  %s = x3 + k(1)*x2 + k(2)*(0.33*x3 - 1.0*x4*cos(x1)) + k(3)*x1;
  
  s = x3 + k(1)*x2 + k(3)*x1 + k(2)*(0.3348*x3 - x4*cos(x1));
  u = -min( 1, max(-1, (1/epsilon)*s))*beta;
  
  i_a = u*r/k_tau;
end
