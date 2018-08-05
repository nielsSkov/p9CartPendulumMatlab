function  q_dot = simSimpleOdeFun(t, q)

  m = 1;
  g = 9.82;
  l = 1;
  
  theta     = q(1);
  theta_dot = q(2);
  
  %note that ode45 needs the q_dot-dynamics to output the q-dynamics
  %
  q_dot = [  theta_dot                               ;% = theta_dot
            -(m*g*l/(m*(l^2)))*sin(theta)            ;% = theta_dot_dot
            -(m*g*l/(m*(l^2)))*cos(theta)*theta_dot ];% = theta_dot_dot_dot
end
                                          % so that   q = [ theta
                                          %                 theta_dot
                                          %                 theta_dot_dot ]