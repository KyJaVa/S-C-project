clear all;
close all;
f = figure();
ax = axes();

cam = webcam();
cam.Resolution = '320x240';
x = 1;


while true
   current_frame = snapshot(cam);
   current_frame_grayscale = rgb2gray(current_frame);

   [cornerPoints, boardSize] = detectCheckerboardPoints(current_frame_grayscale);
   if isempty(cornerPoints)
    imshow(current_frame_grayscale)
    disp('no checkerboard')
   else
    hold on;
    current_frame_grayscale = insertMarker(current_frame_grayscale, cornerPoints, 'o', 'Size', 10);
    imshow(current_frame_grayscale);
    boardSize
    hold off;
   end
end
