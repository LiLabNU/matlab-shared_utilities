function plotStructureMatrices(structArray)
fieldNames = fieldnames(structArray);

% Determine a suitable subplot grid size (for simplicity, aiming for a square grid)
gridSize = ceil(sqrt(length(fieldNames)));

figure; % Create a new figure for the subplots

for i = 1:length(fieldNames)
    dataToPlot = [];
    fieldName = fieldNames{i};
    for j = 1:length(structArray)
        temp = structArray(j).(fieldName);
        dataToPlot = [dataToPlot temp];
    end

    subplot(gridSize, gridSize, i);
    plot(dataToPlot)
    % Optional enhancements for the subplot
    title(sprintf(fieldName), 'Interpreter', 'none'); % 'Interpreter', 'none' allows underscores in names
end
end
