function [ edges_mag ] = PoseEdgeMag( nodes, dissimilarity_threshold, distance_threshold )

edges_mag = [];

for current_i=2:length(nodes)
    current_i
    for history_i=1:current_i-1
        a = [nodes(current_i).x, nodes(current_i).y];
        b = [nodes(history_i).x, nodes(history_i).y];
        distance_error = norm(a - b);
        
        if distance_error > distance_threshold
           continue; 
        end
        
        % wifi
        % taking mean of rssi measurment for a now!!!!!!!!!
        diff_mag_timestamp = nodes(current_i).mag_timestamp(1) - nodes(history_i).mag_timestamp(1);
        if isnan(diff_mag_timestamp)
           diff_mag_timestamp = 0; 
        end
        
        % restricting loop closures
        if diff_mag_timestamp < 10*1e9
            continue;
        end
        
        diff_mag = nanmean(nodes(current_i).mag, 1) - nanmean(nodes(history_i).mag, 1);
%         diff_mag = nodes(current_i).mag(1, :) - nodes(history_i).mag(1,:);
        % if dissimilarity comes as all NaN it means 
        % one of the step doesn't have any measurments
        if isempty(find(~isnan(diff_mag), 1))
            diff_mag = 100;
        end
        dissimilarity_mag = norm(diff_mag);
        if dissimilarity_mag < dissimilarity_threshold
            % loop closure detected
            edges_mag = [edges_mag, EdgeRssi(current_i, history_i, distance_error, [])];
        end 
        
    end
end

end

