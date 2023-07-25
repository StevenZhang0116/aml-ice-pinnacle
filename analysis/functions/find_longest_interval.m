%--------------------------------------------------------------------------
% To find the longest interval of indices where the range of corresponding Y-values 
% is smaller than a certain value [threshold]
%
% Steven Zhang, Courant Institute
% Updated Jul Mar 2023
%--------------------------------------------------------------------------

function [start_idx, end_idx] = find_longest_interval(XY, threshold)
    % Extract X and Y from the input 2D array
    X = XY(:, 1);
    Y = XY(:, 2);

    % Initialize variables to store the longest interval
    start_idx = 1;
    end_idx = 1;
    current_start_idx = 1;
    current_end_idx = 1;
    max_interval_length = 0;

    % Iterate through Y to find the longest interval
    for i = 2:length(Y)
        if abs(max(Y(current_start_idx:i)) - min(Y(current_start_idx:i))) <= threshold
            current_end_idx = i;
        else
            current_interval_length = current_end_idx - current_start_idx + 1;
            if current_interval_length > max_interval_length
                max_interval_length = current_interval_length;
                start_idx = current_start_idx;
                end_idx = current_end_idx;
            end
            current_start_idx = i;
            current_end_idx = i;
        end
    end

    % Check if the last interval is the longest
    current_interval_length = current_end_idx - current_start_idx + 1;
    if current_interval_length > max_interval_length
        max_interval_length = current_interval_length;
        start_idx = current_start_idx;
        end_idx = current_end_idx;
    end
end



