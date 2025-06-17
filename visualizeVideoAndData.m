function visualizeVideoAndData(videoFile, timeSeriesData, framesToShow, smoothWindow, BehaviorTable, speed)
% Declare global variables
global isPlaying

[concatenatedFrames, behaviorLabels] = concatenateBroisFrames(BehaviorTable,2);

% Load video
videoObj = VideoReader(videoFile);

% Initialize figure and axes
fig = figure('Name', 'Video and Data Visualization', 'Position', [100, 100, 800, 600]);
axVideo = axes('Position', [0.05, 0.2 0.4, 0.9]);
axText = axes('Position', [0.05, 0.8 0.4, 0.9]);
axBehavior = axes('Position', [0.05, 0.1, 0.4, 0.2]);
axDataWide = axes('Position', [0.55, 0.7, 0.4, 0.2]);
axData = axes('Position', [0.55, 0.4, 0.4, 0.2]);
axSmoothedData = axes('Position', [0.55, 0.1, 0.4, 0.2]);

colormap = [0.5, 0.5, 0.5; % Gray
            0, 0, 1;      % Blue
            1, 0, 0];     % Red

% Create play/pause button
playButton = uicontrol('Style', 'pushbutton', 'String', 'Play', ...
    'Units', 'normalized', 'Position', [0.05, 0.01, 0.1, 0.05], ...
    'Callback', @playPauseCallback);

% Create scrollbar
sld = uicontrol('Style', 'slider', 'Min', 1, 'Max', videoObj.NumberOfFrames, ...
    'Value', 1, 'SliderStep', [1 / videoObj.NumberOfFrames, 10 / videoObj.NumberOfFrames], ...
    'Units', 'normalized', 'Position', [0.15, 0.01, 0.7, 0.05]);

% Initialize video playback state
isPlaying = false;

% Display initial frame and data
currentFrame = 1;
imshow(read(videoObj, currentFrame), 'Parent', axVideo);
plotBehavior(axBehavior, concatenatedFrames, currentFrame, framesToShow, 0);
plotDataWide(axDataWide, timeSeriesData, currentFrame,framesToShow, 0);
plotData(axData, timeSeriesData, currentFrame, framesToShow, 0);
plotSmoothedData(axSmoothedData, timeSeriesData, currentFrame, framesToShow, smoothWindow, 0);
xlabel(axData, 'Time');
ylabel(axData, 'Z-Score');
xlabel(axSmoothedData, 'Time');
ylabel(axSmoothedData, 'Z-Score');

% Set up slider callback
sld.Callback = @scrollCallback;

% Scroll callback function
    function scrollCallback(src, ~)
        currentFrame = round(src.Value);
        updateFrame(currentFrame);
    end

% Play/pause callback function
    function playPauseCallback(~, ~)
        isPlaying = ~isPlaying;
        if isPlaying
            set(playButton, 'String', 'Pause');
            while isPlaying && currentFrame < videoObj.NumberOfFrames
                currentFrame = currentFrame + 1;
                updateFrame(currentFrame);
                drawnow;
                % Adjust pause for Nx speed playback
                pause(1 / (speed * videoObj.FrameRate));
            end
            set(playButton, 'String', 'Play');
            isPlaying = false;
        else
            set(playButton, 'String', 'Play');
        end
    end


% Update frame function
    function updateFrame(frame)

        currentValue = concatenatedFrames(currentFrame);
        % Determine the text based on currentValue
        behaviorText = '';
        if currentValue == 0
            behaviorText = 'Not Defined';
            textColor = colormap(1, :); % Gray
        elseif currentValue == 1
            behaviorText = behaviorLabels(1);
            textColor = colormap(2, :); % Blue
        elseif currentValue == 2
            behaviorText = behaviorLabels(2);
            textColor = colormap(3, :); % Red
        end
        % Clear existing text (if any) and disable axis for axText
        cla(axText); % Clear the axes for text
        axis(axText, 'off'); % Hide the axis lines and labels
        % Display the text in axText
        % You may need to adjust the position and alignment as necessary
        text('Parent', axText, 'Position', [0.5, 0.1], 'Units', 'normalized', ...
            'String', behaviorText, 'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', 'FontSize', 30, 'Color', textColor);


        imshow(read(videoObj, frame), 'Parent', axVideo);
        plotBehavior(axBehavior, concatenatedFrames, frame, framesToShow, currentValue);
        plotData(axData, timeSeriesData, frame, framesToShow, currentValue);
        plotDataWide(axDataWide, timeSeriesData, frame,framesToShow, currentValue);
        plotSmoothedData(axSmoothedData, timeSeriesData, frame, framesToShow, smoothWindow, currentValue);

        title(axDataWide, ['Current Frame ', num2str(frame), ' with a 10x wider window: ', num2str(framesToShow*10), ' frames']);
        title(axData, ['Z-scored based on a ', num2str(framesToShow), ' frames baseline']);
        title(axSmoothedData, ['Smoothed with a moving average of ', num2str(smoothWindow), ' frames']); 
        titleText = "Behavior " + newline + ...
            "Gray: Value 0 -- Not defined" + newline + ...
            "Blue: Value 1 -- " + behaviorLabels(1) + newline + ...
            "Red: Value 2 -- " + behaviorLabels(2);
        title(axBehavior, titleText);
    end


