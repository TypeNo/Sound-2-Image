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
    N = floor(length(A) / win); % Number of frames, adjust to avoid exceeding length
    x = zeros(1, N);  % Preallocate x to store energy values

    % Calculate energy of each frame
    for n = 1:N
        st = (n - 1) * win + 1; % Start index for current frame
        frame = A(st:min(st + win - 1, end)); % Ensure frame does not exceed A length
        e = Energy(frame, win);  % Calculate energy for current frame
        x(n) = e;  % Store energy value
    end

    med = mean(x);  % Calculate mean energy

    % Assign colors based on energy levels to specific pixel locations
    for i = 1:RC
        for j = 1:RC
            % Calculate energy index based on pixel location
            energy_index = sub2ind([RC, RC], i, j);
            if energy_index <= N
                if x(energy_index) < med
                    % Assign random color for lower energy levels
                    v = (0.5 - 0) .* rand(3, 1);
                else
                    % Assign random color for higher energy levels
                    v = 0.5 + (1 - 0.5) .* rand(3, 1);
                end
                % Assign the color to the corresponding pixel in the image
                R3(i, j, :) = v;
            end
        end
    end

    % Display the resulting image
    figure;
    imshow(R3);
end



