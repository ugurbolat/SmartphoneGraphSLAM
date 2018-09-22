classdef Node < handle
    %Node A class for pose node
    
    properties (Access = public)
        id    % Id of this pose node
        x    % X coordinate
        y    % Y coordinate
        yaw  % Yaw angle
        rt   % Transformation local to global
        wifi % Wifi RSSIs
        ble % BLE RSSIs
        mag
        pdr_timestamp 
        wifi_timestamp 
        ble_timestamp
        mag_timestamp
    end  % properties public
      
    methods
        
        function obj = Node(id, x, y, yaw, pdr_timestamp, ...
                wifi, wifi_timestamp, ... 
                ble, ble_timestamp, ...
                mag, mag_timestamp)
            % Constructor of Node
            obj.id = id;
            obj.x = x;
            obj.y = y;
            obj.yaw = yaw;
            obj.wifi = wifi;
            obj.wifi = wifi;
            obj.ble = ble;
            obj.pdr_timestamp = pdr_timestamp;
            obj.wifi_timestamp = wifi_timestamp;
            obj.ble_timestamp = ble_timestamp;
            obj.mag = mag;
            obj.mag_timestamp = mag_timestamp;
        end
        
        function plot(obj)
            % Plot all pose nodes position
            plot(obj.x, obj.y, 'b');
        end
        
        function x = get.x(obj)
            x = obj.x;
        end
        
        function y = get.y(obj)
            y = obj.y;
        end
        
        function yaw = get.yaw(obj)
            yaw = obj.yaw;
        end
        
        function rt = get.rt(obj)
            R = [cos(obj.yaw) -sin(obj.yaw);
                 sin(obj.yaw)  cos(obj.yaw)];
            rt = [R [obj.x; obj.y]; 0 0 1];
        end
        
        function wifi = get.wifi(obj)
            wifi = obj.wifi;
        end
        
        function ble = get.ble(obj)
            ble = obj.ble;
        end
        
    end  % methods public
    
end  % classdef
