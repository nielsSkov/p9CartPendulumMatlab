close all

%Import data from simulation
t = x_p.Time;
xp = x_p.Data;
yp = y_p.Data;
xc = x_c.Data;
theta = Theta.Data;

%Plain plot of pendulum (xp,yp) trajectory
% plot(xp,yp, '--')
% grid on, grid minor
% axis equal

%Initializing Animation Figure
figure
grid on, grid minor
axis equal
axis([ -28 80 -20 20 ])
hold on

%Drawing obstacles
rectangle('Position',[ -2 -40 4 40 ], 'FaceColor', [ .5 .5 .5 ], 'EdgeColor', [.5 .5 .5]);
rectangle('Position',[ -2 1.5 4 40 ], 'FaceColor', [ .5 .5 .5 ], 'EdgeColor', [.5 .5 .5]);

%Initializing Moving Objects and Trajectory
scatter(xp(1), yp(1), '.', 'b')
xpLast = xp(1);
ypLast = yp(1);
cart = rectangle('Position',[ xc(1) 0 2 1 ]);
rod = plot( [ xc(1) xp(1) ] , [ 0 yp(1) ], 'k', 'linewidth', 2);
drawnow

t_old = 0;

%for testing timing
% t_test1 = zeros(length(t),1);
% t_test2 = zeros(length(t),1);

tic;

res = 5; % deviding resolution of simulation data with res

%Animation Loop
for i = 2:length(t)  /res
  
  i = i*res;

  delete(cart)
  cart = rectangle('Position',[ xc(i)-1.5 -1 3 2 ], 'FaceColor', [ .9 .9 .9 ]);

  delete(rod)
  rod = plot( [ xc(i) xp(i) ] , [ 0 yp(i) ], 'k', 'linewidth', 2 );

  if sqrt( (xpLast-xp(i))^2 + (ypLast-yp(i))^2 ) >= .5 %<-setting distance
    %scatter(xp(i),yp(i), '.', 'b')                     %  resolution between
    %plot([xp(i-1); xp(i)], [yp(i-1); yp(i)])
    plot(xp(i),yp(i), '.', 'color', 'b')
    xpLast = xp(i);                                   %  points on the
    ypLast = yp(i);                                   %  trajectory
  end  

  runT = toc;
  
  %for testing timing
  % t_test1(i/res) = t(i);
  % t_test2(i/res) = runT;

  if runT < t(i)
    pauses(t(i)-runT)
  end

  drawnow
end

%for testing timing
% figure;
% plot(t_test1(1:round(i/res)))
% hold on
% plot(t_test2(1:round(i/res)))



