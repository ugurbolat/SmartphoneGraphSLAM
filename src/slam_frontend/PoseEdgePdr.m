function [edges_pdr] = PoseEdgePdr(nodes)

for i_node=2:length(nodes)
    temp_id_from = i_node-1;
    temp_id_to = i_node;
    temp_delta_x = nodes(i_node).x - nodes(i_node-1).x;
    temp_delta_y = nodes(i_node).y - nodes(i_node-1).y;
    temp_delta_yaw = nodes(i_node).yaw - nodes(i_node-1).yaw;
    if temp_delta_yaw < -180
        temp_delta_yaw = temp_delta_yaw + 360;
    elseif temp_delta_yaw > 180
        temp_delta_yaw = temp_delta_yaw - 360;
    end
    temp_information_matrix = [];
    
    edges_pdr(i_node-1) = EdgePdr(temp_id_from, temp_id_to, ...
        temp_delta_x, temp_delta_y, temp_delta_yaw, ...
        temp_information_matrix);  
    
end
    
end