m   = .100+.075+.026;    % .050   *    mass of pendulum             [kg]
M   = 5.273;             %       **    mass of cart                 [kg]
l   = 0.3235;            %        *    length                       [m]
g   = 9.82;              %             gravitational acceleration   [m s^-2]

r = 0.028;               %             radius of pulley             [m]

b_c_c = (3.021 + 2.746)/2; %       **    cart coulomb friction      [kg m s^-2]   or [N]
b_c_v = (1.937 + 1.422)/2; %       **    cart viscous friction      [kg s^-1]     or [N m^-1 s]

b_p_c =  4e-3;             %       **    pendulum coulomb friction  [kg m^2 s^-2] or [N m]
b_p_v = .4e-3;             %       **    pendulum viscous friction  [kg m^2 s^-1] or [N m s]

k_tan = 250;

k_tau = 93.4e-3;  %[N m A^-1]

%K = [ -0.6110  1.1586  6.2939 ]; % poles in [ -1 -2 -3 ] 
%K = [  -16.3728    9.8187   23.2948 ]; % poles in [ -3.50 -5.25 -8.75 ] works in real! sorta..
%K = [ -34.7982   16.2121   34.6289 ]; % poles in [ -4.50 -6.75 -11.25 ] works in real! sorta..
%K = [ -34.2159   15.0875   32.9048 ]; % poles in [ -6 -7 -8 ]
K = [ -24.4399   12.1979   27.5572 ]; % poles in [ -24.4399   12.1979   27.5572 ]


k1 = K(1);
k2 = K(2);
k3 = K(3);

%reduced notation
% a = m*l/(M+m);
% b = 1/(M+m);
% c = g/l;
% d = 1/l;
% e = 1/(m*(l^2));

% a = m*(l^2);
% c = m*l;
% d = M+m;
% e = m*g*l;

%theta_0 = pi/2;