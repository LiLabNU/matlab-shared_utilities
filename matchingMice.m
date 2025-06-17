function [ReorderedinputMice, IndexIninputMice, keepIdx] = matchingMice(referenceMice, inputMice)
    % Trim whitespace and convert to lowercase for matching
    cleanRef = lower(strtrim(referenceMice));
    cleanInput = lower(strtrim(inputMice));

    % Find missing mice and their indices
    missingIndices = [];
    missingMice = [];
    for i = 1:length(cleanRef)
        if ~ismember(cleanRef(i), cleanInput)
            missingIndices = [missingIndices; i];
            missingMice = [missingMice; referenceMice(i)];
        end
    end


    % Compute keepIdx: indices to retain (excluding missing indices)
    keepIdx = setdiff(1:length(referenceMice), missingIndices);

    % Remove missing entries
    cleanRef(missingIndices) = [];
    referenceMice(missingIndices) = [];

    % Initialize outputs
    ReorderedinputMice = strings(size(cleanRef));
    IndexIninputMice = nan(size(cleanRef));

    % Match inputMice to referenceMice order (case- and space-insensitive)
    for i = 1:length(cleanRef)
        idx = find(cleanInput == cleanRef(i), 1); % Case-insensitive, trimmed match
        if ~isempty(idx)
            ReorderedinputMice(i) = inputMice(idx); % Preserve original casing
            IndexIninputMice(i) = idx;
        end
    end

    % Create final table
    reorderedTable = table(referenceMice, ReorderedinputMice, IndexIninputMice);
    
    % Display the result
    disp("Final reordered inputMice list:");
    disp(reorderedTable);

        % Report missing mice
    if ~isempty(missingMice)
        disp("Mice not found in inputMice:");
        disp(table(missingIndices, missingMice));
    end
end
