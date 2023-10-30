clear all;
close all;
f1 = figure('Position', [100, 100, 750, 500]);
ax1 = axes();
h1 = annotation('textbox', [0.8, 0.1, 0.1, 0.1], 'String', '');
h2 = annotation('textbox', [0.8, 0.2, 0.1, 0.1], 'String', '');
h3 = annotation('textbox', [0.8, 0.3, 0.1, 0.1], 'String', '');
h4 = annotation('textbox', [0.8, 0.4, 0.1, 0.1], 'String', '');
h5 = annotation('textbox', [0.8, 0.5, 0.1, 0.1], 'String', '');
h6 = annotation('textbox', [0.8, 0.6, 0.1, 0.1], 'String', '');
f2 = figure;
ax2 = axes();

 
 
focal_length = [367.47199, 366.67233];
principal_point = [249.69163, 154.31907];
image_size = [494, 333];
z = 0.1;
% a = (Cu, Cv, fx, fy)
a = [principal_point(1), principal_point(2), focal_length(1), focal_length(2)];
 
m_star = [240 170 240 50 100 50 100 170]';
s_star = calculate_s(m_star, a);
L_s = calculate_L_s(s_star, z);
lambda = 5;
mean_error = 0;
v_c = zeros(6,1);
current_error = 0;
 
cam = webcam();
cam.Resolution = '320x240';
 
 
 
i = 1;

while true
   try
       current_frame = snapshot(cam);
       current_frame_grayscale = rgb2gray(current_frame);
       [cornerPoints, boardSize] = detectCheckerboardPoints(current_frame_grayscale);
       
       if ~isempty(cornerPoints) & isfinite(cornerPoints) & isequal(boardSize(1), 6) & isequal(boardSize(2), 7)
        board_corner_points = get_board_corner_points(cornerPoints);
        current_s = calculate_s(board_corner_points, a);
        current_error = current_s - s_star;
        current_L_s = calculate_L_s(current_s, z);
        inverse_L_s = pinv(current_L_s);
        v_c = -lambda * (inverse_L_s) * current_error;
        mean_error = mean(current_error(:,1))

 
        hold on;
        % draw things on image
        current_frame_grayscale = insertShape(current_frame_grayscale, 'Line', [ ...
            board_corner_points(1:2)', board_corner_points(3:4)'; ...
            board_corner_points(3:4)', board_corner_points(5:6)'; ...
            board_corner_points(5:6)', board_corner_points(7:8)'; ...
            board_corner_points(1:2)', board_corner_points(7:8)' ...
            ]);
 
        current_frame_grayscale = insertText(current_frame_grayscale, [ ...
            board_corner_points(1:2), ...
            board_corner_points(3:4), ...
            board_corner_points(5:6), ...
            board_corner_points(7:8)]', 1:4);
        line_coords = draw_arrow(v_c, board_corner_points);
        current_frame_grayscale = insertShape(current_frame_grayscale, 'Line', [ ...
           line_coords(1:2), line_coords(3:4); ...
         ]);
        hold off;
       else
           %disp("No board detected");
       end
   catch ME
       disp("oh no")
   end
    % rethrow(ME)

  current_frame_grayscale = insertShape(current_frame_grayscale, 'Line', [ ...
            m_star(1:2)', m_star(3:4)'; ...
            m_star(3:4)', m_star(5:6)'; ...
            m_star(5:6)', m_star(7:8)'; ...
            m_star(1:2)', m_star(7:8)'], ...
    'Color', 'w' ...
  );

  current_frame_grayscale = insertText(current_frame_grayscale, [ ...
            m_star(1:2), ...
            m_star(3:4), ...
            m_star(5:6), ...
            m_star(7:8)]', 1:4);
 
  positionText = sprintf('Distance from desired position: (%.2f)', mean_error);
  annotatedFrame = insertText(current_frame_grayscale, [10, 10], positionText, 'FontSize', 14, 'BoxColor', 'white', 'TextColor', 'black');
  
  figure(1);
  hold on;
  set(h6, 'String', "v_c_x " + v_c(1));
  set(h5, 'String', "v_c_y " + v_c(2));
  set(h4, 'String', "v_c_z " + v_c(3));
  set(h3, 'String', "w_c_x " + v_c(4));
  set(h2, 'String', "w_c_y " + v_c(5));
  set(h1, 'String', "w_c_z " + v_c(6));
  imshow(annotatedFrame);
  hold off;

  % clf;
 
  figure(2);
  title("Error");
  hold on
  plot(i, current_error,'k.');
  hold off;

  % imshow(annotatedFrame);
  % hold on;
  % plot(cornerPoints);
  % hold off;

  % clf(f1);
  i = i+1;
end
 
 
function board_corner_points = get_board_corner_points(cornerPoints)
  board_corner_points = zeros(8, 1);
%x coords
  board_corner_points(1) = cornerPoints(1, 1);
  board_corner_points(3) = cornerPoints(5, 1);
  board_corner_points(5) = cornerPoints(30, 1);
  board_corner_points(7) = cornerPoints(26, 1);
%y coords
  board_corner_points(2) = cornerPoints(1, 2);
  board_corner_points(4) = cornerPoints(5, 2);
  board_corner_points(6) = cornerPoints(30, 2);
  board_corner_points(8) = cornerPoints(26, 2);
end
 
 
function s = calculate_s(m, a)
 
%xx = (x, y)
%a = [Cu, Cv, f, alpha]
%our a = [Cu, Cv, fx, fy]
% x = (u - Cu)/fx
% y = (v - Cv)/fy
% m = (u, v)
    s = zeros(numel(m),1);
    
    
     for i = 1:size(m, 1)/2
         s(2*i - 1) = (m(2*i - 1) - a(1))/a(3);
         s(2*i) = (m(2*i) - a(2))/a(4);
     end
 
end
 
 
function L_s = calculate_L_s(s, z)
    L_s = zeros(size(s,1), 6);
 
    for i = 1:size(s, 1)/2
        x = s(2*i - 1, 1);
        y = s(2*i, 1);
 
        L_s(2*i - 1, :) = [-1/z, 0, x/z, x*y, -(1 + x^2), y];
        L_s(2*i, :) = [0, -1/z, y/z, (1 + y^2), -x*y, -x];
 
    end
 
end

 
function line_coords = draw_arrow(v_c, board_corner_points)
   v_c_x = v_c(1);
   v_c_y = v_c(2);
   center_board_x_coord = (board_corner_points(1) + board_corner_points(3) + board_corner_points(5) + board_corner_points(7))/4;
   center_board_y_coord = (board_corner_points(2) +  board_corner_points(6) + board_corner_points(4) + board_corner_points(8))/4;
 
   line_coords = [center_board_x_coord, center_board_y_coord, center_board_x_coord + (v_c_x*1000), center_board_y_coord + (v_c_y*1000)];
 
end