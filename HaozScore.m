function [zScore] = HaozScore(Input, BaselineWindow)
    % Function to calculate the z-score of input data relative to a baseline window.
    % Handles 3D data by looping through the 3rd dimension.
    %
    % Inputs:
    %   Input - 2D or 3D matrix of data (rows x columns x slices)
    %   BaselineWindow - Vector specifying the baseline window indices
    %
    % Output:
    %   zScore - z-scored data of the same size as Input

    % Initialize zScore with the same size as Input
    zScore = zeros(size(Input));
    
    % Determine baseline range
    if length(BaselineWindow) > 2
        bs = [BaselineWindow(1) BaselineWindow(end)];
    else
        bs = BaselineWindow;
    end

    % Loop through the 3rd dimension (if applicable)
    for z = 1:size(Input, 3)
        % Process each slice independently
        for r = 1:size(Input, 1)
            % Extract the baseline data for the current row and slice
            Baseline = Input(r, bs(1):bs(2), z);
            if all(Baseline == 0)
                % If baseline is all zeros, assign zeros for the z-score
                zScore(r, :, z) = zeros(1, size(Input, 2));
            else
                % Calculate mean and standard deviation of the baseline
                mean_base = mean(Baseline);
                std_base = std(Baseline);
                % Calculate z-score for each time point
                for t = 1:size(Input, 2)
                    zScore(r, t, z) = (Input(r, t, z) - mean_base) / std_base;
                end
            end
        end
    end
end
