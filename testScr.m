clear all; close all; clc

syms m M l g A theta theta_dot theta_dot_dot;

a =  m*(l^2);
b = (m^2)*(l^2)/(M+m);
c =  m*l/(M+m);
d =  m*g*l;

%dynamics with theta as motion generator,
alpha =  a - b*(cos(theta)^2);
beta  =  b*sin(theta)*cos(theta);
gamma = -A*c*cos(theta) -d*sin(theta);
%
alpha*theta_dot_dot + beta*(theta_dot^2) + gamma

%theta_dot^2 + (a-b)/(a-b*(cos(theta)^2))*INTEGRAL

%INTEGRAL
(-A*c*cos(theta)-d*sin(theta))

m = 1;      % mass of pendulum            [kg]
M = 10;     % mass of cart                [kg]
l = 3;      % length                      [m]
g = 9.82;   % gravitational acceleration  [m/s^2]

A = (cos(1.4)+1)*g*(M+m)/sin(1.4)

%---------CASE /w m=M=l=1 -------------------------------------------------
% m = 1;      % mass of pendulum            [kg]
% M = 1;      % mass of cart                [kg]
% l = 1;      % length                      [m]
% syms g;
% a =  m*(l^2);
% b = (m^2)*(l^2)/(M+m);
% c =  m*l/(M+m);
% d =  m*g*l;
% %INTEGRAL
% (-A*c*cos(theta)-d*sin(theta))
%--------------------------------------------------------------------------

a =  m*(l^2);
b = (m^2)*(l^2)/(M+m);
c =  m*l/(M+m);
d =  m*g*l;

s = pi:-.1:1.4;
f=128.2459;

const = 2/(a-b*(cos(1.4)^2))

%INTEGRAL
in = (f*c*cos(s)+d*sin(s))
hold on
plot(s,in)


%system phase portrait
x1' = x2
x2' = ((-(1^2)*(3^2)/(10+1))*sin(x1)*cos(x1)*(x2^2)+1*9.82*3*sin(x1))/( 1*(3^2)-((1^2)*(3^2)/(10+1))*(cos(x1)^2) )

%trajectory1 --------< t_final = 1.431 s >---------
x1' = x2
x2' = ((-(1^2)*(3^2)/(10+1))*sin(x1)*cos(x1)*(x2^2)+1*9.82*3*sin(x1)+128.25*(1*3/(10+1))*cos(x1))/( 1*(3^2)-((1^2)*(3^2)/(10+1))*(cos(x1)^2) )

%%%%%%%%% FORCE TRAJECTORIES (EVERYTHING WRITTEN OUT) >>>CORRECT VERSION!<<< %%%%%%%%%%%%%

% ALFA-BETA-GAMMA (symbolic)
%
% x1' = x2
% x2' = - beta/alpha *x2^2  - gamma/alpha
% where,
% alpha = m*(l^2) - ( (m^2)*(l^2)/(M+m) )*cos(x1)
% beta = ( (m^2)*(l^2)/(M+m) )*sin(x1)*cos(x1)
% gamma = f*( m*l/(M+m) )*cos(x1)  -m*g*l*sin(x1)

% WRITTEN OUT (symbolic)
%
% x1' = x2
% x2' = - ( (( (m^2)*(l^2)/(M+m) )*sin(x1)*cos(x1))/(m*(l^2) - ( (m^2)*(l^2)/(M+m) )*cos(x1)) ) *(x2^2)  - ( (f*( m*l/(M+m) )*cos(x1)  -m*g*l*sin(x1))/(m*(l^2) - ( (m^2)*(l^2)/(M+m) )*cos(x1)) )


% WRITTEN OUT (explicit EXCEPT FORCE!)
% 
% x1' = x2
% x2' = - ( (( (1^2)*(3^2)/(10+1) )*sin(x1)*cos(x1))/(1*(3^2) - ( (1^2)*(3^2)/(10+1) )*cos(x1)) ) *(x2^2)  - ( (f*( 1*3/(10+1) )*cos(x1)  -1*9.82*3*sin(x1))/(1*(3^2) - ( (1^2)*(3^2)/(10+1) )*cos(x1)) )















