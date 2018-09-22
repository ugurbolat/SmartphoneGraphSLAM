function [p1] = PlotNodes( nodes )

pos_x = [];
pos_y = [];

for i=1:length(nodes)
%    pos_x = [pos_x; (nodes(i).x - nodes(1).x) / 5];
%    pos_y = [pos_y; (nodes(i).y - nodes(1).y) / 5];
   pos_x = [pos_x; (nodes(i).x - nodes(1).x)];
   pos_y = [pos_y; (nodes(i).y - nodes(1).y)];
end

figure
p1 = plot(pos_x, pos_y, '-ob');
xlabel('X coordinates (in m)');
ylabel('Y coordinates (in m)');

end

