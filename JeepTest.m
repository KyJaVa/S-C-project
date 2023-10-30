clear all;
close all;

% Webcam setup
cam = webcam();
cam.Resolution = '320x240';

while true
    frame = snapshot(cam);
    frame = rgb2gray(frame);
    
    % Implement checkerboard detection and tracking here
    [imagePoints, boardSize] = detectCheckerboardPoints(frame);
    cornerPoints = detectHarrisFeatures(frame, 'MinQuality', 0.3);

    if ~isempty(imagePoints)
        % Calculate the center of the checkerboard
        center_x = mean(imagePoints(:, 1));
        center_y = mean(imagePoints(:, 2));

        % Calculate the centroid (center) of the checkerboard
        centroid = mean(imagePoints);
    
        % Subtract the centroid from all corner points to get relative positions
        centeredPoints = imagePoints - centroid;

        % Compute the covariance matrix of the centered points
        covMatrix = centeredPoints' * centeredPoints / (size(centeredPoints, 1) - 1);
        
        % Calculate the principal components (eigenvectors) of the covariance matrix
        [V, D] = eig(covMatrix);
        
        % Extract the major and minor axes (eigenvalues) from the diagonal of D
        majorAxisLength = sqrt(D(1, 1));
        minorAxisLength = sqrt(D(2, 2));
        
        % Calculate the orientation of the checkerboard
        orientation = atan2(V(1, 2), V(1, 1));
        
        % Convert orientation from radians to degrees
        orientation_deg = orientation * 180 / pi;
        
        % Calculate the rotation of the checkerboard
        rotation = atan2(V(2, 2), V(2, 1));
        
        % Convert rotation from radians to degrees
        rotation_deg = rotation * 180 / pi;

        % disp(['Orientation: ' num2str(orientation_deg) ' degrees']);
        % disp(['Rotation: ' num2str(rotation_deg) ' degrees']);

        positionText = sprintf('Checkerboard Position: (%.1f, %.1f)\nOrientation: %.1f degrees\nRotation: %.1f degrees', center_x, center_y, orientation_deg, rotation_deg);
        annotatedFrame = insertText(frame, [10, 10], positionText, 'FontSize', 14, 'BoxColor', 'white', 'TextColor', 'black');
        
        imshow(annotatedFrame);
        hold on;
        plot(cornerPoints);
        hold off;
    else
        disp('Checkerboard not found.');
    end
    
    clf;
end