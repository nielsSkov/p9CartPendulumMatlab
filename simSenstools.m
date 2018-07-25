function [ y ] = simSenstools( u, t, par )

assignin('base', 'par', par)

sim('cartPendulumModel.slx')

y = 0;
end

