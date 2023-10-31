# This project is for Visual Servoing Camera Control



## This project calculates the camera velocity through capturing features via the camera
- This was done via a laptop camera, under the assumption our camera is the origin and only the object moves we can determine which 3-D space velocities need to calculated to move the object into a desired position
- The camera acting as origin will become apparent when the coordinates of the camera aren't taken into account with missing: X_cam coordinates, image coordinates, and camera intrinsics matrix multiplication
- This can easily be converted to give end effector positional data for a robotic arm
- The code initialises a number of variables and objects
- Runs a main loop which calls functions
- These functions, as well as some code in the main loop, take pixel data from the camera to give us a set, s, of features
- The pixel positions of these features are then utilised as our m, where s is some function s(m, a), m being our pixel positions m(u, v), and a being the intrinsic camera properties. We changed the structure of our a from the typical 3x3 matrix that you usually see to a vector just to reduce complexity slightly in implementing our algorithms, where a = (Cu, Cv, fx, fy)
- We can calculate our L_s using s, an estimated Z depth, and the jacobian, which allows us to compare our s vector against the desired vector : s*
- This results in us finding our current error, which can then be utilised with a static lambda value in: V_c = -lambda * (L_s pseudo-inverse) * current_error
- Thus we find the camera velocities: V_c