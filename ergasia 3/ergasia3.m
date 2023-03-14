M = 16; % Size of signal constellation
k = log2(M); % Number of bits per symbol
n = 3e4; % Number of bits to process
nsamp = 1; % Oversampling rate
%% Signal Source
% Create a binary data stream as a column vector.
x = randi([0,1],n,1);
% Plot first 40 bits in a stem plot.
stem(x(1:40),'filled');
title('Random Bits');
xlabel('Bit Index'); ylabel('Binary Value');


%% Bit-to-Symbol Mapping
% Convert the bits in x into k-bit symbols.
xsym = bi2de(reshape(x,k,length(x)/k).','left-msb');
%% Stem Plot of Symbols
% Plot first 10 symbols in a stem plot.
figure; % Create new figure window.
stem(xsym(1:10));
title('Random Symbols');
xlabel('Symbol Index'); ylabel('Integer Value');


%% Modulation
% Modulate using 16-QAM.
y = qammod(xsym,M);


%% Transmitted Signal
ytx = y;
%% Channel
% Send signal over an AWGN channel.
EbNo = 20; % In dB
snr = EbNo + 10*log10(k) - 10*log10(nsamp);
ynoisy = awgn(ytx,snr,'measured');
%% Received Signal
yrx = ynoisy;


%% Scatter Plot
% Create scatter plot of noisy signal and transmitted
% signal on the same axes.
h = scatterplot(yrx(1:nsamp*5e3),nsamp,0,'g.');
hold on;
scatterplot(ytx(1:5e3),1,0,'k*',h);
title('Received Signal');
legend('Received Signal','Signal Constellation');
axis([-5 5 -5 5]); % Set axis ranges.
hold off;


%% Demodulation
% Demodulate signal using 16-QAM.
zsym = qamdemod(yrx,M);


%% Symbol-to-Bit Mapping
% Undo the bit-to-symbol mapping performed earlier.
z = de2bi(zsym,'left-msb'); % Convert integers to bits.
% Convert z from a matrix to a vector.
z = reshape(z.',prod(size(z)),1);


%% BER Computation
% Compare x and z to obtain the number of bit errors and
% the bit error rate.
[number_of_errors,bit_error_rate] = biterr(x,z)