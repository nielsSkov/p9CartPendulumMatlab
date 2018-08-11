function [ rho, i_a] = rhoIa( x_init, epsilon, beta_0, k, k_tau, r )
  x1 = x_init(1);
  x2 = x_init(2);
  x3 = x_init(3);
  x4 = x_init(3);
  
  rho = -(6.8e-18*(4.4e18*x4 - 7.3e18*x3 + 4.1e18*sin(3.0*x1) +      ...
         1.2e16*tanh(255.0*x4) - 4.6e19*sin(x1) +                    ...
         4.2e17*tanh(255.0*x3)*cos(x1) + 2.1e18*x3*cos(2.0*x1) -     ...
         1.3e18*x4*cos(2.0*x1) - 2.4e15*cos(2.0*x1)*tanh(255.0*x4) + ...
         2.5e17*x4*cos(x1) + 1.0e17*x4^2*sin(2.0*x1) -               ...
         3.3e18*x3*x4*sin(x1) + 4.1e17*x3*x4*sin(3.0*x1)))/cos(x1)   ;
  
  %controller
  beta = rho + beta_0;
  s = x3 + k(1)*x2 + k(2)*(0.33*x3 - 1.0*x4*cos(x1)) + k(3)*x1;
  u = -min( 1, max(-1, (1/epsilon)*s))*beta;
  
  i_a = u*r/k_tau;
end
