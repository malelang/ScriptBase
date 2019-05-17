close all
clear all
%% RUIDO A PARTIR DE WAVELETS
a = load('PPGconRuido');
a = a.PPGconRuido;
CleanedSignal = emd_dfadenoising (a);
OriginalSignal = a';
plot(OriginalSignal,'r'),axis([0 1000 -4 8.5]),hold on
plot(CleanedSignal),axis([0 1000 -4 8.5])
title('Denoising example for PPG using Empirical Mode Decomposition and Hurst Analysis')
legend('Original Signal','Denoised Signal','Location','NorthWest');
