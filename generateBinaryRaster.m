 
function binaryArray = generateBinaryRaster(activeTS, time, N)

% To find values from the activeTS array that fall within the range of the time array 
% and then match each value to the closest value in the time array to generate a binary array of Nx1
if nargin < 3
    binaryArray = zeros(length(time), 1);
else
    binaryArray = zeros(N, 1);
end

% Loop through each value in activeTS
for i = 1:length(activeTS)
    % Only consider values within the range of the 'time' array
    if activeTS(i) >= min(time) && activeTS(i) <= max(time)
        % Find the index of the closest value in 'time' to the current 'activeTS' value
        [~, idx] = min(abs(time - activeTS(i)));

        % Set the corresponding value in the binary array to 1
        binaryArray(idx) = 1;
    end
end
end