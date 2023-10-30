clear all;
close all;

%Webcam setup
cam = webcam();
cam.Resolution = '320x240';

while true
    frame = snapshot(cam);
    frame = rgb2gray(frame);
    
    % Implement checkerboard detection and tracking here
    [imagePoints, boardSize] = detectCheckerboardPoints(frame);
    cornerPoints = detectHarrisFeatures(frame, 'MinQuality',0.4);

    if ~isempty(imagePoints)
        % Calculate the center of the checkerboard
        center_x = mean(imagePoints(:, 1));
        center_y = mean(imagePoints(:, 2));

        positionText = sprintf('Checkerboard Position: (%.1f, %.1f)', center_x, center_y);
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