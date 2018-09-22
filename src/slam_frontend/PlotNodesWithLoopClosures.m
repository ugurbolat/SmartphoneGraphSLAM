function [p1,p2] = PlotNodesWithLoopClosures( nodes, edges )

%% node coordinates
pos_x = [];
pos_y = [];
for i=1:length(nodes)
%    pos_x = [pos_x; (nodes(i).x - nodes(1).x) / 5];
%    pos_y = [pos_y; (nodes(i).y - nodes(1).y) / 5];
   pos_x = [pos_x; (nodes(i).x - nodes(1).x)];
   pos_y = [pos_y; (nodes(i).y - nodes(1).y)];
end

%% wifi loop closures
figure
p1 = plot(pos_x, pos_y, '-ob');
hold on
for i=1:length(edges)
    xs = [pos_x(edges(i).id_from), pos_x(edges(i).id_to)];
    ys = [pos_y(edges(i).id_from), pos_y(edges(i).id_to)];
    p2 = plot(xs, ys, '-r');
end
xlabel('X coordinates (in m)');
ylabel('Y coordinates (in m)');



end

