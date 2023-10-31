clear all;
close all;
%% Initialisations of variables and objects

% init figure 1 and axes
f1 = figure('Position', [100, 100, 750, 500]);
ax1 = axes();
% figure 1 annotation handles
h1 = annotation('textbox', [0.8, 0.1, 0.1, 0.1], 'String', '');
h2 = annotation('textbox', [0.8, 0.2, 0.1, 0.1], 'String', '');
h3 = annotation('textbox', [0.8, 0.3, 0.1, 0.1], 'String', '');
h4 = annotation('textbox', [0.8, 0.4, 0.1, 0.1], 'String', '');
h5 = annotation('textbox', [0.8, 0.5, 0.1, 0.1], 'String', '');
h6 = annotation('textbox', [0.8, 0.6, 0.1, 0.1], 'String', '');

% init figure 2 and axes 
f2 = figure;
ax2 = axes();

% Camera intrinsics
focal_length = [367.47199, 366.67233];
principal_point = [249.69163, 154.31907];
image_size = [494, 333];
z = 0.1;
% a = (Cu, Cv, fx, fy)
% This would usually be represented in a matrix, but it is in a vector just for sanity
a = [principal_point(1), principal_point(2), focal_length(1), focal_length(2)];

% Desired location on screen
m_star = [240 170 240 50 100 50 100 170]';
s_star = calculate_s(m_star, a);
L_s = calculate_L_s(s_star, z);

% Coefficient, high value so that the velocities can be seen easier, can be changed when using a robot arm
lambda = 5;

% Initialise camera object
cam = webcam();
cam.Resolution = '320x240';

% Initialise values
mean_error = 0;
v_c = zeros(6,1);
current_error = 0;
i = 1;

%% Main processing loop
while true
  try
    current_frame = snapshot(cam);
    current_frame_grayscale = rgb2gray(current_frame);
    [cornerPoints, boardSize] = detectCheckerboardPoints(current_frame_grayscale);

    % make sure checkerboard is correct size and exists,
    % this has to be done as camera quality can cause the checkerboard to fall out of existence
    if ~isempty(cornerPoints) & isfinite(cornerPoints) & isequal(boardSize(1), 6) & isequal(boardSize(2), 7)
      % get the checkerboard's corner points so that we can treat it as one large rectangle
      board_corner_points = get_board_corner_points(cornerPoints);
      % calculate s, error, L_s, inverse L_s, and v_c
      % s is calculated using our m, which given by detectCheckerboardPoints is given as pixel positions thus we can sub in (u, v) directly - 
      % and with our laptop camera, we assume it is at origin
      current_s = calculate_s(board_corner_points, a);
      current_error = current_s - s_star;
      current_L_s = calculate_L_s(current_s, z);
      inverse_L_s = pinv(current_L_s);
      v_c = -lambda * (inverse_L_s) * current_error;
      mean_error = mean(current_error(:,1))
        hold on;
        % draw lines on image to show checkerboard corners and shape
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

        % Take line coordinates to draw a guide arrow, this is not an entirely accurate representation
        % as this is taking the 3D velocities and attempting to convert them to a 2D image,
        % further arithmetic is required to adjust the velocities to make sense in 2D space
        line_coords = draw_arrow(v_c, board_corner_points);
        current_frame_grayscale = insertShape(current_frame_grayscale, 'Line', [ ...
          line_coords(1:2), line_coords(3:4); ...
        ]);
        hold off;
      else
        disp("No board detected");
      end
  catch ME
    disp("oh no")
  end

  % Draw desired position of checkerboard on screen and label corners for orientation
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

  % Add annotation to the current frame
  positionText = sprintf('Distance from desired position: (%.2f)', mean_error);
  annotatedFrame = insertText(current_frame_grayscale, [10, 10], positionText, 'FontSize', 14, 'BoxColor', 'white', 'TextColor', 'black');
  
  % Swap to figure one, and set handles for previously initialised annotations to show V_c
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

  %clear figure one so that overlapping images aren't being created to save memory, this may be unnecessary with how imshow works
  %clf;

  % Swap to figure two
  figure(2);
  title("Error");
  hold on
  plot(i, current_error,'k.');
  hold off;

  % imshow(annotatedFrame);
  % hold on;
  % plot(cornerPoints);
  % hold off;

  i = i+1;
end

%% Functions

% Function to find the board cornet points based on the labelled checkerboard tiles.
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

% Function to calculate the S based m and a, where s = s(m, a), m = (u, v) and a is the matrix that holds camera intrinsic values
% however, our a is stored as a vector in this case to simplify code
function s = calculate_s(m, a)
% xx = (x, y)
% a = [Cu, Cv, f, alpha], our a = [Cu, Cv, fx, fy]
% x = (u - Cu)/fx
% y = (v - Cv)/fy
% m = (u, v)
  s = zeros(numel(m),1);

  for i = 1:size(m, 1)/2 
    s(2*i - 1) = (m(2*i - 1) - a(1))/a(3); x coords
    s(2*i) = (m(2*i) - a(2))/a(4); y coords
  end
end

% Function to calculate L_s based on the jacobian shown in the documentation
function L_s = calculate_L_s(s, z)
  L_s = zeros(size(s,1), 6);
  for i = 1:size(s, 1)/2
    x = s(2*i - 1, 1);
    y = s(2*i, 1);
    L_s(2*i - 1, :) = [-1/z, 0, x/z, x*y, -(1 + x^2), y];
    L_s(2*i, :) = [0, -1/z, y/z, (1 + y^2), -x*y, -x];
  end
end

% Function to return line coordinates from center of board to some direction represented by the 2D elements of V_c,
% This will need further development to make sure that 
function line_coords = draw_arrow(v_c, board_corner_points)
  v_c_x = v_c(1);
  v_c_y = v_c(2);
  center_board_x_coord = (board_corner_points(1) + board_corner_points(3) + board_corner_points(5) + board_corner_points(7))/4;
  center_board_y_coord = (board_corner_points(2) +  board_corner_points(6) + board_corner_points(4) + board_corner_points(8))/4;
  line_coords = [center_board_x_coord, center_board_y_coord, center_board_x_coord + (v_c_x*1000), center_board_y_coord + (v_c_y*1000)];
end