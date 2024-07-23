function [R3] = sampleMap2b(A, fs)
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

    % Define a dynamic color gradient for RGB channels
    color_gradient = [0.7, 0.2, 0.9; % Purple
                      0.1, 0.6, 0.8; % Blue
                      0.8, 0.4, 0.1; % Orange
                      0.9, 0.7, 0.2]; % Yellow
    color_steps = size(color_gradient, 1);

    % Assign colors based on normalized energy levels and position within frame
    for n = 1:N
        st = 1 + (n - 1) * overlap_length; % Start index for current frame

        % Calculate timestamp influence on color
        timestamp_ratio = (n - 1) / (N - 1); % Ratio of current frame index to total frames

        % Determine RGB color based on timestamp_ratio and energy
        color_index = ceil(timestamp_ratio * color_steps); % Index in color_gradient
        if color_index < 1
            color_index = 1;
        elseif color_index > color_steps
            color_index = color_steps;
        end
        color_rgb = color_gradient(color_index, :);

        % Apply color to corresponding pixels within the frame with dynamic effects
        for i = 1:RC
            for j = 1:RC
                % Ensure pixel index does not exceed frame bounds
                if st + (i - 1) * RC + j - 1 <= length(A)
                    % Calculate intensity based on normalized energy and position within frame
                    intensity = normalized_x(n) * (i - 1) / RC;

                    % Add dynamic wave pattern effect based on audio amplitude
                    wave_amplitude = 0.1; % Adjust wave amplitude
                    wave_frequency = 5; % Adjust wave frequency
                    wave_phase_shift = pi * 2 * (st + j) / (RC * RC); % Phase shift for wave pattern

                    % Compute wave effect
                    wave_effect = wave_amplitude * sin(wave_frequency * intensity + wave_phase_shift);

                    % Combine wave effect with color intensity
                    pixel_color = intensity * color_rgb + wave_effect * [1, 1, 1];

                    % Assign the color to the corresponding pixel in the image
                    R3(i, j, :) = pixel_color;
                end
            end
        end
    end

    % Apply a dynamic textured overlay for added visual interest
    texture = repmat(linspace(0.8, 1, RC)', 1, RC); % Linear texture from top to bottom
    texture = repmat(texture, [1, 1, 3]); % Apply to all RGB channels

    % Introduce slight noise for a more dynamic appearance
    noise = randn(RC, RC, 3) * 0.05; % Small amplitude noise
    R3 = R3 .* texture + noise;

    % Enhance contrast and adjust brightness dynamically
    R3 = imadjust(R3, stretchlim(R3), []);
end