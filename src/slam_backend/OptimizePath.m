function [ slam_result, rmse ] = OptimizePath( ground_truth_nodes, nodes, edges_pdr, edges_lc )

g_edges_pdr = [];
for i = 1:length(edges_pdr)
    g_edges_pdr(1,i) = i+1;
    g_edges_pdr(2,i) = i;
    g_edges_pdr(3,i) = edges_pdr(i).delta_x;
    g_edges_pdr(4,i) = edges_pdr(i).delta_y;
    g_edges_pdr(5,i) = edges_pdr(i).delta_yaw;
end


g_edges_wifi = [];
for i = 1:length(edges_lc)
    g_edges_wifi(1,i) = edges_lc(i).id_to;
    g_edges_wifi(2,i) = edges_lc(i).id_from;
    g_edges_wifi(3,i) = edges_lc(i).error;
end

% the initial predicted path is taken from pdr
initial_pos = [];
for i=1:length(nodes)
    initial_pos = [initial_pos, [nodes(i).x; nodes(i).y]];
end
% the initial switch variables value is set 10, 
% which means every loop closure is active at the beginning
initial_switch_values = 5 * ones(size(g_edges_wifi,2),1);

% x0 = initial_pos(:);
x0 = [initial_pos(:); initial_switch_values];

% lb = zeros(size(x0));
lb = [];
ub = [];

% testing slam error model with init_pos
residuals = SlamErrorModel(x0, g_edges_pdr, g_edges_wifi);

f = @(x) SlamErrorModel(x, g_edges_pdr, g_edges_wifi);

options = optimoptions('lsqnonlin','Algorithm','Levenberg-Marquardt',...
    'Diagnostics','on','Display','iter-detailed',...
    'TolFun', 1e-5, 'MaxIter', 100, 'MaxFunEvals', 20000 );

[xstar] = lsqnonlin(f,x0,lb,ub,options);

%% Plotting Optimized Path

% moving slam to the (0,0) coordinates
temp_xstar = [];
for i=1:2:2*size(initial_pos,2)
    temp_xstar = [temp_xstar, [xstar(i);xstar(i+1)]];
end
xstar = temp_xstar;
temp_x = zeros(size(xstar));
temp_x(1,:) = xstar(1,1);
temp_x(2,:) = xstar(2,1);
slam_result = xstar - temp_x;

% moving pdr results to the (0,0) coordindates
initial_pos(1,:) = initial_pos(1,:) - initial_pos(1,1);
initial_pos(2,:) = initial_pos(2,:) - initial_pos(2,1);

p0 = PlotNodes(ground_truth_nodes);
% reverting pdr values to the original values
% initial_pos = initial_pos/5;
% slam_result = slam_result/5;
hold on
p1 = plot(initial_pos(1,:),initial_pos(2,:),'ko-');
p2 = plot(slam_result(1,:),slam_result(2,:),'ro-');
legend([p0,p1,p2], 'Ground Truth', 'Before SLAM', 'After SLAM');

diff_x = ([ground_truth_nodes.x]'-ground_truth_nodes(1).x) - slam_result(1,1:length(ground_truth_nodes))';
sum_diff_x = sum(diff_x.^2);
diff_y = ([ground_truth_nodes.y]'-ground_truth_nodes(1).y) - slam_result(2,1:length(ground_truth_nodes))';
sum_diff_y = sum(diff_y.^2);

rmse_x = sqrt(sum_diff_x / length(diff_x));
rmse_y = sqrt(sum_diff_y / length(diff_y));

rmse = [rmse_x, rmse_y];

end

