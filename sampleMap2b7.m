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

    % Calculate the number of frames based on fs
    N = ceil(length(A) / fs); % Number of frames, adjusted to fit within A
    x = zeros(1, N);  % Preallocate x to store energy values

    % Calculate energy of each frame
    for n = 1:N
        st = (n - 1) * fs + 1; % Start index for current frame
        frame = A(st:min(st + fs - 1 -1, end)); % Ensure frame does not exceed A length
        e = Energy(frame, fs);  % Calculate energy for current frame
        x(n) = e;  % Store energy value
    end

    % Normalize energy levels to [0, 1] for color assignment
    min_x = min(x);
    max_x = max(x);
    normalized_x = (x - min_x) / (max_x - min_x);

    % Assign colors based on normalized energy levels and position within frame
    frame_idx = 1;
    for i = 1:RC
        for j = 1:RC
            % Ensure frame_idx does not exceed the number of frames
            if frame_idx <= N
                % Calculate position within current frame segment
                pos_in_frame = mod((i-1) * RC + j - 1, fs) + 1; % Position within fs pixels

                % Calculate color intensity based on energy and position within frame
                intensity = normalized_x(frame_idx) * pos_in_frame / fs;

                % Calculate timestamp influence on color
                timestamp_ratio = (frame_idx - 1) / N; % Ratio of current frame index to total frames
                hue_value = mod(timestamp_ratio * intensity, 1); % Combined influence of timestamp and intensity

                % Assign HSV color based on hue_value
                color_hsv = [hue_value, 1, 1]; % Full saturation and value
                color_rgb = hsv2rgb(color_hsv);

                % Assign the color to the corresponding pixel in the image
                R3(i, j, :) = intensity * color_rgb;

                % Move to the next frame every fs pixels
                if mod((i-1) * RC + j, fs) == 0
                    frame_idx = frame_idx + 1;
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
