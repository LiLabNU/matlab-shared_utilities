function [h, barData] = HaoBarErrorbar(Data1, Data2, Data3, type, group,stats)

if nargin < 3
    Data3 = [];
    type = "mean";
    group = [];
    stats = 1;
elseif nargin < 4
    type = "mean";
    group = [];
    stats = 1;
elseif nargin < 5
    Data3 = Data3(~isnan(Data3));
    group = [];
    stats = 1;
end

if ~isempty(group)
    idx = unique(group);
    temp2 = Data1;
    Data1 = temp2(group==idx(1),:);
    Data2 = temp2(group==idx(2),:);
    if idx == 3
        Data3 = temp2(group==idx(3),:);
    end
else
    Data1 = Data1(~isnan(Data1));
    Data2 = Data2(~isnan(Data2));
end

if type == "mean"
    barData = [mean(Data1) mean(Data2) mean(Data3)];
elseif type == "median"
    barData = [median(Data1) median(Data2) median(Data3)];
end
barData = barData(~isnan(barData));

barErr = [std(Data1,1)./sqrt(size(Data1,1)) std(Data2,1)./sqrt(size(Data2,1)) std(Data3,1)./sqrt(size(Data3,1))];
barErr = barErr(~isnan(barErr));

h = bar(1:length(barData), barData);
hold on;
er = errorbar(1:length(barData), barData, barErr);
er.Color = [0 0 0];
er.LineStyle = 'none';
h.FaceColor = 'flat';

if isempty(Data3)
    h.CData = [.2 0.2 0.2; 0.8 0.8 0.8];
    % Perform t-test
    if stats == 1
        [~, p_ttest] = ttest2(Data1, Data2);
        sigStars = getSigStars(p_ttest);
        text(1.5, max(barData) + max(barErr), sigStars, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
else
    h.CData = [.2 0.2 0.2; 0.5 0.5 0.5; 0.8 0.8 0.8];
    if stats == 1
        % Perform one-way ANOVA
        p_anova = anova1([Data1; Data2; Data3], [ones(size(Data1)); 2*ones(size(Data2)); 3*ones(size(Data3))], 'off');
        sigStars = getSigStars(p_anova);
        text(2, max(barData) + max(barErr), sigStars, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
end

hold off;
end

function sigStars = getSigStars(pValue)
if pValue < 0.001
    sigStars = '***';
elseif pValue < 0.01
    sigStars = '**';
elseif pValue < 0.05
    sigStars = '*';
else
    sigStars = 'n.s.';
end
end
