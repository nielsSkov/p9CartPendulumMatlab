clear all; close all; clc                                                  %#ok<CLALL>

%change path to directory containing the project files
cd ~/syncDrive/uni/9thSem/project/p9CartPendulumMatlab

run('latexDefaults.m')

%constants
g     = 9.82;   %gravity         [ m s^-2 ]
r     = 0.03;   %pulley radius   [ m ]
k_tau = 0.0934; %torque constant [ N m A^-1 ]  ( given in data sheet as,
                %                                 93.4 mNm/A             )

%measured range of i_a
i_a      = 1.3:.1:4.5;  %amature current  [ A ]

%full range of i_a
i_a_full = 0:.1:4.5;    %amature current  [ A ]

%measured data
kg = [ 0.30 0.36 0.40 0.46 0.47 0.53 0.55 0.63 ...
       0.66 0.71 0.73 0.75 0.78 0.80 0.82 0.84 ...
       0.86 0.90 0.92 0.95 0.97 1.02 1.05 1.08 ...
       1.11 1.16 1.17 1.20 1.22 1.26 1.28 1.32 1.34 ];

F = kg*g; %force on cart    [ N ]

%least-square fit
a = (i_a'\F');
lsqFit = a*i_a_full;

%string for least-square legend
leg = sprintf('$F=$ %.2f* $\\cdot i_a$',a);

%theoretical torque and force
tau_th = i_a_full*k_tau;  %theoretical motor torque    [ N m ]
F_th   = tau_th/r;   %theoretical force on cart   [ N ]

%creating 1st figure
forceTest1_h = figure;

%plotting least-square fit
plot(i_a_full,lsqFit, 'linewidth', 1.2, 'color', [ 0 0 1 ])
hold on

%plotting theoretical result
plot(i_a_full,F_th, '-o', 'markersize', 3, 'color', [ 1 0 0 ], 'MarkerFaceColor',[1 0 0])

%plotting measured results
plot(i_a,F, '.', 'markersize', 12, 'color', [ 0 .55 0 ] )

%plot settings
grid on, grid minor
xlabel('$i_a$ [A]')
ylabel('$F$ [N]')
legend( 'Measured', leg, 'Theoretical', 'location', 'southeast')





%converting measured i_a range to bit_DAC values (real given bit_DAC)
bit_DAC      = 105.78*i_a      + 1970;
bit_DAC_full = 105.78*i_a_full + 1970;

%recalculate i_a and bit_DAC with new formula
%i_a_new      =  (bit_DAC     -1970)  / 111.9;
i_a_new_full =  (bit_DAC_full-1970)  / 111.9;

%recalculate theoretical torque and force
tau_th_new = i_a_new_full*k_tau;  %theoretical motor torque    [ N m ]
F_th_new   = tau_th_new/r;   %theoretical force on cart   [ N ]

%creating 2nd figure
forceTest2_h = figure;

%plotting least-square fit
plot(bit_DAC_full,lsqFit, 'linewidth', 1.8, 'color', [ 0 0 1 ])
hold on

%plotting theoretical result
plot(bit_DAC_full,F_th_new, '-o', 'markersize', 3, 'color', [ 1 0 0 ], 'MarkerFaceColor',[1 0 0])

%ploting data cooresponding to bit_DAC values
plot(bit_DAC,F, '.', 'markersize', 12, 'color', [ 0 .55 0 ] )

%plot settings
grid on, grid minor
xlabel('$\mathrm{bit}_\mathrm{DAC}$')
ylabel('$F$ [N]')
legend( 'Measured', 'Least Square Fit', 'Theoretical', 'location', 'southeast')




%remember to float the windows before saving (for consistent scale)
if 0  
  figurePath1='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/figures/Original/';                 %#ok<UNRCH>
  figurePath2='~/syncDrive/uni/9thSem/project/p9CartPendulumReport/figures/';
  fileTypeOrig="fig";

  for jj = 1:2
    switch jj
    case 1
      figHandle = forceTest1_h;
      fileName='forceTest1';
      saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,0);
      case 2
      figHandle = forceTest2_h;
      fileName='forceTest2';
      saveFig(figHandle,fileName,fileTypeOrig,figurePath1,figurePath2,0);
    end
  end
end