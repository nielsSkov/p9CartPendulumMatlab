clear all; close all; clc                                                  %#ok<CLALL>

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

run('latexDefaults.m')

%using reduced notation
% a = m*(l^2)
% c = m*l
% d = M+m
% e = m*g*l

syms a c d e k_tan b_p_c b_p_v b_c_c b_c_v theta theta_dot x_dot f

MM = [  a          -c*cos(theta)  ;
       -c*cos(theta)    d        ];

M_inv = inv(MM)

G = [ 0                         ;
      c*sin(theta)*theta_dot^2 ];

C = [ -e*sin(theta)  ;
       0            ];

F = [ 0  ;
      f ];

B = [ b_p_c*tanh(k_tan*theta_dot) + b_p_v*theta_dot  ;
      b_c_c*tanh(k_tan*x_dot) + b_c_v*x_dot         ];


q_dot = [ theta_dot              ; % =   theta_dot
          x_dot                  ; % =       x_dot
          inv(MM)*(F - G - C  ) ]  % = [ theta_dot_dot
                                   %         x_dot_dot ]