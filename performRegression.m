function predicted_ph_sig = performRegression(ph_ref, ph_sig, baseline_indices, figures)

% Extract baseline data
if isempty(baseline_indices)
    baseline_ph_ref = ph_ref;
    baseline_ph_sig = ph_sig;
else
    baseline_ph_ref = ph_ref(baseline_indices);
    baseline_ph_sig = ph_sig(baseline_indices);
end


% Perform linear regression: y = bx + a
if size(baseline_ph_ref,2)~=1
    baseline_ph_ref = baseline_ph_ref';
end

if size(baseline_ph_sig,2)~=1
    baseline_ph_sig = baseline_ph_sig';
end
p = regress(baseline_ph_sig,[ones(size(baseline_ph_ref)),baseline_ph_ref]);
% Apply the linear model to the entire sig signal
predicted_ph_sig =ph_sig./(ph_ref*p(2)+p(1));



if nargin == 4
    % Optionally, plot actual vs. predicted for visualization
    figure;
    subplot(1,2,1)
    plot(ph_sig, 'b', 'DisplayName', 'Actual ph_sig');
    xlabel('Sample');
    ylabel('Signal Amplitude');
    subplot(1,2,2)
    plot(predicted_ph_sig, 'r', 'DisplayName', ['Predicted ph_sig (Linear Regression)']);
    xlabel('Sample');
    ylabel('Signal Amplitude');

end
end
