function newCellArray = removeEmptyCells(cellArray)
    newCellArray = cellArray(~cellfun('isempty', cellArray));
end
