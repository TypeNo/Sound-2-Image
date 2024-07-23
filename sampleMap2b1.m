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

    % Calculate window size for energy calculation based on the square root of fs
    win = floor(sqrt(fs)); 
    N = floor(length(A) / win); % Number of frames, adjusted to fit within A
    x = zeros(1, N);  % Preallocate x to store energy values

    % Calculate energy of each frame
    for n = 1:N
        st = (n - 1) * win + 1; % Start index for current frame
        frame = A(st:min(st + win - 1, end)); % Ensure frame does not exceed A length
        e = Energy(frame, win);  % Calculate energy for current frame
        x(n) = e;  % Store energy value
    end

    % Normalize energy levels to [0, 1] for color assignment
    min_x = min(x);
    max_x = max(x);
    normalized_x = (x - min_x) / (max_x - min_x);

    % Assign colors based on normalized energy levels to specific pixel locations
    for i = 1:RC
        for j = 1:RC
            % Calculate energy index based on pixel location
            energy_index = (i-1) * RC + j;
            if energy_index <= N
                % Assign color based on normalized energy level
                intensity = normalized_x(energy_index);
                R3(i, j, :) = intensity * [1, 0, 0];  % Red shade for visualization
            end
        end
    end

    % Display the resulting image
    figure;
    imshow(R3);
    title('Energy Levels Mapped to Image');

    % Overlay the sampling frames
    figure;
    imshow(R3);
    hold on;
    for n = 1:N
        st = (n - 1) * win + 1; % Start index for current frame
        [row, col] = ind2sub([RC, RC], st);
        rectangle('Position', [col, row, win, win], 'EdgeColor', 'b', 'LineWidth', 1);
    end
    hold off;
    title('Sampling Frames Overlay');
end

function e = Energy(frame, win)
    % Function to calculate energy of a signal frame
    e = sum(frame.^2) / win;
end

