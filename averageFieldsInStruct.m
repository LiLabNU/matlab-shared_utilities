function reducedStruct = averageFieldsInStruct(structArray, groupSize)
    n_structs = numel(structArray);
    reducedSize = n_structs / groupSize;
    if mod(n_structs, groupSize) ~= 0
        error('The total number of structures is not evenly divisible by the group size.');
    end
    
    % Initialize the reduced structure
    reducedStruct = repmat(struct(), reducedSize, 1);
    
    % Loop through each group of 5
    for i = 1:reducedSize
        startIdx = (i - 1) * groupSize + 1;
        endIdx = i * groupSize;
        
        % Aggregate structures in this group
        for j = startIdx:endIdx
            fieldNames = fieldnames(structArray(j));
            for k = 1:length(fieldNames)
                fieldName = fieldNames{k};
                if j == startIdx
                    % Initialize accumulation with the first structure in the group
                    reducedStruct(i).(fieldName) = structArray(j).(fieldName);
                else
                    % Accumulate the rest
                    reducedStruct(i).(fieldName) = reducedStruct(i).(fieldName) + structArray(j).(fieldName);
                end
            end
        end
        
        % Divide by groupSize to get the average
        for fieldName = fieldNames'
            reducedStruct(i).(fieldName{1}) = reducedStruct(i).(fieldName{1}) / groupSize;
        end
    end
end
