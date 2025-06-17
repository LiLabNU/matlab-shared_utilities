function plotBarGraphWithErrors(data, categoryLabels, groupLabels)
    % This function plots the means and SEMs of an n x m data matrix as a bar graph with error bars.
    %
    % Inputs:
    %   data            - n x m matrix where each row is a different sample (observation)
    %                     and each column a different dataset (group)
    %   categoryLabels  - Cell array of strings for labeling each sample (optional)
    %   groupLabels     - Cell array of strings for labeling each group (optional)
    
    % Calculate the means and SEMs
    means = mean(data);  % Row vector of means of each column
    sems = std(data) ./ sqrt(size(data, 1));  % SEM calculation for each column

% Proceed to plot these statistics
    if nargin < 2 || isempty(categoryLabels)
        categoryLabels = arrayfun(@(x) ['Category ' num2str(x)], 1:size(data, 1), 'UniformOutput', false);
    end
    
    if nargin < 3 || isempty(groupLabels)
        groupLabels = arrayfun(@(x) ['Group ' num2str(x)], 1:size(data, 2), 'UniformOutput', false);
    end
    
    % Number of groups
    numGroups = size(data, 2);
    
    % Create the bar graph
    %fig = figure;
    ax = axes(fig);
    b = bar(ax, means, 'FaceColor', 'flat');  % Plot means
    hold(ax, 'on');
    
    % Add error bars
    % Calculate x positions for error bars (center of each bar)
    x = 1:numGroups;
    errorbar(ax, x, means, sems, 'k.', 'LineWidth', 2);  % Plot SEMs as error bars
    
    % Customize the plot with labels and title
    title(ax, 'Bar Graph of Means with SEM');
    xlabel(ax, 'Groups');
    ylabel(ax, 'Mean Values');
    set(ax, 'XTick', 1:numGroups, 'XTickLabel', categoryLabels);  % Label categories/groups
    xlim(ax, [0 numGroups+1]);
    
    % Add a legend if group labels are provided
    if ~isempty(groupLabels)
        legend(ax, groupLabels, 'Location', 'best');
    end
    
    hold(ax, 'off');
end

