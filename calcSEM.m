function sem = calcSEM(data)
    % Calculate the standard error of the mean (SEM) for each column of a data matrix
    % 
    % Inputs:
    %   data - An n x m matrix where each column represents a different dataset
    %          or group and each row represents an observation.
    %
    % Outputs:
    %   sem  - A 1 x m vector of SEM values for each column

    % Number of observations per group (assuming observations are rows)
    n = size(data, 1);
    
    % Standard deviation of each column
    s = std(data, 0, 1); % Normalize by N-1 (default), calculation along rows
    
    % Calculate SEM
    sem = s ./ sqrt(n);
end
