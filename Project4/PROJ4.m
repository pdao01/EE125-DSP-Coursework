clear
clc

[x,Fs] = audioread('onscreen.wav');
%soundsc(x,Fs);

%Question 1
timeVector = (0:size(x, 1)-1) / Fs;
plot(timeVector, x);
xlabel('Time (s)');
ylabel('Amplitude');
title('"On screen" Audio Speech');
grid on;

%Question 2
load('smallChurch_fs22k.mat');
hChurch = hChurch(:);
%soundsc(hChurch,Fs);
t = (0:length(hChurch)-1) / Fs;
plot(t,hChurch);
xlabel('Time (s)');
ylabel('Amplitude');
title('Zoomed Church Impulse Response');
xlim([0.15 0.25]);  % Adjust later
grid on;

yChurch = conv(x,hChurch);
%soundsc(yChurch, Fs);

timeOutput = (0:length(yChurch)-1) / Fs;
plot(timeOutput, yChurch);
xlabel('Time (s)');
ylabel('Amplitude');
title('Linear Convolution with Church Impulse Response');
grid on;

%Question 3: FFT-based linear convolution.
%Calculate how much zero-padding is needed to ensure FFT-based circular convolution equals linear convolution
%N has to have length greater than 30681 + 22050 = 52731. Use  radix-2 FFT algorithm
%Thus, N=16 so that 2^16 = 65536
L = 65536;
Fs

%Question 4:
length_initial = length(x);
hChurch_padded = paddata(hChurch, length_initial);
hChurch_filter = fft(hChurch_padded, length_initial);
X_filter = fft(x, length_initial);
total_length = length(x) + length(hChurch_padded);
yChurch_fft = real(ifft(X_filter .* hChurch_filter));
soundsc(yChurch_fft, Fs);

time_q4 = (0:length(yChurch_fft)-1) / Fs;
plot(time_q4, yChurch_fft);
xlabel('Time (s)');
ylabel('Amplitude');
title('Circular Convolution without zero padding');
grid on;

%Question 5:
hChurch_padded_fft = paddata(hChurch,L);
Church_fft_filter = fft(hChurch_padded_fft,L);
xPadded = paddata(x, L);
X_fft_filter = fft(xPadded, L);
yChurch_padded_fft = real(ifft(X_fft_filter .* Church_fft_filter));
%soundsc(yChurch_padded_fft, Fs);

time_q5 = (0:length(yChurch_padded_fft)-1) / Fs;
plot(time_q5, yChurch_padded_fft);
xlabel('Time (s)');
ylabel('Amplitude');
title('Circular Convolution with zero padding');
grid on;


%Question 6: 
%Part c: Difference between linear and zero-padded FFT convolution
difference_zero = yChurch(1:min(length(yChurch), length(yChurch_padded_fft))) ...
                - yChurch_padded_fft(1:min(length(yChurch), length(yChurch_padded_fft)));
timeDifference1 = (0:length(difference_zero)-1)/Fs;

%Part e: Difference between linear and non-zero-padded FFT convolution
difference_circular = yChurch(1:min(length(yChurch), length(yChurch_fft))) - ...
                      yChurch_fft(1:min(length(yChurch), length(yChurch_fft)));

timeDifference2 = (0:length(difference_circular)-1)/Fs;

subplot(3,2,1);
plot(timeVector, x);
title('(a) Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,2,2);
plot(timeOutput, yChurch);
title('(b) Linear Convolution');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,2,3);
plot(timeDifference1, difference_zero);
title('(c) Difference: Linear vs. Zero-Padded FFT');
xlabel('Time (s)');
ylabel('Difference');
grid on;

subplot(3,2,4);
plot(time_q4, yChurch_fft);
title('(d) Circular Convolution Without Zero-Padding');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,2,5);
plot(timeDifference2, difference_circular);
title('(e) Difference: Linear vs. Circular Convolution');
xlabel('Time (s)');
ylabel('Difference');
grid on;