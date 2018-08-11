m   = 4+.100+.075+.026;  % .050   *    mass of pendulum             [kg]
M   = 5.273;             %       **    mass of cart                 [kg]
l   = 0.3348;            %        *    length                       [m]
g   = 9.82;              %             gravitational acceleration   [m s^-2]

r = 0.028;               %             radius of pulley             [m]

b_c_c = (3.021 + 2.746)/2; %       **    cart coulomb friction      [kg m s^-2]   or [N]
b_c_v = (1.937 + 1.422)/2; %       **    cart viscous friction      [kg s^-1]     or [N m^-1 s]

b_p_c =  4e-3;             %       **    pendulum coulomb friction  [kg m^2 s^-2] or [N m]
b_p_v = .4e-3;             %       **    pendulum viscous friction  [kg m^2 s^-1] or [N m s]

k_tan = 250;

k_tau = 93.4e-3;  %[N m A^-1]

%reduced notation
% a = m*l/(M+m);
% b = 1/(M+m);
% c = g/l;
% d = 1/l;
% e = 1/(m*(l^2));

a = m*(l^2);
c = m*l;
d = M+m;
e = m*g*l;

theta_0 = pi/2;