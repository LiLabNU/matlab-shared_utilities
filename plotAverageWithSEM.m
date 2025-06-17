function avg = plotAverageWithSEM(data, lineColor, transparency)
    % Plot the average line with shaded SEM area
    
    % Default values
    if nargin < 3
        transparency = 0.5; % Default transparency
    end
    if nargin < 2
        lineColor = 'b'; % Default line color
    end

    % Calculate the mean and standard error of the mean (SEM)
    avg = mean(data);
    sem = std(data) / sqrt(length(data));

    % Create the x-values for the shaded area
    x = 1:length(avg);

    % Define the vertices for the shaded area
    xFill = [x, fliplr(x)];
    yFill = [avg - sem, fliplr(avg + sem)];

    % Plot the average line
    plot(x, avg, '-', 'Color', lineColor, 'LineWidth', 1);
    hold on;

    % Fill the shaded area with the same color and transparency
    fill(xFill, yFill, lineColor, 'FaceAlpha', transparency);

    hold off;

    % Add labels and title (uncomment these lines if needed)
    % xlabel('X-axis Label');
    % ylabel('Y-axis Label');
    % title('Average with Shaded SEM');

    % Optionally, add a legend (uncomment this line if needed)
    % legend('Average', 'SEM');

    %grid on;
end
