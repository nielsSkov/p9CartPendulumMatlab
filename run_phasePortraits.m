clc
%% ----Sym Model and Trajectory--------------------------------------------
syms m l M g x1 x2 F;
alpha = m*(l^2) - ( ((m^2)*(l^2))/(M + m) )*( cos(x1)^2 );
beta  = ( ((m^2)*(l^2))/(M + m) )*cos(x1)*sin(x1);
gamma = -m*g*l*sin(x1) - ( (m*l)/(M + m) )*cos(x1)*F;

x2_dot = simplify(-(beta/alpha)*(x2^2) - gamma/alpha)

warning('off')
syms F_traj theta_0 theta_f;
F_traj =                                                                ...
  simplify(                                                             ...
    solve(                                                              ...
      0 == (  ( (m*(l^2))-(((m^2)*(l^2))/(M+m)) )/                      ...
              ( (m*(l^2))-(((m^2)*(l^2))/(M+m))*(cos(theta_f)^2) )  )*  ...
              (-4)*(                                                    ...
                    (  ( (M*g) + (m*g) - (F_traj*tan(theta_f/2)) )/     ...
                       ( (M*l)*((tan(theta_f/2)^2) + 1) )           ) - ...
                    (  ( (M*g) + (m*g) - (F_traj*tan(theta_0/2)) )/     ...
                       ( (M*l)*((tan(theta_0/2)^2) + 1) )           )   ...
                   )                                                    ...
    ,F_traj)                                                            ...
  )

%% ----Initialize Model----------------------------------------------------
clear all; close all;                                                      %#ok<CLALL>
warning('on')

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

run('latexDefaults.m')

run('initPendulum.m')

%% ----Create Phase Portrait-----------------------------------------------

%plot switch
model         = 1;
firstTraj     = 1;
secondTraj    = 0;
thirdTraj     = 1;

%systems to be plotted
systems = [ model       ;
            firstTraj   ;
            secondTraj  ;
            thirdTraj  ];

for j = 1:sum(systems)
  if model
    F = 0;
    f = @(t,x) [                                              ...
                 x(2)                                         ...  = x1_dot
                 (- l*m*cos(x(1))*sin(x(1))*x(2)^2 +          ...
                 F*cos(x(1)) + g*m*sin(x(1))                  ...
                 + M*g*sin(x(1)))/(l*(M + m - m*cos(x(1))^2)) ...  = x2_dot
               ];
  elseif firstTraj
    theta_0 = pi;
    theta_f = 7*pi/4;
    F = -g*tan(theta_0/2 + theta_f/2)*(M + m);
    f = @(t,x) [                                              ...
                 x(2)                                         ...  = x1_dot
                 (- l*m*cos(x(1))*sin(x(1))*x(2)^2 +          ...
                 F*cos(x(1)) + g*m*sin(x(1))                  ...
                 + M*g*sin(x(1)))/(l*(M + m - m*cos(x(1))^2)) ...  = x2_dot
               ];
  elseif secondTraj
    F = 0;
    f = @(t,x) [                                              ...
                 x(2)                                         ...  = x1_dot
                 (- l*m*cos(x(1))*sin(x(1))*x(2)^2 +          ...
                 F*cos(x(1)) + g*m*sin(x(1))                  ...
                 + M*g*sin(x(1)))/(l*(M + m - m*cos(x(1))^2)) ...  = x2_dot
               ];
  elseif thirdTraj
    theta_0 = 7*pi/4;
    theta_f = pi;
    F = -g*tan(theta_0/2 + theta_f/2)*(M + m);
    f = @(t,x) [                                              ...
                 x(2)                                         ...  = x1_dot
                 (- l*m*cos(x(1))*sin(x(1))*x(2)^2 +          ...
                 F*cos(x(1)) + g*m*sin(x(1))                  ...
                 + M*g*sin(x(1)))/(l*(M + m - m*cos(x(1))^2)) ...  = x2_dot
               ];
  end
  
  %range in which to generate the phase portrait
  x1_min = -4*pi;
  x1_max =  4*pi;
  x2_min = -4*pi;
  x2_max =  4*pi;

  %number of points between x_min and x_max
  x1_res = 80;
  x2_res = 40;

  %creates a vector along x1 and an other along x2
  x1_vec = linspace( x1_min, x1_max, x1_res );
  x2_vec = linspace( x2_min, x2_max, x2_res );

  %creates a x1-x2-grid consisting of two matrices
  %one with all x1-values in the grid and
  %one with all the cooresponding x2-values in the grid
  [ x1_grid, x2_grid ] = meshgrid( x1_vec, x2_vec );

  %matrices for the derivatives
  x1_dot_grid = zeros(size(x1_grid));
  x2_dot_grid = zeros(size(x1_grid));

  %to get initial direction for all vectors in the field 
  t=0;

  %calculating a grid of x1_dot-values and another of x2_dot-values
  for i = 1:numel(x1_grid)
    
    x_dot = f( t, [x1_grid(i); x2_grid(i)] );

    %creating grid of derivatives
    x1_dot_grid(i) = x_dot(1);
    x2_dot_grid(i) = x_dot(2);
  end
  
  %create a new figure and set controler to 'done' = 0
  if model
    h_model = figure;
    model = 0;
  elseif firstTraj
    h_firstTraj = figure;
    firstTraj = 0;
  elseif secondTraj
    h_secondTraj = figure;
    secondTraj = 0;
  elseif thirdTraj
    h_thirdTraj = figure;
    thirdTraj = 0;
  end

  %plot
  quiver( x1_grid,     x2_grid,      ...
          x1_dot_grid, x2_dot_grid , ...
          'color', '[ .3 .3 .5 ]' );

  %general plot options
  xlabel('$x_1$ [rad]')
  ylabel('$x_2$ [rad$\ \cdot\ $s$^{-1}$]')
  axis tight equal;
  grid on; grid minor
  xticks([ -2*pi -3*pi/2 -pi -pi/2 0 ...
            pi/2 pi 3*pi/2 2*pi 5*pi/2 3*pi 7*pi/2 4*pi])
  xticklabels( {'$-2\pi$' '$-3\pi/2$' '$-\pi$' '$-\pi/2$' '$0$' ...
                '$\pi/2$' '$\pi$' '$3\pi/2$' '$2\pi$' ...
                '$5\pi/2$' '$3\pi$' '$7\pi/2$', '$4\pi$'} )
  yticks([-3*pi -2*pi -pi 0 pi 2*pi 3*pi])
  yticklabels( {'$-3\pi$' '$-2\pi$' '$-\pi$' '$0$' ...
                '$\pi$'   '$2\pi$'  '$3\pi$'} )
  drawnow
