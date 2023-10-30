clear all; %#ok<CLALL>
close all;

%Variable setup
f = figure();
ax = axes();

%Webcam setup
cam = webcam();
cam.Resolution = '640x480';

%Flip webcam feed horizontally 
% while true
%     frame = snapshot(cam);
%     frame = frame(end:-1:1, :, :);  % Manually reverse the rows to flip vertically
%     %[imagePoints, boardSize] = detectCheckerboardPoints(frame);
%     if ishandle(ax)
%         imshow(frame, 'Parent', ax);
%         %imshow(frame, 'Colormap', ax); %Attempt to convert to GS
%     else
%         break;
%     end
% end

%delete(cam);

%% Tranform 3D point from camera coordinate frame to image coordinate frame
% px=467.00000;
% py=348.00000;
% 
% fx=1002.48314;
% fy=1004.99286;
% 
% K = [fx, 0, px;
%      0, fy, py;
%      0, 0, 1];
% 
% X_cam = [8;5;80;1];
% IM = eye(3,4);
% 
% x = K*IM*X_cam;
% 
% u = x(1)/x(3)
% v = x(2)/x(3)

%% 

% I = imread('I2.jpg');
% 
% GSI = rgb2gray(I);
% 
% kern = [-1 -1 -1;-1 8 -1;-1 -1 -1];
% 
% imgresult = convolve_with_kernal(GSI,kern);
% 
% figure(1);
% imshow(imgresult);
% title('Img result');

%% 
% while true
% 
%     frame = snapshot(cam);
% 
%     % cornerPoints = detectHarrisFeatures(cam);
%     % 
%     % imshow(cam);
%     % hold on
%     % plot(cornerPoints);
% 
%     [imagePoints, boardSize] = detectCheckerboardPoints(frame);
% end

while true
    frame = snapshot(cam);
    
    % Implement checkerboard detection and tracking here
    [imagePoints, boardSize] = detectCheckerboardPoints(frame);
    
    % Display the frame in a MATLAB figure
    imshow(frame);
    
    % Add text annotations to the frame
    positionText = 'Checkerboard Position: (x, y)';
    frame = insertText(frame, [10, 10], positionText, 'FontSize', 14, 'BoxColor', 'white', 'TextColor', 'black');
    
    % Update the displayed frame in real-time
    drawnow;
    
    % Your tracking and control code here
    X = 0;
    positionText = X;
    disp(X);
end

    
