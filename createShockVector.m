function vec = createShockVector(x, n, m, y)
% Initialize the vector with zeros
    vec = zeros(1, n);
    
    % Set the first element to x
    vec(1) = x;
    
    % Loop through the vector to assign values
    for i = 2:n       
        if mod(i-1, y) == 0
            vec(i) = vec(i-1) * m;  % Multiply by m every y elements
        else
            vec(i) = vec(i-1);  % Otherwise, carry forward the last value
        end
    end
end
