%% 边界跟随函数（带顶点吸附）
function [new_pos, edge_info] = followBoundary(current_pos, obstacle, step)
    min_dist = Inf;
    closest_edge = 1;
    for k = 1:size(obstacle,1)-1
        [d, ~] = pointToLineDistance(current_pos, obstacle(k,:), obstacle(k+1,:));
        if d < min_dist
            min_dist = d;
            closest_edge = k;
        end
    end
    p1 = obstacle(closest_edge,:);
    p2 = obstacle(closest_edge+1,:);
    edge_dir = (p2 - p1)/norm(p2 - p1);
    new_pos = current_pos + step*edge_dir;
    edge_info = -1;
    if norm(new_pos - p2) < step
        new_pos = p2;
        edge_info = closest_edge;
    end

    
end