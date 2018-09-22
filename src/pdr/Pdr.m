function [ step_detection_time, step_length, step_heading ] ...
    = Pdr( accel, heading )



%% PREPROCESSING THE ACCELEROMETER AND HEADING
% getting accelerometer timestamp
accel_actual_time = accel(:, 1);
accel_timestamp = accel(:, 1) - accel(1, 1);
% converting ns to s
accel_timestamp = accel_timestamp * 1e-9;
accel = accel(:, 2:4);
for i=1:length(accel(:,1))
    average_accel(i,1) = sqrt(accel(i,1:3) * accel(i,1:3)' );
end

% % plotting raw acceleration
% figure 
% plot(accel_timestamp, average_accel, 'k');

% getting heading timestamp
heading_actual_time = heading(:, 1);
heading_timestamp = heading(:, 1) - heading(1, 1);
% converting ns to s
heading_timestamp = heading_timestamp * 1e-9;
heading = heading(:,2:4);


%% Filter Params
alfa = 0.90;
accel_hp_avg = 0;
log_high_pass = [];
log_low_pass = [];
moving_avg_count = 10;
moving_avg_indis = 1;
low_pass_inputs = zeros(moving_avg_count, 1);


%% Step Detection Params
maxima_thresold = 0.13; 
minima_thresold = -0.13;
delta_time_max = 1200e-3; %
delta_time_min = 0e-3; %
minima_time = 0;
maxima_time = 0;
maxima_found = 0;
minima_found = 0;
minima_index = 0;
maxima_index = 0;
step_count = 0;

%% Step Detection Algo

for i=1:length(average_accel)
        
    % High Pass Filter
    accel_hp_avg = average_accel(i) * (1-alfa) + ...
        accel_hp_avg * alfa;
    accel_hp_filtered = average_accel(i) - accel_hp_avg;
    
    % Moving Average Filter
    low_pass_inputs(moving_avg_indis) = accel_hp_filtered;
    moving_avg_indis = moving_avg_indis + 1;
    if moving_avg_indis > moving_avg_count
        moving_avg_indis = 1;
    end
    accel_filtered = mean(low_pass_inputs);
    
    % Step Detection
    if maxima_found == 0
        maxima = maxima_thresold;
    end
    
    if minima_found == 0
        minima = minima_thresold;
    end
    
    log_max_min_thresold(i,1) = accel_timestamp(i);
    log_max_min_thresold(i,2) = maxima_thresold;
    log_max_min_thresold(i,3) = minima_thresold;
    
    if accel_filtered > maxima
        maxima_found = 1;
        maxima = accel_filtered;
        maxima_time = accel_timestamp(i);
        maxima_index = i;
        maxima_step_detection_time = accel_actual_time(i);    
    elseif accel_filtered < maxima && maxima_found == 1
        maxima_found = 2;
    end
    
    if accel_filtered < minima && maxima_found == 2
        minima_found = 1;
        minima = accel_filtered;
        minima_time = accel_timestamp(i);
        minima_index = i;
        minima_step_detection_time = accel_actual_time(i);
    elseif accel_filtered > minima && minima_found == 1
        minima_found = 2;
    end    
      
    if accel_timestamp(i) - maxima_time > delta_time_max
        minima_found = 0;
        maxima_found = 0;
    end
       
    % logging
    log_low_pass(i,1) = accel_filtered;
    log_high_pass(i,1) = accel_hp_filtered;
    log_step(i,1) = 0;

    if minima_found == 2 && maxima_found == 2
        if -maxima_time + minima_time <= delta_time_max ...
                && -maxima_time + minima_time > delta_time_min
            
            step_count = step_count + 1;
            
            % weinberg step length
            step_length(step_count,1) = 0.51 * nthroot(log_low_pass(maxima_index,1) - log_low_pass(minima_index), 4);  
            
            % scarlet_step
            if maxima_time - minima_time > 0
                scarlet_step(step_count,1) = 1.35 * ( mean(log_low_pass(minima_index:maxima_index,1)) - log_low_pass(minima_index,1) ) / ...
                    ( log_low_pass(maxima_index,1) - log_low_pass(minima_index,1) );
            elseif maxima_time - minima_time < 0
                scarlet_step(step_count,1) = 1.35 * (mean(log_low_pass(maxima_index:minima_index,1))-log_low_pass(minima_index,1)) / ...
                    (log_low_pass(maxima_index,1) - log_low_pass(minima_index,1));
            % kim_step
            end
            if maxima_time - minima_time > 0
                kim_step(step_count,1) = 0.65 * nthroot( mean(abs( log_low_pass(minima_index:maxima_index,1) )), 3 );
            elseif maxima_time - minima_time < 0
                kim_step(step_count,1) = 0.65 * nthroot( mean(abs( log_low_pass(maxima_index:minima_index,1) )), 3 );
            end
            
            
            % step occurence time
            step_detection_time(step_count, 1) = maxima_step_detection_time;
%             step_detection_time(step_count, 2) = minima_step_detection_time;

            % step heading from z value
            step_heading(step_count, 1) = heading(maxima_index, 3);
            
            log_max_min(step_count, 1) = maxima_time;
            log_max_min(step_count, 2) = maxima;
            log_max_min(step_count, 3) = minima_time;
            log_max_min(step_count, 4) = minima;
            log_max_min(step_count, 5) = maxima_index;
            log_max_min(step_count, 6) = minima_index;
            
            log_step(i,1) = 10;
            minima_found = 0;
            maxima_found = 0;
            
        end
    end

end

% PDR Step Detection
figure(1)
plot(accel_timestamp, log_low_pass(:,1), 'r-');
hold on
plot(log_max_min_thresold(:,1), log_max_min_thresold(:,2), 'b--')
plot(log_max_min_thresold(:,1), log_max_min_thresold(:,3), 'g--')
plot(log_max_min(:,1), log_max_min(:,2), 'bo')
plot(log_max_min(:,3), log_max_min(:,4), 'go')
step_count

% PDR Step Length Estimation
figure(2)
plot(scarlet_step(:,1), 'g');
hold on
scarlet_mean = ones(1,length(scarlet_step(:,1)));
scarlet_mean = mean(scarlet_step(:,1)).*scarlet_mean;
plot(scarlet_mean, 'k-');
plot(step_length(:,1), 'r');
weinberg_mean = ones(1,length(step_length(:,1)));
weinberg_mean = mean(step_length(:,1)).*weinberg_mean;
plot(weinberg_mean, 'k-');
plot(kim_step(:,1), 'b');
kim_mean = ones(1,length(kim_step(:,1)));
kim_mean = mean(kim_mean(:,1)).*kim_mean;
plot(kim_mean, 'k-');


    
end

