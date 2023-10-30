% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly executed under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 367.471989377073953 ; 366.672333877046299 ];

%-- Principal point:
cc = [ 249.691631059343223 ; 154.319068743110279 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ 0.170047368714241 ; -1.882148790192291 ; 0.004178473184120 ; -0.005476307274078 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 4.608116463095709 ; 4.400590169780122 ];

%-- Principal point uncertainty:
cc_error = [ 7.343557836088444 ; 7.043561502089490 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.130398774800557 ; 1.506588894638520 ; 0.008377002593967 ; 0.007556717665653 ; 0.000000000000000 ];

%-- Image size:
nx = 494;
ny = 333;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 10;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ -1.818826e+00 ; -2.263204e+00 ; 8.344025e-01 ];
Tc_1  = [ -6.061770e+01 ; -9.205120e+01 ; 6.091119e+02 ];
omc_error_1 = [ 2.003238e-02 ; 1.394755e-02 ; 2.830733e-02 ];
Tc_error_1  = [ 1.221295e+01 ; 1.165774e+01 ; 7.128450e+00 ];

%-- Image #2:
omc_2 = [ -1.823537e+00 ; -2.260522e+00 ; 8.305395e-01 ];
Tc_2  = [ -6.151803e+01 ; -9.443925e+01 ; 6.124697e+02 ];
omc_error_2 = [ 2.011110e-02 ; 1.391235e-02 ; 2.838351e-02 ];
Tc_error_2  = [ 1.228648e+01 ; 1.172346e+01 ; 7.183072e+00 ];

%-- Image #3:
omc_3 = [ -1.396789e+00 ; -2.174322e+00 ; 8.851822e-01 ];
Tc_3  = [ -5.855907e+01 ; -1.145566e+02 ; 5.911396e+02 ];
omc_error_3 = [ 1.887752e-02 ; 1.585640e-02 ; 2.502448e-02 ];
Tc_error_3  = [ 1.190789e+01 ; 1.135906e+01 ; 6.823720e+00 ];

%-- Image #4:
omc_4 = [ 1.814604e+00 ; 1.916431e+00 ; -7.375142e-01 ];
Tc_4  = [ -6.524230e+01 ; -8.525594e+01 ; 5.386704e+02 ];
omc_error_4 = [ 1.332526e-02 ; 1.999038e-02 ; 2.647454e-02 ];
Tc_error_4  = [ 1.081806e+01 ; 1.032408e+01 ; 6.500615e+00 ];

%-- Image #5:
omc_5 = [ -1.141684e+00 ; -1.992806e+00 ; 9.312294e-01 ];
Tc_5  = [ 4.268721e+00 ; -1.284278e+02 ; 6.145277e+02 ];
omc_error_5 = [ 1.828607e-02 ; 1.659464e-02 ; 2.222109e-02 ];
Tc_error_5  = [ 1.237726e+01 ; 1.177708e+01 ; 6.949818e+00 ];

%-- Image #6:
omc_6 = [ -1.128764e+00 ; -2.005411e+00 ; 9.445602e-01 ];
Tc_6  = [ 5.465263e+00 ; -1.303396e+02 ; 6.145142e+02 ];
omc_error_6 = [ 1.833034e-02 ; 1.661450e-02 ; 2.228629e-02 ];
Tc_error_6  = [ 1.238154e+01 ; 1.177671e+01 ; 6.952487e+00 ];

%-- Image #7:
omc_7 = [ -1.544741e+00 ; -1.516481e+00 ; -5.625782e-01 ];
Tc_7  = [ -1.081380e+02 ; -9.592561e+01 ; 4.828062e+02 ];
omc_error_7 = [ 1.463391e-02 ; 1.745594e-02 ; 2.131728e-02 ];
Tc_error_7  = [ 9.740849e+00 ; 9.373240e+00 ; 7.391153e+00 ];

%-- Image #8:
omc_8 = [ 2.007897e+00 ; 1.490241e+00 ; 1.024753e+00 ];
Tc_8  = [ -4.148233e+01 ; -5.125922e+01 ; 4.242052e+02 ];
omc_error_8 = [ 2.180926e-02 ; 1.172229e-02 ; 2.439497e-02 ];
Tc_error_8  = [ 8.550095e+00 ; 8.110653e+00 ; 6.368454e+00 ];

%-- Image #9:
omc_9 = [ -2.128256e+00 ; -2.145379e+00 ; -2.922037e-01 ];
Tc_9  = [ -8.974949e+01 ; -8.265500e+01 ; 4.964707e+02 ];
omc_error_9 = [ 1.651139e-02 ; 1.939322e-02 ; 3.347890e-02 ];
Tc_error_9  = [ 1.002025e+01 ; 9.588799e+00 ; 7.044310e+00 ];

%-- Image #10:
omc_10 = [ 2.391158e+00 ; 1.377787e+00 ; 5.285448e-01 ];
Tc_10  = [ -7.248514e+01 ; -3.118444e+01 ; 5.071287e+02 ];
omc_error_10 = [ 2.174313e-02 ; 1.000035e-02 ; 2.866528e-02 ];
Tc_error_10  = [ 1.018332e+01 ; 9.698481e+00 ; 7.282088e+00 ];