end



%draw trajectories
if systems(1) %model
  %----------SIMULATION ODE45----------------------------------------------

  %initial conditions for ode45
  theta_0          = pi/1.2;
  x_0              = 0;
  theta_dot_0      = 0;
  x_dot_0          = 0;

  %sample time and final time [s]
  Ts = .01;
  T_final = 10;

  %initialization for ode45
  tspan = 0:Ts:T_final;
  init  = [ theta_0 x_0 theta_dot_0 x_dot_0 ];

  %lowering relative tollerence (default 1e-3) to avoid drifting along x
  options = odeset('RelTol',1e-7);

  con = 0; %no controller - only model

  [t, q] = ode45( @(t,q)                                        ...
                  simOdeFun( t,q, m, M, l, g, k_tan, r, k_tau,  ...
                             b_p_c, b_p_v, b_c_c, b_c_v, con ), ...
                  tspan, init, options                          );

  %------------------------------------------------------------------------

  %store simulation data
  x1_sim = q(:,1);
  x2_sim = q(:,3);

  %set figure gca
  figure(h_model)
  hold on

  %plot(x1_sim, x2_sim, 'linewidth', 1.1, 'color', [ 0 0 1 ])

  %add start-point
%     init = [ initVal_x1 initVal_x2 ];
%     sca1_h = scatter( init(1), init(2),...
%                       [], trajColor, 'marker', '.', 'SizeData', 100);
  
  %set axis limits
  xlim([ -pi/2 5*pi/2 ])
  ylim([ -7*pi/2 7*pi/2 ])
  axis square
end
if systems(2) %h_firstTraj
  %----------SIMULATION ODE45----------------------------------------------

  %initial conditions for ode45
  theta_0          = pi;
  x_0              = 0;
  theta_dot_0      = 0;
  x_dot_0          = 0;

  %sample time and final time [s]
  Ts = .001;
  T_final = .393;

  %initialization for ode45
  tspan = 0:Ts:T_final;
  init  = [ theta_0 x_0 theta_dot_0 x_dot_0 ];

  %lowering relative tollerence (default 1e-3) to avoid drifting along x
  options = odeset('RelTol',1e-7);

  con = 1; %select control in sim, first trajectory

  [t, q] = ode45( @(t,q)                                        ...
                  simOdeFun( t,q, m, M, l, g, k_tan, r, k_tau,  ...
                             b_p_c, b_p_v, b_c_c, b_c_v, con ), ...
                  tspan, init, options                          );

  %------------------------------------------------------------------------

  %store simulation data
  x1_sim = q(:,1);
  x2_sim = q(:,3);

  %set figure gca
  figure(h_firstTraj)
  hold on

  plot(x1_sim, x2_sim, 'linewidth', 1.2, 'color', [ 0 0 1 ])

  %add start-point
