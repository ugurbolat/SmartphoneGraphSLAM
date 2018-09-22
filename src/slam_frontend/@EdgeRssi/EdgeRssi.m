classdef EdgeRssi < handle
    %POSEEDGE A class for edge in a pose graph
    
    properties (SetAccess = public)
        id_from  % This is the viewing frame of this edge
        id_to    % This is the pose being observed from the viewing frame
        error    % Error produced from two connected nodes due to loop closure
        infm     % Information matrix of this edge
    end  % properties set private
    
    methods
        
        function obj = EdgeRssi(id_from, id_to, error, infm)
            % Consturctor of PoseEdge
            obj.id_from = id_from;
            obj.id_to = id_to;
            obj.error = error;
            obj.infm = infm;
        end
        
    end  % methods public
    
end  % classdef