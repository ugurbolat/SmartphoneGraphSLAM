function [ nodes ] = PoseNodes( PDR, RSSI, IMU)


%% first node!
% it is important keep coordinate values at positive values
% so initila position must be big enough not to have any negative 
% optimized coordinates
nodes(1) = Node(1, 100, 100, PDR.step_heading(1), ...
    PDR.step_detection_time(1), ...
    RSSI.wifi(1,:), RSSI.wifi_timestamp(1), ...
    RSSI.ble(1,:), ...
    RSSI.ble_timestamp(1), ...
    IMU.mag(1,:), ...
    IMU.mag_timestamp(1));

%% rest of the nodes
for i_node = 2:length(PDR.step_detection_time)
    temp_x = nodes(i_node-1).x + PDR.step_length(i_node)*cosd(PDR.step_heading(i_node)); 
    temp_y = nodes(i_node-1).y + PDR.step_length(i_node)*sind(PDR.step_heading(i_node)); 
    temp_yaw = PDR.step_heading(i_node);
    
    wifi_indices = (PDR.step_detection_time(i_node-1) < RSSI.wifi_timestamp) ... 
        & (PDR.step_detection_time(i_node) > RSSI.wifi_timestamp);
    temp_wifi =  RSSI.wifi(wifi_indices, :);
    temp_wifi_timestamp = RSSI.wifi_timestamp(wifi_indices, :);
    if isempty(temp_wifi)
       temp_wifi = zeros(1,size(RSSI.wifi, 2));
       temp_wifi(:) = NaN;
       temp_wifi_timestamp = zeros(1,size(RSSI.wifi_timestamp, 2));
       temp_wifi_timestamp(:) = NaN;
    end
    
    ble_indices = (PDR.step_detection_time(i_node-1) < RSSI.ble_timestamp) ... 
        & (PDR.step_detection_time(i_node) > RSSI.ble_timestamp);
    temp_ble = RSSI.ble(ble_indices, :);
    temp_ble_timestamp = RSSI.ble_timestamp(ble_indices);
    if isempty(temp_ble)
       temp_ble =  zeros(1, size(RSSI.ble, 2));
       temp_ble(:) = NaN;
       temp_ble_timestamp = zeros(1,size(RSSI.ble, 2));
       temp_ble_timestamp(:) = NaN;
    end
    
    mag_indices = (PDR.step_detection_time(i_node-1) < IMU.mag_timestamp) ... 
        & (PDR.step_detection_time(i_node) > IMU.mag_timestamp);
    temp_mag = IMU.mag(mag_indices, :);
    temp_mag_timestamp = IMU.mag_timestamp(mag_indices);
    if isempty(temp_mag)
       temp_mag =  zeros(1, size(IMU.mag, 2));
       temp_mag(:) = NaN;
       temp_mag_timestamp = zeros(1,size(IMU.mag, 2));
       temp_mag_timestamp(:) = NaN;
    end
    
    nodes(i_node) = Node(i_node, temp_x, temp_y, temp_yaw, ...
        PDR.step_detection_time(i_node), ...
        temp_wifi, temp_wifi_timestamp, ...
        temp_ble, temp_ble_timestamp, ...
        temp_mag, temp_mag_timestamp);
    
end


end

