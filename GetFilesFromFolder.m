%%%
% subfolder = 0: not selecting subfolders; = 1 selecting subfolders
% filetype: type of files you want to input. For example '.bin'
function [filelist, folderDir] = GetFilesFromFolder(subfolder, filetype, folder)
if nargin<2
    filetype = [];
    folder = uigetfolder('Please select folder containing files you want to input');
elseif nargin<3
    folder = uigetfolder('Please select folder containing files you want to input');
    filetype = string(filetype);
else
    filetype = string(filetype);
end

filelist = [];
folderDir = [];

if strcmp(folder, '')
    % User canceled
    return
end

cd(folder);



folderList = dir(folder);
% go into the folder containing 'test1' if any
for i = 1:length(folderList)

    currentName = folderList(i).name;

    if contains(currentName,"test1","IgnoreCase",true)
        folder = fullfile(folderList(i).folder,folderList(i).name);
        cd(folder);
    end
end

% Get items to recurse
folderList = dir(folder);
currentFileNum = 1;

for i = 1:length(folderList)

    currentName = folderList(i).name;

    switch subfolder
        case 0

            if folderList(i).name(1) == '.'
                % Skip the "." and ".." entries
                continue;
            end
            x = length(currentName);

            %             if x <= 5
            %                 % Reject any filename that is too short. Minimum file
            %                 % length is 5, which accounts for .mat extension, and at
            %                 % least one more character.
            %                 continue;
            %             end
            if ~isempty(filetype)
                if ~contains(string(currentName), filetype)
                    %                     Reject anything that is not a .bin file
                    continue;
                end
            end
            folderDir{currentFileNum, 1} = folder;
            filelist{currentFileNum, 1} = currentName;
            currentFileNum = currentFileNum + 1;

        case 1
            %%%%%%%% Commented portion is for getting subfolders within the folder

            if folderList(i).isdir

                % Get subfolder name
                subfoldername = folderList(i).name;

                if subfoldername(1) == '_'
                    % Skip folders starting with underscore, as these are
                    % skipped by AllReadSpikesEvents
                    continue;
                end

                %             if strcmp(subfoldername, 'raw') == 0 % strcmp returns 1 if match, 0 if not.
                %                 % We get here if subfoldername is NOT "events"
                %
                %                 % Now check if subfoldername itself has a
                %                 % subfolder named "events" and use that, if it exists.
                %                 subfoldername = strcat(subfoldername, '\raw\');
                %
                %                 if ~exist(subfoldername, 'dir')
                %                     % If events folder doesn't exist, then skip
                %                     continue;
                %                 end
                %             end

                % Loop through items in the subfolder
                filestructlist = dir([folder '\' subfoldername]);

                for j = 1:length(filestructlist)

                    currentName = filestructlist(j).name;

                    if currentName(1) == '.'
                        % Skip the "." and ".." entries
                        continue;
                    end

                    if strcmp(currentName, 'folder')
                        % Skip if this is header
                        continue;
                    end

                    x = length(currentName);

                    %                     if x <= 5
                    %                         % Reject any filename that is too short. Minimum file
                    %                         % length is 5, which accounts for .mat extension, and at
                    %                         % least one more character.
                    %                         continue;
                    %                     end
                    if ~isempty(filetype)
                        if ~contains(string(currentName), filetype)
                            %                     Reject anything that is not a .bin file
                            continue;
                        end
                    end

                    % Add this to list of files

                    folderDir{currentFileNum, 1} = [folder '\' subfoldername];
                    filelist{currentFileNum, 1} = currentName;
                    currentFileNum = currentFileNum + 1;

                end
            end
    end

end

if isempty(filelist)
    fprintf('Warning: no subfolders found in the selected folder.\n');
end
