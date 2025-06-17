function newStructArray = convertStruct(originalStruct)
    % Get all field names of the original structure
    fields = fieldnames(originalStruct); 
    % Assuming all fields have the same number of cells
    n = numel(originalStruct.(fields{1})); 

    % Preallocate the resulting structure array
    newStructArray(n, 1) = struct();

    % Populate the new structure array
    for i = 1:n
        for j = 1:length(fields)
            fieldName = fields{j};
            % Assign the value from the original cell array to the new structure
            newStructArray(i).(fieldName) = originalStruct.(fieldName){i};
        end
    end
end
