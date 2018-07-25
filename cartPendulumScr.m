clear all; close all; clc                                                  %#ok<CLALL>

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

%set LaTeX as default interpreter
set( groot, 'defaultAxesTickLabelInterpreter',      'latex' );
set( groot, 'defaultLegendInterpreter',             'latex' );
set( groot, 'defaultTextInterpreter',               'latex' );
set( groot, 'defaultColorbarTickLabelInterpreter',  'latex' );
set( groot, 'defaultPolaraxesTickLabelInterpreter', 'latex' );
set( groot, 'defaultTextarrowshapeInterpreter',     'latex' );
set( groot, 'defaultTextboxshapeInterpreter',       'latex' );

m   = 4+.100+.075+.026;    % .050   *    mass of pendulum             [kg]
M   = 5.273;             %       **    mass of cart                 [kg]
l   = 0.3348;            %        *    length                       [m]
g   = 9.82;              %             gravitational acceleration   [m s^-2]

C_l = (3.021 + 2.746)/2; %       **    linear coulomb friction      [kg m s^-2]   or [N]
V_l = (1.937 + 1.422)/2; %       **    linear viscous friction      [kg s^-1]     or [N m^-1 s]

C_r =  4e-3;             %       **    rotational coulomb friction  [kg m^2 s^-2] or [N m]
V_r = .4e-3;             %       **    rotational viscous friction  [kg m^2 s^-1] or [N m s]

k_tan = 250;

%reduced notation
a = m*l/(M+m);
b = 1/(M+m);
c = g/l;
d = 1/l;
e = 1/(m*(l^2));

theta_init = .1;

sim('cartPendulumModel.slx')


process='Senstools';

par = [ C_r
        V_r ];

