clear
clc

tn = [0, 0.5, 1];
x = [1, 3, -1.5];
figure;
plot(tn, x, '-o', 'MarkerFaceColor', 'k');
xlabel('Time(s)');
ylabel('x(t)');
title('Matlab Interpolation of Signal');
grid on;

h = [0, 0.2, 0.4, 0.6, 0.8, 1.0, 0.8, 0.6, 0.4, 0.2, 0];
stem(h, 'filled');
ylabel('Impulse response h(n)');
xlabel('n');
title('stem plot for inpulse response h(n)');
grid on;

xe = [1, 0, 0, 0, 0, 3, 0, 0, 0, 0, -1.5];
t = 0:0.1:1;
figure;
stem(t, xe, 'filled');
xlabel('Time (seconds)');
ylabel('xe(t)');
title('Expanded Signal vs Samples');
grid on;

y = conv(xe, h);
figure;
stem(y, 'filled');
ylabel('Convolution output y(n)');
xlabel('n');
title('Convolution Output');
grid on;

t = -0.5:0.1:1.5;
figure;
stem(t, y, 'filled');
xlabel('Time (seconds)');
ylabel('y(t)');
title('Convolution Output vs Time');
grid on;