clear all;
close all;

%Variable setup
f = figure();
ax = axes();

%Webcam setup
cam = webcam();
cam.Resolution = '640x480';

%Flip webcam feed horizontally 
while true
    frame = snapshot(cam);
    frame = frame(end:-1:1, :, :);  % Manually reverse the rows to flip vertically
    %[imagePoints, boardSize] = detectCheckerboardPoints(frame);
    if ishandle(ax)
        imshow(frame, 'Parent', ax);
    else
        break;
    end
end

delete(cam);

%% Tranform 3D point from camera coordinate frame to image coordinate frame
px=467.00000;
py=348.00000;

fx=1002.48314;
fy=1004.99286;

K = [fx, 0, px;
     0, fy, py;
     0, 0, 1];

X_cam = [8;5;80;1];
IM = eye(3,4);

x = K*IM*X_cam;

u = x(1)/x(3)
v = x(2)/x(3)

%% 

I = imread('I2.jpg');

GSI = rgb2gray(I);

kern = [-1 -1 -1;-1 8 -1;-1 -1 -1];

imgresult = convolve_with_kernal(GSI,kern);

figure(1);
imshow(imgresult);
title('Img result');