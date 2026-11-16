clear
clc

%Part 1: FFT-based compression
%Question 1:
%x = audioread('train.wav')
[x,Fs] = audioread('onscreen.wav');
timeVector = (0:length(x)-1)
%soundsc(x);
%soundsc(x, Fs);

plot(timeVector,x);
xlabel('Time');
ylabel('Amplitude');
xlim([0 12880]);
title('Audio Waveform');
grid on;

%Question 2:
L = 2^nextpow2(length(x));
x_fft = fft(x,L);
x_power = abs(x_fft) .^ 2;

frequencyVector = (0:L-1)/Fs * (44100 / L);
plot(frequencyVector, x_power);
xlabel('Frequency (Hz)');
ylabel('Power (dB)');
title('Audio Power Spectrum');
grid on;

%Question 3:
function Sc = FFTcompression(signal,percentRetained)
    S = fft(signal);
    numRetained = round(percentRetained/100 * length(S));
    [~, sortedIndices] = sort(abs(S), 'descend');

    Sc = zeros(size(S));
    Sc(sortedIndices(1:numRetained)) = S(sortedIndices(1:numRetained));

    % Enforce conjugate symmetry
    k = 2:ceil(length(S)/2);          % positive-frequency bins (1-based)
    m = length(S) - k + 2;            % their mirror bins
    keep = (Sc(k) ~= 0) | (Sc(m) ~= 0);
    Sc(k(keep)) = S(k(keep));
    Sc(m(keep)) = conj(Sc(k(keep)));
end

%Question 4:
function snr = SNRoverall(signal,reconSignal)
    signal_sum = sum(signal .^ 2);
    noise = signal - reconSignal;
    noise_sum = sum(noise .^ 2);
    snr = 10 * log10(signal_sum / noise_sum);
end

%Question 5:
Sc100 = FFTcompression(x,100);
Sc50 = FFTcompression(x,50);
Sc20 = FFTcompression(x,20);
Sc10 = FFTcompression(x,10);

Sc_test = FFTcompression(x, 0.3);

recon100 = ifft(Sc100);
recon50 = ifft(Sc50);
recon20 = ifft(Sc20);
recon10 = ifft(Sc10);
recon_test = ifft(Sc_test);

% Convert reconstructed signals to real-valued signals
recon100 = real(recon100);
recon50  = real(recon50);
recon20  = real(recon20);
recon10  = real(recon10);

%Code for train signal
%soundsc(recon100);
%pause(5);
%soundsc(recon50);
%pause(5);
%soundsc(recon20);
%pause(5);
%soundsc(recon10);
%pause(5);
%soundsc(recon_test);

%Question 6: Code for onscreen signal
%soundsc(recon100, Fs);
%pause(5);
%soundsc(recon50, Fs);
%pause(5);
soundsc(recon20, Fs);
pause(5);
%soundsc(recon10, Fs);
%pause(5);
soundsc(recon_test, Fs);

f_Vector = (0:length(Sc10)-1) * (44100 / length(Sc10));
x_fft = fft(x,length(Sc10));

figure;

plot(f_Vector, abs(x_fft), 'b', 'LineWidth', 2);
hold on;
plot(f_Vector, abs(Sc10), 'r', 'LineWidth', 0.5);

legend('Original FFT', 'Compressed FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Original vs. Compressed Frequency Spectrum');
grid on;
hold off;

snr100 = SNRoverall(x,recon100);
snr50 = SNRoverall(x,recon50);
snr20 = SNRoverall(x,recon20);
snr10 = SNRoverall(x,recon10);

Retention = [100; 50; 20; 10];
SNR_FFT = [snr100; snr50; snr20; snr10];

SNR_table = table(Retention, SNR_FFT, 'VariableNames', {'PercentRetained', 'SNR_dB'});

disp(SNR_table);


%Part 2: Storage savings due to compression
%Question 1:
whos

%Question 2:
whos Sc100 Sc10
Ssp10 = sparse(Sc10);
whos Sc10 Ssp10


%Part 3: Discrete Cosine Transform
%Question 1:
D = zeros(1,1024);
D(1) = 1;
D_inverse = idct(D);
figure;
plot(D_inverse);
xlabel('Sample Index');
xlim([0 1024]);
ylabel('Amplitude');
title('Inverse DCT Output when D(1) = 1');
grid on;

D(1) = 0;
D(2) = 1;
D_inverse = idct(D);
figure;
plot(D_inverse);
xlabel('Sample Index');
xlim([0 1024]);
ylabel('Amplitude');
title('Inverse DCT Output when D(2) = 1');
grid on;

D(2) = 0;
D(3) = 1;
D_inverse = idct(D);
figure;
plot(D_inverse);
xlabel('Sample Index');
xlim([0 1024]);
ylabel('Amplitude');
title('Inverse DCT Output when D(3) = 1');
grid on;

%Question 2:
function Dc = DCTcompression(signal,percentRetained)
    S = dct(signal);
    numRetained = round(percentRetained/100 * length(S));
    [~, sortedIndices] = sort(abs(S), 'descend');

    Dc = zeros(size(S));
    Dc(sortedIndices(1:numRetained)) = S(sortedIndices(1:numRetained));
end

%Question 3:
Dc100 = DCTcompression(x,100);
Dc50 = DCTcompression(x,50);
Dc20 = DCTcompression(x,20);
Dc10 = DCTcompression(x,10);
Dc_test = FFTcompression(x,1);

reconDct100 = idct(Dc100);
reconDct50 = idct(Dc50);
reconDct20 = idct(Dc20);
reconDct10 = idct(Dc10);
reconDct_test = idct(Dc_test);

% Convert reconstructed signals to real-valued signals
reconDct100 = real(reconDct100);
reconDct50  = real(reconDct50);
reconDct20  = real(reconDct20);
reconDct10  = real(reconDct10);
reconDct_test  = real(reconDct_test);

%Code for train signal
%soundsc(reconDct100);
%soundsc(reconDct50);
%soundsc(reconDct20);
%soundsc(reconDct10);
%soundsc(reconDct_test);

%Code for onscreen signal
%soundsc(reconDct100, Fs);
%soundsc(reconDct50, Fs);
soundsc(reconDct20, Fs);
%soundsc(reconDct10, Fs);
%soundsc(reconDct_test, Fs);

f_Vector = (0:length(Dc_test)-1) * (44100 / length(Dc_test));
x_dct = dct(x,length(Dc_test));

figure;
plot(f_Vector, abs(x_dct),'b', 'LineWidth', 1.5);
hold on;
plot(f_Vector, abs(Dc_test),'r', 'LineWidth', 0.5);

legend('Original FFT', 'Compressed DCT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Original vs. Compressed Frequency Spectrum');
grid on;
hold off;

snrDct100 = SNRoverall(x,reconDct100);
snrDct50 = SNRoverall(x,reconDct50);
snrDct20 = SNRoverall(x,reconDct20);
snrDct10 = SNRoverall(x,reconDct10);

PercentRetained = [100; 50; 20; 10];

SNR_DCT = [snrDct100;
           snrDct50;
           snrDct20;
           snrDct10];

DCTresults = table(PercentRetained, SNR_DCT);
disp(DCTresults);

Comparison = table(PercentRetained, SNR_FFT, SNR_DCT);
disp(Comparison);