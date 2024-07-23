function [R3] = sampleMap2b4(A, fs)
    % Calculate corresponding image size RC*RC
    RC = floor(sqrt(length(A)));   
    minA = min(A(:));  % Find minimum value in A (assuming A is a vector)
    maxA = max(A(:));  % Find maximum value in A (assuming A is a vector)

    B1 = A(1:RC^2);  % Extract first RC^2 elements of A (1D representation)

    % Map values in B1 to the range [0, 255]
    B = floor((0 + ((B1 - minA) * 255) / (maxA - minA)));  

    % Reshape B into RCxRC image
    R = reshape(B, [RC, RC]);

    % Initialize R3 as an RGB image based on R
    R3 = zeros(RC, RC, 3);

    % Calculate the number of frames based on fs and overlap
    frame_length = fs; % Frame length
    overlap_ratio = 0.5; % Overlap ratio (adjust as needed)
    overlap_length = round(frame_length * overlap_ratio); % Overlap length
    N = ceil((length(A) - frame_length + overlap_length) / overlap_length); % Number of frames

    x = zeros(1, N);  % Preallocate x to store energy values

    % Calculate energy of each frame with overlap
    for n = 1:N
        st = 1 + (n - 1) * overlap_length; % Start index for current frame
        frame = A(st:min(st + frame_length - 1, end)); % Ensure frame does not exceed A length
        e = Energy(frame, frame_length);  % Calculate energy for current frame
        x(n) = e;  % Store energy value
    end

    % Normalize energy levels to [0, 1] for color assignment
    min_x = min(x);
    max_x = max(x);
    normalized_x = (x - min_x) / (max_x - min_x);

    % Assign colors based on normalized energy levels and position within frame
    for n = 1:N
        st = 1 + (n - 1) * overlap_length; % Start index for current frame

        % Calculate timestamp influence on color
        timestamp_ratio = (n - 1) / (N - 1); % Ratio of current frame index to total frames

        % Assign HSV color based on timestamp_ratio and energy
        hue_value = mod(timestamp_ratio + normalized_x(n), 1); % Combined influence of timestamp and energy
        color_hsv = [hue_value, 1, 1]; % Full saturation and value
        color_rgb = hsv2rgb(color_hsv);

        % Apply color to corresponding pixels within the frame
        for i = 1:RC
            for j = 1:RC
                % Ensure pixel index does not exceed frame bounds
                if st + (i - 1) * RC + j - 1 <= length(A)
                    % Calculate intensity based on normalized energy and position within frame
                    intensity = normalized_x(n) * (i - 1) / RC;

                    % Assign the color to the corresponding pixel in the image
                    R3(i, j, :) = intensity * color_rgb;
                end
            end
        end
    end

    % Overlay complex patterns based on energy
    pattern = repmat(linspace(0, 1, RC)', 1, RC) .^ 2; % Quadratic pattern
    pattern = repmat(pattern, [1, 1, 3]); % Apply to all RGB channels
    R3 = R3 .* pattern;

    % Adjust brightness and contrast dynamically
    R3 = imadjust(R3, stretchlim(R3), []);

    % Display the resulting image
    figure;
    imshow(R3);
end

function e = Energy(frame, win)
    % Function to calculate energy of a signal frame
    e = sum(frame.^2) / win;
end
