function [resultsMatrix, summaryStats] = findBouts(data, minGap, sucTS, mouse, type, shkTS)
% FINDBOUTS Calculates bout details from binary data and computes summary statistics.
%
%   [resultsMatrix, summaryStats] = findBouts(data, minGap, sucTS, mouse, type)
%
%   Inputs:
%       data            - Binary vector (0/1) indicating port entry PE.
%       minGap          - Minimum gap (in data points) between bouts.
%       sucTS           - Timestamps Sucrose delivery.
%       shkTS           - Timestamps Shock delivery.
%       mouse           - Mouse identifier (string, optional; default: 'Unknown').
%       type            - Summary type: 'mean' or 'median' (optional; default: 'mean').
%
%   Outputs:
%       resultsMatrix   - Structure with fields (each as a column vector) containing bout details.
%       summaryStats    - Structure with summary statistics computed from bout data.
%
%   Example:
%       [resMat, stats] = findBouts(data, 10, sucTS, 'Mouse01', 'mean');

%% Input Validation and Default Parameters
if nargin < 3 || isempty(sucTS)
    sucTS = [];
end
if nargin < 4 || isempty(mouse)
    mouse = 'Unknown';
end
if nargin < 5 || isempty(type)
    type = 'mean';
end

% Check that data is a binary vector
if ~isvector(data) || ~all(ismember(data, [0, 1]))
    error('Data must be a binary vector containing only 0s and 1s.');
end

%% Ensure data ends with a zero for proper edge-case handling
if data(end) == 1
    data(end+1) = 0;
end

%% Detect Bout Transitions
% Find indices where data changes state (0->1 or 1->0)
PE = find(data == 1);
changes = find(diff([0, data]) ~= 0);
if mod(numel(changes), 2) ~= 0
    error('Unexpected number of state transitions detected.');
end
starts = changes(1:2:end);
ends = changes(2:2:end) - 1;
durations = ends - starts + 1;

%% Filter Out Bouts Too Close Together
if numel(starts) > 1
    validBouts = [true, (starts(2:end) - ends(1:end-1) - 1) >= minGap];
else
    validBouts = true;
end
starts = starts(validBouts);
PEDurations = durations(validBouts);

%% Initialize Results Structure for Each Event Timestamp
numEvents = length(sucTS);
results = repmat(struct(...
    'eventTime', [], ...
    'firstPEOnset', [], ...
    'firstPEDuration', [], ...
    'firstPELatency', [], ...
    'numberOfInterSucrosePEs', [], ...
    'interSucrosePEDuration', [], ...
    'interSucroseITI', []), numEvents, 1);

% Preallocate arrays for summary calculations
allfirstPEDurations = [];
allFirstPELatencies = [];
allNumberOfInterSucrosePEs = [];
allInterSucrosePEDurations = [];
allShockToPELatencies = [];
%% Compute Inter-Event Intervals (ITIs)
if ~isempty(sucTS)
    interSucroseITIs = diff([1; sucTS]);
else
    interSucroseITIs = [];
end

%% Calculate Bout Details Relative to Each Event Timestamp
for j = 1:numEvents
    currentEventTime = sucTS(j);
    % Find the first bout that occurs after the current event time
    idx = find(starts >= currentEventTime, 1, 'first');
    if ~isempty(idx)
        results(j).eventTime = currentEventTime;
        results(j).firstPEOnset = starts(idx);
        results(j).firstPEDuration = PEDurations(idx);
        results(j).firstPELatency = starts(idx) - currentEventTime;
        allfirstPEDurations(end+1) = PEDurations(idx);
        allFirstPELatencies(end+1) = starts(idx) - currentEventTime;
    end

    % Count bouts within the inter-event interval (if available)
    if ~isempty(interSucroseITIs)
        interSucroseIndices = starts > currentEventTime & starts < (currentEventTime + interSucroseITIs(j));
        results(j).numberOfInterSucrosePEs = sum(interSucroseIndices);
        results(j).interSucrosePEDuration = sum(PEDurations(interSucroseIndices));
        results(j).interSucroseITI = interSucroseITIs(j);
        allNumberOfInterSucrosePEs(end+1) = results(j).numberOfInterSucrosePEs;
        allInterSucrosePEDurations(end+1) = results(j).interSucrosePEDuration;     
    else
        results(j).numberOfInterSucrosePEs = 0;
        results(j).interSucrosePEDuration = 0;
        results(j).interSucroseITI = NaN;
    end

