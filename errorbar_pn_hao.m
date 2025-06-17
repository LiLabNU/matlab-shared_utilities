function [hl, he] = errorbar_pn_hao(data, c, alpha)
% x - x axis values, such as time points
% y - y axis values, this is the mean
% er - size of the error bars
% c - color as an RGB triplet or index  

% [0.8500, 0.3250, 0.0980] 
% [0, 0.4470, 0.7410] 
% [0.4660 0.6740 0.1880]

% alpha - transparency (optional, default: 0.4)

if ~exist('alpha', 'var')
    alpha = 0.4;
end
if ~exist('c', 'var')
    c = getappdata(gca,'PlotColorIndex');
    if isempty(c)
        c = 1;
    end
end

% Remove rows with NaNs in the first column
data = data(~isnan(data(:,1)),:);

x = 1:size(data,2);
y = mean(data);

% Make everything column vectors
if isrow(x); x = x'; end
if isrow(y); y = y'; end

% Determine color
if numel(c) == 1
    ColOrd = get(gca,'ColorOrder');
    clrIdx = mod(c, size(ColOrd, 1));
    clrIdx = clrIdx + double(clrIdx == 0)*size(ColOrd, 1);
    c = ColOrd(clrIdx, :);
end

% If fewer than 2 rows, plot mean only (no error fill)
if size(data, 1) < 2
    he = [];  % No shaded error
    hl = plot(x, y, 'Color', c);
    return;
end

% Compute SEM
er = std(data) / sqrt(size(data, 1));
if isrow(er); er = er'; end

% Shaded error area
xFill = [x; flipud(x)];
yFill = [y+er; flipud(y-er)];
he = fill(xFill, yFill, c, 'FaceAlpha', alpha, 'LineStyle', 'none');
hold on;
hl = plot(x, y, 'Color', c);
hold off;
end
