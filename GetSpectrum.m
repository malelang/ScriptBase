function  GetSpectrum(OriginalSignal,Fs)
    %FORMA 1
  %  YRealization1=fft(sNorm(Realization,:));
% %Dominio de la frecuencia para la gráfica
% P1=abs(YRealization1/length(sNorm));
% EspectroRealizacion1=P1(1:length(sNorm)/2+1);
% EspectroRealizacion1(2:end-1) = 2*EspectroRealizacion1(2:end-1);
    signal = fft(OriginalSignal);
    L = length(OriginalSignal);
    P2 = abs(signal/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    figure(1)
    plot(f,P1),hold on,
    %legend('ruido')
%     title('FORMA 1: FOURIER');
%     grid on, axis([-1 10 -0 0.5 ]) 
%     % FORMA 2
%     Res = 10; 
%     Npuntos = 2^nextpow2(Fs/2/Res);
%     w = hanning(Npuntos);
%     [Pf,Ff]=pwelch(OriginalSignal(Realization,:),w,Npuntos/2,Npuntos,Fs); 
%     figure
%     pwelch(OriginalSignal(Realization,:),w,Npuntos/2,Npuntos,Fs),
%     legend('Signal')
%     title('FORMA 2: pwelch')
%     %FORMA 3
%     [~,~,f,dP] = centerfreq(Fs,OriginalSignal(Realization,:)); %SEÑAL NORMAL
%     [PS,NN] = PowSpecs(OriginalSignal(Realization,:));
%     figure
%     plot(f,dP), xlabel('Frequency(Hz)')
%     legend('ruido')
%     title('FORMA 3: PowSpect');
%     grid on, axis([0 50 -10 100 ])
end