% Plot horizontal bar indicating behaviors
    function plotBehavior(ax, concatenatedFrames, currentFrame, framesToShow, currentValue)
        startFrame = max(1, currentFrame);
        endFrame = min(length(concatenatedFrames), currentFrame + framesToShow);
        dataWindow = concatenatedFrames(startFrame:endFrame);                
        % Plot behavior data
        plot(ax, startFrame:endFrame, dataWindow, 'LineWidth', 1.5, 'Color', colormap(currentValue+1,:));
        hold(ax, 'on');

        % Plot vertical line indicating current frame
        plot(ax, [currentFrame, currentFrame], [min(concatenatedFrames)-1, max(concatenatedFrames)], 'r--', 'LineWidth', 2);

        hold(ax, 'off');
        xlim(ax, [startFrame, endFrame]);
    end



% Plot raw data with a 10x wider window
    function plotDataWide(ax, data, currentFrame,framesToShow, currentValue)
        startFrame = max(1, currentFrame - framesToShow*10);
        endFrame = min(length(data), currentFrame + framesToShow*10);
        dataWindow = data(startFrame:endFrame);

        % Plot raw data
        plot(ax, startFrame:endFrame, dataWindow, 'LineWidth', 1.5);
        hold(ax, 'on');

        % Plot vertical line indicating current frame
        plot(ax, [currentFrame, currentFrame], [min(dataWindow), max(dataWindow)], 'Color', colormap(currentValue+1,:), 'LineWidth', 2);

        hold(ax, 'off');
        xlim(ax, [startFrame, endFrame]);
    end


% Plot zscored data for current frame with N frames before and after
    function plotData(ax, data, currentFrame, framesToShow, currentValue)
        startFrame = max(1, currentFrame - framesToShow);
        endFrame = min(length(data), currentFrame + framesToShow);
        dataWindow = data(startFrame:endFrame);
        baseline = mean(dataWindow(1:framesToShow));
        stdDev = std(dataWindow(1:framesToShow));
        zscoreData = (dataWindow - baseline) / stdDev;

        % Plot z-score transformed data
        plot(ax, startFrame:endFrame, zscoreData, 'LineWidth', 1.5);
        hold(ax, 'on');

        % Plot vertical line indicating current frame
        plot(ax, [currentFrame, currentFrame], [min(zscoreData), max(zscoreData)], 'Color',colormap(currentValue+1,:), 'LineWidth', 2);

        % Draw horizontal line at zero
        line(ax, [startFrame, endFrame], [0, 0], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);

        hold(ax, 'off');

        xlim(ax, [startFrame, endFrame]);
    end

% Plot smoothed data for current frame with N frames before and after
    function plotSmoothedData(ax, data, currentFrame, framesToShow, smoothWindow, currentValue)
        startFrame = max(1, currentFrame - framesToShow);
        endFrame = min(length(data), currentFrame + framesToShow);
        dataWindow = data(startFrame:endFrame);
        smoothedData = smoothdata(dataWindow, 'movmean', smoothWindow);
        baseline = mean(smoothedData(1:framesToShow));
        stdDev = std(smoothedData(1:framesToShow));
        zscoreData = (smoothedData - baseline) / stdDev;

        % Plot z-score transformed data
        plot(ax, startFrame:endFrame, zscoreData, 'LineWidth', 1.5);
        hold(ax, 'on');

        % Plot vertical line indicating current frame
        plot(ax, [currentFrame, currentFrame], [min(zscoreData), max(zscoreData)], 'Color',colormap(currentValue+1,:), 'LineWidth', 2);

        % Draw horizontal line at zero
        line(ax, [startFrame, endFrame], [0, 0], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);

        hold(ax, 'off');

        xlim(ax, [startFrame, endFrame]);
    end

end