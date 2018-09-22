function [residuals] = SlamErrorModel(x, edges_pdr, edges_wifi)

sigmoid = @(x) 1/(1+exp(-x));

predicted_pos = x(1:2*(size(edges_pdr,2)+1),1);
switch_values = x(2*(size(edges_pdr,2)+1)+1:end,1);

residuals = [];
pdr_errors = [];
wifi_errors = [];
switch_penalty = [];

for i = 1:size(edges_pdr,2)
    pdr_error = edges_pdr(3:4,i) - (predicted_pos(2*i+1:2*i+2,1)-predicted_pos(2*i-1:2*i,1));
    pdr_errors = [pdr_errors, pdr_error];
end
% residuals = sum(pdr_errors.^2,2);
% residuals_delta_x = (pdr_errors(1,:)').^2;
% residuals_delta_y = (pdr_errors(2,:)').^2;
residuals_delta_x = (pdr_errors(1,:)');
residuals_delta_y = (pdr_errors(2,:)');


distance_error_max = 7;
distance_error_min = 0; 
for i = 1:size(edges_wifi,2)
    loop_closure_pos_distance = norm(predicted_pos(2*edges_wifi(1,i)-1:2*edges_wifi(1,i),1) - predicted_pos(2*edges_wifi(2,i)-1:2*edges_wifi(2,i),1));
%     loop_closure_pos_distance = edges_wifi(3,i);
 
    if  loop_closure_pos_distance < distance_error_min
        wifi_error = 0 ;
    elseif loop_closure_pos_distance > distance_error_max
%         wifi_error = distance_error_max;
%         wifi_error = sigmoid(switch_values(i))*(distance_error_max);
        wifi_error = LinearSwitchFunc(switch_values(i))*(distance_error_max);
    else
%         wifi_error = loop_closure_pos_distance - distance_error_min;
%         wifi_error = sigmoid(switch_values(i))*(loop_closure_pos_distance);
        wifi_error = LinearSwitchFunc(switch_values(i))*(loop_closure_pos_distance);
    end
    wifi_errors = [wifi_errors, wifi_error];
end

switch_penalty = 5-switch_values;

% residuals_delta_wifi = (wifi_errors').^2;
residuals_delta_wifi = (wifi_errors');
residuals = [residuals_delta_x; residuals_delta_y; residuals_delta_wifi; switch_penalty];
% residuals = [residuals_delta_x; residuals_delta_y; residuals_delta_wifi];



end