function [path] = rotationWithPoint(current_pos, obstacle, step, path, last_close)
    min_dist = Inf;
    closest_edge = last_close;
    p1 = obstacle(closest_edge,:);
    p2 = obstacle(closest_edge+1,:);
    edge_dir = (p2 - p1)/norm(p2 - p1);
    new_pos = current_pos + 0.05*edge_dir;
    path = [path;new_pos];
    current_pos = new_pos;
    angle_step = 60;
    now_close = closest_edge;
    while closest_edge == now_close
        new_pos = generate_rotated_coordinates(p2, current_pos, angle_step);
        path = [path;new_pos]; 
        current_pos = new_pos;
        min_dist = Inf;
        closest_edge = 1;
        for k = 1:size(obstacle,1)-1
            [d, ~] = pointToLineDistance(current_pos, obstacle(k,:), obstacle(k+1,:));
            if d < min_dist
                min_dist = d;
                closest_edge = k;
            end
        end
    end
    foot = point_to_segment_projection(current_pos, obstacle(closest_edge,:), obstacle(closest_edge+1,:));
    path = [path;foot];

end