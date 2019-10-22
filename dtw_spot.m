function result = dtw_spot(input_video, class_thresholds)
trajectories = load('train_trajectories.txt');

n = size(read_video_frames(input_video));n = n(4);
test_trajectory = green_hand_trajectory(input_video, 2, n-1);
result = [];

for file = 1:10
    label = file-1;
    temp = trajectories(:,3) == file-1;
    trajectory = trajectories(temp,1:2);
    
    m = length(trajectory);
    scores = zeros(m,n-2);
    scores(1:m,1) = Inf;
    
    for i = 2 : m
        for j = 2 : n-2
            %             [i,j]
            arr = [scores(i-1, j), scores(i, j-1), scores(i-1, j-1)];
            scores(i,j) = norm(test_trajectory(j,:)-trajectory(i,:)) + min(arr);
        end
    end
    temp_v = scores(m,:);
    last_val = scores(m,:)<class_thresholds(file);
    [~, last_val_c] = find(last_val);
    values = [temp_v(last_val)',last_val_c'];
    %     [value, loc] = min(scores(m,:));
    %     r = m; c = loc;
    for index = 1:length(values)
        value = values(index,1);
        r = m;
        c = values(index,2);
        while value > 0
            arr = [scores(r-1, c), scores(r, c-1), scores(r-1, c-1)];
            value = min(arr);
            [a,b] = find(arr == value);
            if b == 1
                r = r-1;
            elseif b == 2
                c = c-1;
            else
                r = r-1; c = c-1;
            end
        end
        gesture_start = c; gesture_end = values(index,2);
        result = [result; [gesture_start,gesture_end,label]];
    end
    
    
end
end