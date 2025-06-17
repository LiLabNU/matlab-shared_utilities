function [FRdetails,Sum] = findFRduration(A, B, C, fr)
% This function finds the first value from array A that is smaller than
% each value in array B.
%
% Inputs:
%   A - the first active nosepoke of each FR timestamp
%   B - Sucrose delivery timestamp or the last active nosepoke of each FR
%   C - timestamps of all active nosepoke
%   fr - fixed ratio

% Output:
%   result - A 1 x m array where each element is the first value from A
%            that is smaller than the corresponding element in B. If no
%            such value exists, return NaN for that element.

% Initialize the result array with NaNs (in case no smaller value is found)
firstCompletedFRTS = NaN(1, length(B));

% Sort A to optimize the search
A_sorted = sort(A, 'ascend');

idx = [];
% whether first FR timestamp is registered by the code
if ~isempty(A)
    for i = 1:length(B)
        % Find the indices in A_sorted where the elements are smaller than B(i)
        idx(i) = find(A_sorted < B(i), 1, 'last');
        % If any element is found that is smaller, store it
        if ~isempty(idx(i))
            firstCompletedFRTS(i) = A_sorted(idx(i));
        end
    end
else
    for i = 1:length(B)
        idx(i) = find(C < B(i), 1, 'last') - fr + 1;
        if ~isempty(idx(i)) && idx(i) > 0
            firstCompletedFRTS(i) = C(idx(i));
        end
    end

    temp = find(isnan(firstCompletedFRTS),1,'last');
    if ~isempty(temp)
        firstCompletedFRTS = firstCompletedFRTS(temp+1:end);
        B = B(temp+1:end);
        idx = idx(temp+1:end);
    end
end

firstCompletedFRTS = firstCompletedFRTS';
FRdetails.firstCompletedFRTS = firstCompletedFRTS;



FRcompletion = zeros(1,length(A));
if ~isempty(idx)
    FRcompletion(idx) = 1;
    FRcompletion = FRcompletion';
else
    FRcompletion = FRcompletion';
end
FRdetails.FRcompletion = FRcompletion;

FRDuration = B - firstCompletedFRTS;
FRdetails.FRDuration = FRDuration;
% 
% for i = 1:length(firstCompletedFRTS)
%     temp = firstCompletedFRTS(i);
%     idx = find(C==temp);
%      secondCompletedFRTS(i,:) = C(idx+1);
%      thirdCompletedFRTS(i,:) = C(idx+2);
% end




% FRdetails.secondCompletedFRTS = secondCompletedFRTS;
% FRdetails.thirdCompletedFRTS = thirdCompletedFRTS;

% -----------------------------
% Count nosepokes between rewards
% -----------------------------
nosepokesBetweenRewards = NaN(length(B), 1);

for i = 1:length(B)
    if i == 1
        % First reward: nosepokes from time 0 to B(1)
        nosepokesBetweenRewards(i) = sum(C > 0 & C < B(i));
    else
        % Subsequent rewards: nosepokes between previous and current reward
        nosepokesBetweenRewards(i) = sum(C > B(i-1) & C < B(i));
    end
end

FRdetails.nosepokesBetweenRewards = nosepokesBetweenRewards;

Sum.nosepokesBetweenRewards = mean(nosepokesBetweenRewards);
Sum.FRcompletionRatio = sum(FRcompletion==1)/length(FRcompletion);
Sum.meanFRDuration = mean(FRDuration);
end