%     init = [ initVal_x1 initVal_x2 ];
%     sca1_h = scatter( init(1), init(2),...
%                       [], trajColor, 'marker', '.', 'SizeData', 100);
  
  %set axis limits
  xlim([ -pi/2 5*pi/2 ])
  ylim([ -7*pi/2 7*pi/2 ])
  axis square
end
if systems(3) %h_secondTraj
  %----------SIMULATION ODE45--------------------------------------------

  %initial conditions for ode45
  theta_0          = pi/1.2;
  x_0              = 0;
  theta_dot_0      = 0;
  x_dot_0          = 0;

  %sample time and final time [s]
  Ts = .01;
  T_final = 10;

  %initialization for ode45
  tspan = 0:Ts:T_final;
  init  = [ theta_0 x_0 theta_dot_0 x_dot_0 ];

  %lowering relative tollerence (default 1e-3) to avoid drifting along x
  options = odeset('RelTol',1e-7);

  con = 1; %no controller - only model

  [t, q] = ode45( @(t,q)                                        ...
                  simOdeFun( t,q, m, M, l, g, k_tan, r, k_tau,  ...
                             b_p_c, b_p_v, b_c_c, b_c_v, con ), ...
                  tspan, init, options                          );

  %----------------------------------------------------------------------

  %store simulation data
  x1_sim = q(:,1);
  x2_sim = q(:,3);

  %set figure gca
  figure(h_secondTraj)
  hold on

  plot(x1_sim, x2_sim, 'linewidth', 1.1, 'color', [ 0 0 1 ])

  %add start-point
%     init = [ initVal_x1 initVal_x2 ];
%     sca1_h = scatter( init(1), init(2),...
%                       [], trajColor, 'marker', '.', 'SizeData', 100);
  
  %set axis limits
  xlim([ -pi/2 5*pi/2 ])
  ylim([ -3*pi/2 3*pi/2 ])
end
if systems(4)
  %----------SIMULATION ODE45--------------------------------------------

  %initial conditions for ode45
  theta_0          = 7*pi/4;
  x_0              = 0;
  theta_dot_0      = 0;
  x_dot_0          = 0;

  %sample time and final time [s]
  Ts = .001;
  T_final = .401;

  %initialization for ode45
  tspan = 0:Ts:T_final;
  init  = [ theta_0 x_0 theta_dot_0 x_dot_0 ];

  %lowering relative tollerence (default 1e-3) to avoid drifting along x
  options = odeset('RelTol',1e-7);

  con = 3; %select control in sim, first trajectory

  [t, q] = ode45( @(t,q)                                        ...
                  simOdeFun( t,q, m, M, l, g, k_tan, r, k_tau,  ...
                             b_p_c, b_p_v, b_c_c, b_c_v, con ), ...
                  tspan, init, options                          );

  %----------------------------------------------------------------------

  %store simulation data
  x1_sim = q(:,1);
  x2_sim = q(:,3);

  %set figure gca
  figure(h_thirdTraj)
  hold on

  plot(x1_sim, x2_sim, 'linewidth', 1.2, 'color', [ 0 0 1 ])

  %add start-point
%     init = [ initVal_x1 initVal_x2 ];
%     sca1_h = scatter( init(1), init(2),...
%                       [], trajColor, 'marker', '.', 'SizeData', 100);
  
  %set axis limits
  xlim([ -pi/2 5*pi/2 ])
  ylim([ -7*pi/2 7*pi/2 ])
  axis square
end

%remember to float the windows before saving (for consistent scale)
if 0
  figurePath1='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/Presentation/figures/Original/';                 %#ok<UNRCH>
  figurePath2='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/Presentation/figures/';
  fileTypeOrig="fig";

  for jj = 1:1:4
    switch jj
    case 1
      if systems(1) == 1
        figHandle=h_model;
        fileName='modelPhasePlot';
        saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,3);
      end
    case 2
      if systems(2) == 1
        figHandle=h_firstTraj;
        fileName='firstTraj';
        saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,3);
      end
    case 3
      if systems(3) == 1
        figHandle=h_secondTraj;
        fileName='secondTraj';
        saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,3);
      end
    case 4
      if systems(4) == 1
        figHandle=h_thirdTraj;
        fileName='thirdTraj';
        saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,3);
      end
    end
  end
end