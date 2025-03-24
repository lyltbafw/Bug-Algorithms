function [distance, t] = pointToLineDistance(point, line_p1, line_p2)
    % 计算点到线段的距离
    v = line_p2 - line_p1;
    w = point - line_p1;
    t = dot(w,v)/dot(v,v);
    t = max(0, min(1, t));
    projection = line_p1 + t*v;
    distance = norm(point - projection);
end