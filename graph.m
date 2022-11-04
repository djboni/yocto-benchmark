#!/usr/bin/env octave-cli

clear

data = [
%                             HD
%                      Total  SSD  Avail. Used
%   Machine Cores GHz  RAM_GB NVMe RAM_GB Swap_GB Image_s SDK_s
    1       4     3.0  16     0    10     0       14315   6784
    2       4     2.0  16     1    14     0       15404   10638
    3.1     4     2.2  8      1    7.2    0       15133   10079
    4.1     4     1.6  8      0    7.3    0       14631   9926
    5.1     6     1.9  32     1    30     0       6598    4675
    1001    16    2.0  64     2    61     0       2194    1620
    1002    8     2.0  64     2    62     0       3668    2691
    1003    16    2.0  32     2    30     0       1950    1561
    1004    8     2.0  32     2    30     0       3539    2481
    1005    4     2.0  32     2    30     0       6507    4483
    1006    8     2.0  16     2    15     0       3576    2522
    1007    4     2.0  8      2    7.3    0       6139    4389
    1008    2     2.0  16     2    15     0       12573   8367
    1009    1     2.0  8      2    7.3    0       24870   16095
    1010    12    4.0  32     1    30     0       2973    2116
    1011    8     3.8  32     1    30     0       4329    3006
    1012    16    3.7  128    2    124    0       2214    1602
    1013    16    3.2  128    2    124    0       2471    1824
];

machine = data(:,1);
cores = data(:,2);
ghz = data(:,3);
total_ram = data(:,4);
ssd = data(:,5);
avail_ram = data(:,6);
used_swap = data(:,7);
time_image = data(:,8) / 3600;
time_sdk = data(:,9) / 3600;

core_ghz = cores .* 1;
ram = total_ram;
time = time_image + time_sdk;

hm = @(x)([floor(x) round((x-floor(x))*60)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1),clf
hold on

stem3(core_ghz, ram, time, 'o')
xmin = xlim()(1);
xmax = xlim()(2);
ymin = ylim()(1);
ymax = ylim()(2);
nticks = min(length(xticks()),length(yticks()));

% No negative build time
axis([axis() 0 ceil(max(time))])

xlabel('Cores')
ylabel('RAM [GB]')
zlabel('Build time [h]')
az = 180 - 60;
el = 30;
view(az, el)
grid on

hold off

print images/build-time-1.svg

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 2.a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2),clf

subplot(2,1,1)
hold on

stem(core_ghz, time, 'o')
xmin = xlim()(1);
xmax = xlim()(2);

% Equation
A = 12;
B = 0.0;
x = xmin:xmax;
y = A ./ x + B;
plot(x, y, '-')

% No negative build time
a = axis(); a(3) = 0; a(4) = ceil(max(time)); axis(a)
eq_2a = sprintf('Line: y = %.3g / x %+.3g', [A abs(B)])
title(eq_2a)
xlabel('Cores')
ylabel('Build time [h]')
grid on

hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 2.b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,1,2)
hold on

stem(ram, time, 'o')
xmin = xlim()(1);
xmax = xlim()(2);

% No negative build time
a = axis(); a(3) = 0; a(4) = ceil(max(time)); axis(a)

xlabel('RAM [GB]')
ylabel('Build time [h]')
grid on

hold off

print images/build-time-2.svg
