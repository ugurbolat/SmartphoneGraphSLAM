clear all
close all

%% reading csv files

addpath('file_processing');
addpath('slam_frontend');
addpath('slam_backend');

imu_path = 'database/named/imu/';
[ IMU.accel, IMU.gyro, IMU.linaccel, IMU.mag, IMU.mag_timestamp, IMU.orient, ...
    IMU.rotvecall_quarternion, ... 
    IMU.rotvecgyro_quarternion, ...
    IMU.rotvecmag_quarternion, ...
    IMU.rotvecall_euler, ...
    IMU.rotvecgyro_euler, ...
    IMU.rotvecmag_euler ] = ParseImu(imu_path);

rssi_path = 'database/named/rssi/';
[ RSSI.ble_timestamp, RSSI.ble, RSSI.wifi_timestamp, RSSI.wifi ] = ParseRssi(rssi_path);

%% PDR


% IMU.rotvecgyro_euler(7500:end,4) = IMU.rotvecgyro_euler(7500:end,4) - 83;


addpath('pdr');

% % Orientation Heading PDR
% [ PDR_orient.step_detection_time, PDR_orient.step_length, PDR_orient.step_heading ] = ... 
%     Pdr(IMU.accel, -IMU.orient);
% % rotating 60 degree
% % PDR_orient.step_heading = AlignHeading(PDR_orient.step_heading, 60);
% % PDR_rotvecall.step_length = PDR_rotvecall.step_length * 5;
% nodes_orient = PoseNodes(PDR_orient, RSSI, IMU);
% nodes_orient = nodes_orient(1:211);
% PlotNodes(nodes_orient);

% % Rotation Vector All Heading PDR
% [ PDR_rotvecall.step_detection_time, PDR_rotvecall.step_length, PDR_rotvecall.step_heading ] = ... 
%     Pdr(IMU.accel, IMU.rotvecall_euler);
% % rotating 60 degree
% PDR_rotvecall.step_heading = AlignHeading(PDR_rotvecall.step_heading, 60);
% % PDR_rotvecall.step_length = PDR_rotvecall.step_length * 5;
% nodes_rotvecall = PoseNodes(PDR_rotvecall, RSSI, IMU);
% % nodes_rotvecall = nodes_rotvecall(1:618);
% PlotNodes(nodes_rotvecall);

% Rotation Vector Gyro Heading PDR
% heading 90 degree wrong with the step 310, IMU 4277th measurement 
% which is the end of first time route is completed
IMU.rotvecgyro_euler(4277:8474,4) = IMU.rotvecgyro_euler(4277:8474,4) + 82;
[ PDR_rotvecgyro.step_detection_time, PDR_rotvecgyro.step_length, PDR_rotvecgyro.step_heading ] = ... 
    Pdr(IMU.accel, IMU.rotvecgyro_euler);
% rotating 184 degree
PDR_rotvecgyro.step_heading = AlignHeading(PDR_rotvecgyro.step_heading, 180);
% PDR_rotvecgyro.step_length = PDR_rotvecgyro.step_length * 5;
nodes_rotvecgyro = PoseNodes(PDR_rotvecgyro, RSSI, IMU);
% nodes_rotvecgyro = nodes_rotvecgyro(1:618);
PlotNodes(nodes_rotvecgyro);

% % Rotation Vector Mag Heading PDR
% [ PDR_rotvecmag.step_detection_time, PDR_rotvecmag.step_length, PDR_rotvecmag.step_heading ] = ... 
%     Pdr(IMU.accel, IMU.rotvecmag_euler);
% % rotating 60 degree
% PDR_rotvecmag.step_heading = AlignHeading(PDR_rotvecmag.step_heading, 60);
% % PDR_rotvecmag.step_length = PDR_rotvecmag.step_length * 5;
% nodes_rotvecmag = PoseNodes(PDR_rotvecmag, RSSI, IMU);
% % nodes_rotvecmag = nodes_rotvecmag(1:618);
% PlotNodes(nodes_rotvecmag);

%%%%%%%
% ground_truth_nodes = [nodes_rotvecgyro(1:307), nodes_rotvecgyro(1:307), nodes_rotvecgyro(1:307)];
ground_truth_nodes = [
    nodes_rotvecgyro(1:154),...
    nodes_rotvecgyro(1:154),...
    nodes_rotvecgyro(1:154),...
    nodes_rotvecgyro(1:154),...
    nodes_rotvecgyro(1:154),...
    nodes_rotvecgyro(1:154)];
p1 = PlotNodes(ground_truth_nodes);
title('Ground Truth Walking Path');
%%%%%%


%% Pose Nodes

PDR = PDR_rotvecgyro;
% to distinguish pdr edges from magnetic egdes
% we need to put the pdr values to bigger scale
nodes = nodes_rotvecgyro;

%% PDR Egdes

edges_pdr = PoseEdgePdr(nodes);



%% Loop Closures based on RSSIs
% [edges_wifi, edges_ble] = PoseEdgeRssi(nodes);
[edges_mag] = PoseEdgeMag(nodes, 1, 8);

% % % plotting loop closures
% [p1,p2] = PlotNodesWithLoopClosures(nodes, edges_wifi);
% legend([p1,p2], 'Walking Path', 'Loop Closures');
% title('Wi-Fi Loop Closures');
% [p3,p4] = PlotNodesWithLoopClosures(nodes, edges_ble);
% legend([p3,p4], 'Walking Path', 'Loop Closures');
% title('BLE  Loop Closures');
[p5,p6] = PlotNodesWithLoopClosures(nodes, edges_mag);
legend([p5,p6], 'Walking Path', 'Loop Closures');
title('Magnetic Loop Closures');


%% Optimization

% [opt_path_wifi, rmse_wifi] = OptimizePath(ground_truth_nodes, nodes, edges_pdr, edges_wifi);
% title('Optimized Path with Wi-Fi Loop Closures');
% [opt_path_ble, rmse_ble] = OptimizePath(ground_truth_nodes, nodes, edges_pdr, edges_ble);
% title('Optimized Path with BLE Loop Closures');
[opt_path_mag, rmse_mag] = OptimizePath(ground_truth_nodes, nodes, edges_pdr, edges_mag);
title('Optimized Path with Magnetic Loop Closures');



