function [allSubFolders, allFilePaths, allFileNames] = getSubfolderContents(folderPath)
% Recursively gets all subfolders and files within a folder
% 
% Args:
%   folderPath (char): root folder to explore
%
% Returns:
%   allSubFolders (cell): all subfolders including nested ones
%   allFilePaths (cell): full paths to all files found
%   allFileNames (cell): corresponding file names only

    allSubFolders = {};
    allFilePaths = {};
    allFileNames = {};

    function walkDir(currentPath)
        entries = dir(currentPath);
        entries = entries(~ismember({entries.name}, {'.', '..'})); % remove . and ..

        for i = 1:numel(entries)
            fullEntryPath = fullfile(currentPath, entries(i).name);
            if entries(i).isdir
                allSubFolders{end+1} = fullEntryPath;
                walkDir(fullEntryPath);  % recursive call
            else
                allFilePaths{end+1} = fullEntryPath;
                allFileNames{end+1} = entries(i).name;
            end
        end
    end

    % Kick off recursive traversal
    walkDir(folderPath);
end
