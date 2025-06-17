function [concatenatedFrames, behaviorLabels] = concatenateBroisFrames(data, frameRateAdjustment)
    % Check if frameRateAdjustment is provided
    if nargin < 2
        frameRateAdjustment = 1; % No adjustment by default
    end

    % Find all unique behaviors
    uniqueBehaviors = unique(data.Behavior);
    
    % Initialize concatenatedFrames and behaviorLabels
    concatenatedFrames = zeros(1, ceil(max(data.ImageIndexStop) / frameRateAdjustment));

    for i = 1:length(uniqueBehaviors)
        behavior = uniqueBehaviors{i};
        % Find rows corresponding to the current behavior
        indices = strcmp(data.Behavior, behavior);

        % Extract and concatenate frame ranges for this behavior
        frames = [];
        for j = find(indices)'
            startFrame = data{j, 'ImageIndexStart'} / frameRateAdjustment;
            stopFrame = data{j, 'ImageIndexStop'} / frameRateAdjustment;
            frames = [frames, startFrame:stopFrame]; % Concatenate frame range
        end

        % Remove duplicates and sort the frames (optional but recommended)
        frames = unique(frames);

        % Label the frames with the behavior index
        concatenatedFrames(unique(ceil(frames))) = i;
        behaviorLabels(i) = string(uniqueBehaviors{i});
    end
end
