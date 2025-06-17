% mouseClickCallback.m
function mouseClickCallback(obj, ~)
    global coords; % Use a global variable to store coordinates

    % Get the current point clicked by the user on the image
    cp = get(gca, 'CurrentPoint');
    x = cp(1,1);
    y = cp(1,2);

    % Store the coordinates
    coords = [coords; [x, y]];

    % Mark the clicked point on the image
    hold on; % Retain the current plot when adding new plots
    plot(x, y, 'r+', 'MarkerSize', 10, 'LineWidth', 2); % Marks the point with a red plus
    hold off; % Release the plot hold
end
