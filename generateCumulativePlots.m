function cumulative_data = generateCumulativePlots(data, type, lineColor)
    % Generate cumulative distribution plots

    % Default values
    if nargin < 3
        lineColor = [0, 0, 1, 1.0]; % Default line color (Blue with full opacity)
    end
    if nargin < 2
        type = 'probability'; % Default to 'probability' if type is not specified
    end

    if ismatrix(data)
        [m, n] = size(data); % Get the dimensions of the matrix

        if strcmp(type, 'probability')
            % Calculate the cumulative probability values
            if m == 1
                n_total = sum(data);
                cumulative_data = cumsum(data) / n_total;
                plot(cumulative_data, '-', 'Color', lineColor, 'LineWidth', 1);
                ylabel('Cumulative Probability');
                %grid on;
            else
                for i = 1:m
                    n_total = sum(data(i, :));
                    cumulative_data(i, :) = cumsum(data(i, :)) / n_total;
                    hold on;
                    plot(cumulative_data(i, :), '-', 'Color', lineColor, 'LineWidth', 1);
                end
                hold off;
                ylabel('Cumulative Probability');
                %grid on;
                ylim([0, 1]);
            end

        elseif strcmp(type, 'raw')
            if m == 1
                % Create a plot of the cumulative row values for each column
                cumulative_data = cumsum(data);
                plot(cumulative_data, '-', 'Color', lineColor, 'LineWidth', 1);
                ylabel('Cumulative Row Values');
                %grid on;
            else
                for i = 1:m
                    cumulative_data(i, :) = cumsum(data(i, :));
                    hold on;
                    plot(cumulative_data(i, :), '-', 'Color', lineColor, 'LineWidth', 1);
                end
                hold off;
                ylabel('Cumulative Row Values');
                %grid on;
            end
        else
            warning('Please specify the types of plot: either probability or raw');
        end
    end
    %xlabel('Time');
end
