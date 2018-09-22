classdef EdgePdr < handle
    %POSEEDGE A class for edge in a pose graph
    
    properties (SetAccess = public)
        id_from  % This is the viewing frame of this edge
        id_to    % This is the pose being observed from the viewing frame
        delta_x  % PDR
        delta_y  % PDR
        delta_yaw % Heading
        infm     % Information matrix of this edge
    end  % properties set private
    
    methods
        
        function obj = EdgePdr(id_from, id_to, delta_x, delta_y, delta_yaw, infm)
            % Consturctor of PoseEdge
            obj.id_from = id_from;
            obj.id_to = id_to;
            obj.delta_x = delta_x;
            obj.delta_y = delta_y;
            obj.delta_yaw = delta_yaw;
            obj.infm = infm;
        end
        
    end  % methods public
    
end  % classdef
