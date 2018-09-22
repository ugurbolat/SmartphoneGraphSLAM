function [edges_wifi , edges_ble] = PoseEdgeRssi(nodes)

edges_wifi = [];
edges_ble = [];

for current_i=2:length(nodes)
    current_i
    for history_i=1:current_i-1
        a = [nodes(current_i).x, nodes(current_i).y];
        b = [nodes(history_i).x, nodes(history_i).y];
        distance_error = norm(a - b);
        
        % wifi
        % taking mean of rssi measurment for a now!!!!!!!!!
        diff_wifi = nanmean(nodes(current_i).wifi, 1) - nanmean(nodes(history_i).wifi, 1);
        diff_wifi_timestamp = nodes(current_i).wifi_timestamp(1) - nodes(history_i).wifi_timestamp(1);
        % if dissimilarity comes as all NaN it means 
        % one of the step doesn't have any measurments
        if isempty(find(~isnan(diff_wifi), 1))
            diff_wifi = 100;
        end
        if isnan(diff_wifi_timestamp)
           diff_wifi_timestamp = 0; 
        end
        
        dissimilarity_wifi = sqrt(sum(diff_wifi(~isnan(diff_wifi)).^2) / length(diff_wifi(~isnan(diff_wifi))));
        
        % restricting loop closures
        if dissimilarity_wifi < 5 && distance_error > 1 && diff_wifi_timestamp > 10*1e9
            % loop closure detected
            edges_wifi = [edges_wifi, EdgeRssi(current_i, history_i, distance_error, [])];
        end
        
        % ble
        % taking mean of rssi measurment for a now!!!!!!!!!
        diff_ble = nanmean(nodes(current_i).ble, 1) - nanmean(nodes(history_i).ble, 1);
        diff_ble_timestamp = nodes(current_i).ble_timestamp(1) - nodes(history_i).ble_timestamp(1);
        % if dissimilarity comes as all NaN it means 
        % one of the step doesn't have any measurments
        if isempty(find(~isnan(diff_ble), 1))
            diff_ble = 100;
        end
        if isnan(diff_ble_timestamp)
           diff_ble_timestamp = 0; 
        end
        
        dissimilarity_ble = sqrt(sum(diff_ble(~isnan(diff_ble)).^2) / length(diff_ble(~isnan(diff_ble))));
                
        if dissimilarity_ble < 1 && distance_error > 1 && diff_ble_timestamp > 10*1e9
            % loop closure detected
            edges_ble = [edges_ble, EdgeRssi(current_i, history_i, distance_error, [])];
        end
        
    end
    
end

end