function [meanStruct,meanStruct_prop] = calculateMeansForStructArray(structArray, ignoreValues)
    % Determine the size of the input structure array
    n_elements = numel(structArray);
    
    % Check if the ignoreValues flag is set and specific values should be ignored
    if nargin < 2
        ignoreValues = false; % Default is not to ignore specific values
    end
    
    % Initialize the output structure array to have the same size and fields
    meanStruct = structArray;
    
    % Iterate through each element of the structure array
    for i = 1:n_elements
        % Get field names for the current element
        fieldNames = fieldnames(structArray(i));
        
        % Iterate through each field
        for j = 1:numel(fieldNames)
            fieldName = fieldNames{j};
            
            % Check if the field contains a matrix (numeric data)
            if isnumeric(structArray(i).(fieldName))
                % Extract the matrix
                matrix = structArray(i).(fieldName);
                
                if ignoreValues
                    % Calculate mean by ignoring specific values (0 and 30)
                    validValues = matrix(matrix ~= 0 & matrix ~= 30);
                    meanValue = mean(validValues(:)); % Mean of valid elements
                    
                    % Calculate the proportion of non 0 and non 30s
                    proportionValid = numel(validValues) / numel(matrix);
                    
                    % Assign the mean value and proportion to the corresponding field in the output structure
                    meanStruct(i).(fieldName) = meanValue;
                    meanStruct_prop(i).(['ProportionValid_' fieldName]) = proportionValid;
                else
                    % Calculate the mean of the matrix including all elements
                    meanValue = mean(matrix(:)); % Mean of all elements
                    meanStruct(i).(fieldName) = meanValue;
                end
            else
                % If the field does not contain numeric data, handle accordingly
                meanStruct(i).(fieldName) = NaN; % Placeholder value for non-numeric fields
            end
        end
    end
end
