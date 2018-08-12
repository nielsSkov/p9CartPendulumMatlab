clear all; close all; clc                                                  %#ok<CLALL>

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

run('latexDefaults.m')

v = -1:.001:1;

leg = char({'.......................'});

tanhApprox_h = figure;
hold on
for i = 1:7

  %exponentaial function to visually evenly distribute plots :)
  k_tanh = floor(  2*exp( (1/1.264)*i ) +20 );

  b_c = tanh(k_tanh*v);
  plot(v, b_c, 'linewidth', 1.2)
  
  str=sprintf('$ k_{tanh}= %.0f $', k_tanh);
  leg(i+1,1:length(str))=str;
end

grid on, grid minor

xlabel('$v$')
ylabel('$b_c$')

legend( leg(2,:), leg(3,:), leg(4,:), leg(5,:), ...
        leg(6,:), leg(7,:), leg(8,:),           ...
        'location', 'southeast'                 )

xlim([ -.1 .1 ])

%remember to float the windows before saving (for consistent scale)
if 0  
  figurePath1='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/figures/Original/';                 %#ok<UNRCH>
  figurePath2='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/figures/';
  fileTypeOrig="fig";

  for jj = 1:1
    switch jj
    case 1
      figHandle = tanhApprox_h;
      fileName='tanhApprox';
      saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,0);
    end
  end
end