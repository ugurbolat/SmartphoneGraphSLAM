function [ accel, gyro, linaccel, mag, mag_timestamp, orient, ... 
    rotvecall_quarternion, rotvecgyro_quarternion, rotvecmag_quarternion, ...
    rotvecall_euler, rotvecgyro_euler, rotvecmag_euler ] = ParseImu( path )

d = dir(path);

for i=3:length(d)
    imu_dir_cell{i-2} = csvread(strcat(path, d(i).name), 1, 3);
end

accel = imu_dir_cell{1};
gyro = imu_dir_cell{2};
linaccel = imu_dir_cell{3};
mag = imu_dir_cell{4};
orient = imu_dir_cell{5};
rotvecall = imu_dir_cell{6};
rotvecgyro = imu_dir_cell{7};
rotvecmag = imu_dir_cell{8};

% flip matrix up to down
accel = flipud(accel);
gyro = flipud(gyro);
linaccel = flipud(linaccel);
mag = flipud(mag);
orient = flipud(orient);
rotvecall = flipud(rotvecall);
rotvecgyro = flipud(rotvecgyro);
rotvecmag = flipud(rotvecmag);

% removing last zero columns
accel = accel(:, 1:4);
gyro = gyro(:, 1:4);
linaccel = linaccel(:, 1:4);
mag = mag(:, 1:4);
orient = orient(:, 1:4);
rotvecall_quarternion = rotvecall(:, 1:4);
rotvecgyro_quarternion = rotvecgyro(:, 1:4);
rotvecmag_quarternion = rotvecmag(:, 1:4);

%% some preprocesing on imu values

% replace correct order of x,y,z orientation angles
orient = [orient(:,1), orient(:,3), orient(:,4) , orient(:,2)];

% converting from quarternion to euler
[ x, y, z ] = Quarternion2Euler(...
    rotvecall_quarternion(:,2), ... 
    rotvecall_quarternion(:,3), ... 
    rotvecall_quarternion(:,4));
rotvecall_euler = [rotvecall_quarternion(:,1), x, y, z];

[ x, y, z ] = Quarternion2Euler(...
    rotvecgyro_quarternion(:,2), ... 
    rotvecgyro_quarternion(:,3), ... 
    rotvecgyro_quarternion(:,4));
rotvecgyro_euler = [rotvecgyro_quarternion(:,1), x, y, z];

[ x, y, z ] = Quarternion2Euler(...
    rotvecmag_quarternion(:,2), ... 
    rotvecmag_quarternion(:,3), ... 
    rotvecmag_quarternion(:,4));
rotvecmag_euler = [rotvecmag_quarternion(:,1), x, y, z];

mag_timestamp = mag(:, 1);
mag = mag(:, 2:4);

end

