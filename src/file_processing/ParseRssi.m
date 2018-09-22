function [ ble_timestamp, ble, wifi_timestamp, wifi ] = ParseRssi( path )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

d = dir(path);

for i=3:length(d)
    rssi_dir_cell{i-2} = csvread(strcat(path, d(i).name));
end

ble = rssi_dir_cell{1};
wifi = rssi_dir_cell{2};

ble_timestamp = ble(:, 1);
ble = ble(:,3:end);
ble(ble == 0) = NaN;
wifi_timestamp = wifi(:, 1);
wifi =  wifi(:,3:end);
wifi(wifi == 0) = NaN;

end

