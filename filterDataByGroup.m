function result = filterDataByGroup(dataCurr, groups)
    % Check if dataCurr is a cell array
    if iscell(dataCurr)
        % Initialize the result cell array to the same size as dataCurr for cell array input
        result = cell(size(dataCurr));

        % Loop through dataCurr
        for i = 1:numel(dataCurr)
            if ~isempty(dataCurr{i})
                % Apply the condition and function only if the cell is not empty
                result{i} = dataCurr{i}(groups == 1, :);
            else
                % If the cell is empty, keep it empty in the result
                result{i} = [];
            end
        end
    elseif ismatrix(dataCurr) % Check if dataCurr is a matrix
        % For matrix input, apply the condition directly without looping
        if ~isempty(dataCurr)
            result = dataCurr(groups == 1, :);
        else
            result = [];
        end
    else
        % Handle unexpected data types
        error('Unsupported data type. Input must be a cell array or a matrix.');
    end
end
