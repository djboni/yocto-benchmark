#!/usr/bin/env octave-cli

clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Misc hardware
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_misc = [
%                             0_HD
%                      Total  1_SSD  Avail. Used
%   Machine Cores GHz  RAM_GB 2_NVMe RAM_GB Swap_GB Image_s SDK_s
    1       4     3.0  16     0      10     0       14315   6784
    2       4     2.0  16     1      14     0       15404   10638
    3.1     4     2.2  8      1      7.2    0       15133   10079
    4.1     4     1.6  8      0      7.3    0       14631   9926
    5.1     6     1.9  32     1      30     0       6598    4675
    1010    12    4.0  32     1      30     0       2973    2116
    1011    8     3.8  32     1      30     0       4329    3006
    1012    16    3.7  128    2      124    0       2214    1602
    1013    16    3.2  128    2      124    0       2471    1824
    1111    4     2.6  32     -1     30     0       8415    5649
    1112    2     2.6  32     -1     30     0       16434   10768
];

cores_misc = data_misc(:,2);
ram_misc = data_misc(:,4);
time_misc = (data_misc(:,8) + data_misc(:,9)) / 3600;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Virtual Server, AMD EPYC-Rome Processor @ 2 GHz
% Best fit for y = A/x + B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_AMD_EPYC = [
%                             0_HD
%                      Total  1_SSD  Avail. Used
%   Machine Cores GHz  RAM_GB 2_NVMe RAM_GB Swap_GB Image_s SDK_s
    1001    16    2.0  64     2      61     0       2194    1620
    1002    8     2.0  64     2      62     0       3668    2691
    1003    16    2.0  32     2      30     0       1950    1561
    1004    8     2.0  32     2      30     0       3539    2481
    1005    4     2.0  32     2      30     0       6507    4483
    1006    8     2.0  16     2      15     0       3576    2522
    1007    4     2.0  8      2      7.3    0       6139    4389
    1008    2     2.0  16     2      15     0       12573   8367
    1009    1     2.0  8      2      7.3    0       24870   16095
];

cores_AMD_EPYC = data_AMD_EPYC(:,2);
ram_AMD_EPYC = data_AMD_EPYC(:,4);
time_AMD_EPYC = (data_AMD_EPYC(:,8) + data_AMD_EPYC(:,9)) / 3600;

Y = time_AMD_EPYC;
X = [1./cores_AMD_EPYC ones(length(cores_AMD_EPYC), 1)];

% Least squares
W = inv(X' * X) * X' * Y;
A1 = W(1)
B1 = W(2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Virtual Server, ARM Neoverse-N1 @ 2GHz
% Best fit for y = A/x + B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_ARM_Neoverse = [
%                             0_HD
%                      Total  1_SSD  Avail. Used
%   Machine Cores GHz  RAM_GB 2_NVMe RAM_GB Swap_GB Image_s SDK_s
    1101    16    2.0  96     -1     92     0       2370    1926
    1102     8    2.0  96     -1     93     0       4077    2945
    1103     4    2.0  96     -1     93     0       7569    5262
    1104     2    2.0  96     -1     92     0       14683   9820
    1105     1    2.0  64     -1     61     0       28319   19097
    1106     1    2.0  8      -1     7.4    0       30161   20079
    1107     2    2.0  8      -1     7.3    0       14879   10079
    1108     4    2.0  8      -1     7.3    0       7759    5478
    1109     8    2.0  8      -1     7.3    0       4062    3029
    1110    16    2.0  16     -1     15     0       2208    1809
];

cores_ARM_Neoverse = data_ARM_Neoverse(:,2);
ram_ARM_Neoverse = data_ARM_Neoverse(:,4);
time_ARM_Neoverse = (data_ARM_Neoverse(:,8) + data_ARM_Neoverse(:,9)) / 3600;

Y = time_ARM_Neoverse;
X = [1./cores_ARM_Neoverse ones(length(cores_ARM_Neoverse), 1)];

% Least squares
W = inv(X' * X) * X' * Y;
A2 = W(1)
B2 = W(2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Agregate all data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cores_all = [cores_misc; cores_AMD_EPYC; cores_ARM_Neoverse];
ram_all   = [ram_misc;   ram_AMD_EPYC;   ram_ARM_Neoverse];
time_all  = [time_misc;  time_AMD_EPYC;  time_ARM_Neoverse];

cores_ticks = unique(cores_all);
ram_ticks = unique(ram_all);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1),clf
hold on

stem3(cores_all, ram_all, time_all, 'x')
xticks(cores_ticks)
yticks(ram_ticks)

xmin = xlim()(1);
xmax = xlim()(2);
ymin = ylim()(1);
ymax = ylim()(2);

% Equation
x = (xmin:xmax)';
y1 = A1 ./ x + B1;
y2 = A2 ./ x + B2;
plot3(x, ymin*ones(1,length(x)), y1, '-')
plot3(x, ymin*ones(1,length(x)), y2, '-')

% No negative build time
a = [axis() 0 ceil(max(time_all))];
a(2) = max(cores_ticks);
a(3) = ymin; % Fix start of y plane on the plotted lines
a(4) = max(ram_ticks);
axis(a)

eq_2a1 = sprintf('y_1 = %.3g/x% +.2g', [A1 B1])
eq_2a2 = sprintf('y_2 = %.3g/x% +.2g', [A2 B2])
graph_title = ['Lines: ', eq_2a1, ' - ', eq_2a2];

title(graph_title)
xlabel('Cores')
ylabel('RAM [GB]')
zlabel('Build time [h]')
legend({
    'Samples',
    'y_1 AMD EPYC',
    'y_2 ARM Neoverse',
    })
az = 180 - 57.5;
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

stem(cores_all, time_all, 'x')
xticks(cores_ticks)

% Equation
x = (xmin:xmax)';
y1 = A1 ./ x + B1;
y2 = A2 ./ x + B2;
plot(x, [y1, y2], '-')

% No negative build time
a = axis();
a(2) = max(cores_ticks);
a(3) = 0;
a(4) = ceil(max(time_all));
axis(a)

title(graph_title)
xlabel('Cores')
ylabel('Build time [h]')
legend({
    'Samples',
    'y_1 AMD EPYC',
    'y_2 ARM Neoverse',
    })
grid on

hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 2.b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,1,2)
hold on

stem(ram_all, time_all, 'x')
xticks(ram_ticks)

% No negative build time
a = axis();
a(2) = max(ram_ticks);
a(3) = 0;
a(4) = ceil(max(time_all));
axis(a)

xlabel('RAM [GB]')
ylabel('Build time [h]')
grid on

hold off

print images/build-time-2.svg
