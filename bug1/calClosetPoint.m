function closetindex = calClosetPoint(target, path)
    path_size = size(path);
    length = path_size(1);
    closetdistance = inf;
    closetindex = 0;
    for i = 1:length
        distance = norm(target - path(i,:), 2);
        if distance < closetdistance
            closetdistance = distance;
            closetindex = i;
        else
            continue;
        end
        
    end
end