%     if ~isempty(shkTS)
%         if j>1
%         currentShkIdx = find(shkTS > currentEventTime) && find(sucTS(j+1) > shkTS)
%         , 1 ,'first');
%         if 
% 
%         % Compute latency from most recent shock to next PE bout
%         currentEventTime = shkTS(j);
%         nextBoutIdx = find(starts > currentEventTime, 1, 'first');
%         if ~isempty(nextBoutIdx)
%             results(j).LatencyBetweenShockToPE = starts(nextBoutIdx) - currentEventTime;
%         else
%             results(j).LatencyBetweenShockToPE = 6000;
%         end
% 
%     else
%         results(j).LatencyBetweenShockToPE = 0;
%     end
end
% allShockToPELatencies = [results.LatencyBetweenShockToPE];
%% Compute Summary Statistics
switch lower(type)
    case 'mean'
        summaryStats = struct(...
            'mouseID', mouse, ...
            'totalBoutNumber', numel(starts), ...
            'meanfirstPEDuration', mean(allfirstPEDurations), ...
            'meanfirstPELatency', mean(allFirstPELatencies), ...
            'meannumberOfInterSucrosePEs', mean(allNumberOfInterSucrosePEs), ...
            'meaninterSucrosePEDuration', mean(allInterSucrosePEDurations), ...
            'meanInterSucroseITI', mean(interSucroseITIs));
    case 'median'
        summaryStats = struct(...
            'mouseID', mouse, ...
            'totalBoutNumber', numel(starts), ...
            'medianfirstPEDuration', median(allfirstPEDurations), ...
            'medianfirstPELatency', median(allFirstPELatencies), ...
            'mediannumberOfInterSucrosePEs', median(allNumberOfInterSucrosePEs), ...
            'meaninterSucrosePEDuration', median(allInterSucrosePEDurations), ...
            'meanInterSucroseITI', median(interSucroseITIs));
    otherwise
        warning('Type must be either "mean" or "median". Defaulting to "mean".');
        summaryStats = struct(...
            'mouseID', mouse, ...
            'totalBoutNumber', numel(starts), ...
            'meanfirstPEDuration', mean(allfirstPEDurations), ...
            'meanfirstPELatency', mean(allFirstPELatencies), ...
            'meannumberOfInterSucrosePEs', mean(allNumberOfInterSucrosePEs), ...
            'meaninterSucrosePEDuration', mean(allInterSucrosePEDurations), ...
            'meanInterSucroseITI', mean(interSucroseITIs));
end

%% Convert Results Structure to a Matrix of Column Vectors
resultsMatrix = struct();
resultsMatrix.eventTime = zeros(numEvents, 1);
resultsMatrix.firstPEOnset = zeros(numEvents, 1);
resultsMatrix.firstPEDuration = zeros(numEvents, 1);
resultsMatrix.firstPELatency = zeros(numEvents, 1);
resultsMatrix.numberOfInterSucrosePEs = zeros(numEvents, 1);
resultsMatrix.interSucrosePEDuration = zeros(numEvents, 1);
resultsMatrix.interSucroseITI = zeros(numEvents, 1);
resultsMatrix.LatencyBetweenShockToPE = zeros(numEvents, 1);


for j = 1:numEvents
    if ~isempty(results(j).eventTime)
        resultsMatrix.eventTime(j) = results(j).eventTime;
    end
    if ~isempty(results(j).firstPEOnset)
        resultsMatrix.firstPEOnset(j) = results(j).firstPEOnset;
    end
    if ~isempty(results(j).firstPEDuration)
        resultsMatrix.firstPEDuration(j) = results(j).firstPEDuration;
    end
    if ~isempty(results(j).firstPELatency)
        resultsMatrix.firstPELatency(j) = results(j).firstPELatency;
    end
    if ~isempty(results(j).numberOfInterSucrosePEs)
        resultsMatrix.numberOfInterSucrosePEs(j) = results(j).numberOfInterSucrosePEs;
    end
    if ~isempty(results(j).interSucrosePEDuration)
        resultsMatrix.interSucrosePEDuration(j) = results(j).interSucrosePEDuration;
    end
    if ~isempty(results(j).interSucroseITI)
        resultsMatrix.interSucroseITI(j) = results(j).interSucroseITI;
    end
%     if ~isempty(results(j).LatencyBetweenShockToPE)
%         resultsMatrix.LatencyBetweenShockToPE(j) = results(j).LatencyBetweenShockToPE;
%     end

end
end
