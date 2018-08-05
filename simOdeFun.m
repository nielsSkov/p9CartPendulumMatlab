function [ q_dot, theta_dot_dot, x_dot_dot ] = simOdeFun( t, q, f, m, M,...
                                                           l, g, k_tan, ...
                                                           b_p_c, b_p_v,...
                                                           b_c_c, b_c_v )
  theta         = q(1);
  theta_dot     = q(3);
  x_dot         = q(4);

  MM = [  m*(l^2)          -m*l*cos(theta)  ;
         -m*l*cos(theta)    M+m            ];

  G = [ 0
        m*l*sin(theta)*theta_dot^2 ];

  C = [ -m*g*l*sin(theta)  ;
         0                ];

  F = [ 0  ;
        f ];

  B = [ b_p_c*tanh(k_tan*theta_dot) + b_p_v*theta_dot  ;
        b_c_c*tanh(k_tan*x_dot) + b_c_v*x_dot         ];
  
  
  q_dot = [ theta_dot            ; % =   theta_dot
            x_dot                ; % =       x_dot
            MM\(F - G - C - B ) ]; % = [ theta_dot_dot
                                   %         x_dot_dot ]
  theta_dot_dot = q_dot(3);
  x_dot_dot     = q_dot(4);
  
end