function y_smooth = smoothkanha(y, winsize, type)

% Purpose: Smoothening a given time series using a given kernel
%
% Input: y: a 1*time array or a num*time array depicting the sequences to be
%           smoothened, where num is the number of sequences
%        xlims: a 1*2 array depicting the beginning and end time stamps
%        binsize: a scalar representing the binning of the given data
%        winsize: size of the kernel used for smoothening; also equal to
%                 the number of bins to be included for smoothening; has to
%                 be an odd number
%        type: a string depicting whether to smoothen via a two-sided
%              exponential function (Gaussian) to include both future and
%              past information, or a one-sided exponential function to
%              only include the past
%              NOTE: if type == "bi_dir", the number of bins included for
%                    smoothening = winsize, but if type == "uni_dir", the
%                    number of bins included for smoothening =
%                    (winsize+1)/2
%        plot_fig: boolean depicting whether or not to plot the original
%                  and smoothened time series';
%                  NOTE: only for 1D inputs
%
% Output: y_smooth: a 1*time array depicting the smoothened time series

% Code:
if mod(winsize, 2) == 0
    error("Error. \nInput winsize must be an odd number.");
    return
end

y_smooth = y;
if type == "bi_dir"
    kernel = exp(-((1:winsize) - ceil(winsize/2)).^2/(2*std(1: winsize)^2)); % Gaussian Kernel (don't touch)
elseif type == "mono_dir"
    kernel = exp(-((1:winsize) - ceil(winsize/2)).^2/(2*std(1: winsize)^2)); % Unidirectional Decaying Exponential Kernel (don't touch)
    kernel(ceil(size(kernel, 2)/2): end) = 0;
end
for i = 1: size(y_smooth, 1)
    y_smooth(i, :) = conv(y(i, :), kernel, 'same')/winsize;
end
end