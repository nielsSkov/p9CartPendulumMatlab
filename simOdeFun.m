function [ q_dot, theta_dot_dot, x_dot_dot, i_a ] =                     ...
                                              simOdeFun( t, q, m, M,    ...
                                                         l, g, k_tan, r, k_tau, ...
                                                         b_p_c, b_p_v,  ...
                                                         b_c_c, b_c_v, con )
 persistent secondTrajec;
 persistent thirdTrajec;
 persistent xc_dot_dot;
 
 theta         = q(1);
  x             = q(2);
  theta_dot     = q(3);
  x_dot         = q(4);
  
  x1 = theta;
  x2 = x;
  x3 = theta_dot;
  x4 = x_dot;
  
  if con == -1 %sliding mode

    epsilon = 0.03;
    beta_0 = .1;
    rho = 8.9095;
    beta = rho + beta_0;

    %k = [ -12.2200    8.1755   20.3620 ];
    %k = [ -43.4282   18.9887   39.3900 ];
    %k = [ -3.8126    3.7749   12.2335 ];
    %k = [ -0.6110    1.1586    6.2939 ]; %lead  poles in [ -1 -2 -3 ]
    %k = [ -5.9668    5.0250   14.6870 ];
    k = [ -27.4949   13.3372   29.3036 ];% poles in [ -5 -6 -9 ]

    %s = x3 + k(1)*x2 + k(3)*x1 + k(2)*(0.3348*x3 - x4*cos(x1));
    %u = -min( 1, max(-1, (1/epsilon)*s))*beta;

    %actuation saturation
    %   if abs(u*r/k_tau) > 5
    %     u = sign(u)*5*k_tau/r;
    %   end

    g_b_inv = (l*(M + m - m*cos(x1)^2))/cos(x1);

    s = x3 + k(1)*x2 + k(3)*x1 + k(2)*((647*x3)/2000 - x4*cos(x1));

    u = -g_b_inv*beta*min( 1, max(-1, (1/epsilon)*s));
  end
  
  if con == 0 %no controller - only model
    u = 0;
  end
  
  if con == 1
    theta_0 = pi;
    theta_f = 7*pi/4;
    u = -g*tan(theta_0/2 + theta_f/2)*(M + m);
  end
  
  if con == 2
    u = (M+m)*x4; %should be x4_dot = x_dot_dot
  end
  
  if con == 3
    theta_0 = 7*pi/4;
    theta_f = pi;
    u = -g*tan(theta_0/2 + theta_f/2)*(M + m);
  end

  if con == 4
    if t == 0
      secondTrajec = 0;
      thirdTrajec  = 0;
    end
    
    if theta < 7*pi/4-.2 && secondTrajec == 0 && thirdTrajec == 0
      theta_0 = pi;
      theta_f = 7*pi/4;
      u = -g*tan(theta_0/2 + theta_f/2)*(M + m);
    elseif ( theta >= 7*pi/4-.2 && x <= 4) || ( secondTrajec == 1 && thirdTrajec == 0 )
      u = (M+m)*xc_dot_dot
      secondTrajec  = 1;
    elseif x > 4 || ( secondTrajec == 1 && thirdTrajec == 1 )
      theta_0 = 7*pi/4;
      theta_f = pi;
      u = -g*tan(theta_0/2 + theta_f/2)*(M + m);
      thirdTrajec  = 1;
    end
  end

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
  
  xc_dot_dot    = q_dot(4);
  
  i_a = u*r/k_tau;
end