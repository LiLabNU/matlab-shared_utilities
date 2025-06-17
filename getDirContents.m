function [firstLevelSubFolders, allFilePaths, allFileNames] = getDirContents(folderPath)
% Get only the FIRST-LEVEL subfolders and recursively collect all files in all levels
%
% Args:
%   folderPath (char): Root folder
%
% Returns:
%   firstLevelSubFolders (cell): Only 1st-level subfolders
%   allFilePaths (cell): Full file paths from all levels
%   allFileNames (cell): Corresponding file names only

    firstLevelSubFolders = {};
    allFilePaths = {};
    allFileNames = {};

    % First: get only 1st-level subfolders
    topEntries = dir(folderPath);
    topEntries = topEntries([topEntries.isdir] & ~ismember({topEntries.name}, {'.', '..'}));

    for i = 1:length(topEntries)
        subfolder = fullfile(folderPath, topEntries(i).name);
        firstLevelSubFolders{end+1} = subfolder;
    end

    % Now: recursive file collection from entire directory tree
    function walkDir(currentPath)
        entries = dir(currentPath);
        entries = entries(~ismember({entries.name}, {'.', '..'}));  % clean up

        for j = 1:numel(entries)
            entry = entries(j);
            entryPath = fullfile(currentPath, entry.name);
            if entry.isdir
                walkDir(entryPath);  % recurse
            else
                allFilePaths{end+1} = entryPath;
                allFileNames{end+1} = entry.name;
            end
        end
    end

    % Kick off recursive traversal
    walkDir(folderPath);
end
