function [hl, he] = errorbar_pn(data, c, alpha)
% x - x axis values, such as time points
% y - y axis values, this is the mean
% er - size of the error bars
% color for the whole thing, as a triplet
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

x = 1:size(data,2);
y = mean(data);
er = std(data) ./ sqrt(size(data,1)); % standard error

if isrow(x)
    x = x';
end
if isrow(y)
    y = y';
end
if isrow(er)
    er = er';
end

if numel(c) == 1
    ColOrd = get(gca,'ColorOrder');
    clrIdx = mod(c, size(ColOrd, 1));
    clrIdx = clrIdx + double(clrIdx == 0)*size(ColOrd, 1);
    c = ColOrd(clrIdx, :);
end
xPlot = x;
yPlot = y;
x = [x; flipud(x)];
y2 = [y+er; flipud(y-er)];
he = fill(x, y2, c, 'FaceAlpha', alpha, 'LineStyle', 'none');
hold on;
hl = plot(xPlot, yPlot, 'Color', c);
hold off;
return;