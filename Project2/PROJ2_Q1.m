clear
clc

Fs = 8192;
T = 5;
t = linspace(0, T, floor(T * Fs));
Omega = 2 * pi * 1500;
beta = 2 * pi * 3000;

x = sin(Omega * t + 1/2 * beta * t.^2);
Theta = Omega + beta * t;
plot(t, Theta);
xlabel("Time (t)");
ylabel("Instantaneuos frequency");
%soundsc(x);

t1 = linspace(0, 0.5, floor(0.5 * Fs));
t2 = linspace(0, 0.8, floor(0.8 * Fs));
t3 = linspace(0, 1.2, floor(1.2 * Fs));
t4 = linspace(0, 2, floor(2 * Fs));

x1 = sin(Omega * t1 + 1/2 * beta * t1.^2);
x2 = sin(Omega * t2 + 1/2 * beta * t2.^2);
x3 = sin(Omega * t3 + 1/2 * beta * t3.^2);
x4 = sin(Omega * t4 + 1/2 * beta * t4.^2);

[X1, f1] = ctft(x1, Fs);
[X2, f2] = ctft(x2, Fs);
[X3, f3] = ctft(x3, Fs);
[X4, f4] = ctft(x4, Fs);

figure;
subplot(2,2,1);
plot(f1, abs(X1));
ylim([0, 0.15]);
ylabel('|X1(f)|');
xlabel('Frequency (Hz)');
title('CTFT plot for signal length of 0.5sec');
grid on;

subplot(2,2,2);
plot(f2, abs(X2));
ylim([0, 0.15]);
xlabel('Frequency (Hz)');
ylabel('|X2(f)|');
title('CTFT plot for signal length of 0.8 sec');
grid on;

subplot(2,2,3);
plot(f3, abs(X3));
ylim([0, 0.15]);
xlabel('Frequency (Hz)');
ylabel('|X3(f)|');
title('CTFT plot for signal length of 1.2 sec');
grid on;

subplot(2,2,4);
plot(f4, abs(X4));
ylim([0, 0.15]);
xlabel('Frequency (Hz)');
ylabel('|X4(f)|');
title('CTFT plot for signal length of 2 sec');
grid on;

%CTFT calculates the continuous-time Fourier transform (CTFT)
% of a periodic signal x(t) which is reconstructed from the samples in
% the vector x using ideal bandlimited interpolation. The vector x
% contains samples of x(t) over an integer number of periods, and fs
% is the sampling frequency fs
%
% Usage: [X,f] = ctft(x,fs)
%
% The vector X contains the (complex) samples of the continuous-time
% Fourier transform evaluated at the frequencies in the vector f.
%
% This function makes make use of the relationship between the CTFT
% of x(t) and the DTFT of its samples x[n], as well as the
% relationship between the DTFT and the DFT of x[n].
% This function is a simple adaptation of:
%---------------------------------------------------------------
% copyright 1996, by John Buck, Michael Daniel, and Andrew Singer.
% For use with the textbook "Computer Explorations in Signals and
% Systems using MATLAB", Prentice Hall, 1997.
%---------------------------------------------------------------
function [X,f] = ctft(x,fs)
    N = numel(x);
    X = fftshift(fft(x,N))*(2*pi/N); % do fft; scale; shift so DC is in the middle
    f = fs/N * (-floor(N/2) : floor((N-1)/2));
end