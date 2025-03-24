function[state, real_next] = checkCollision_pro(obstaclelist, now, next)
    state = 0;
    oblist_size = size(obstaclelist);
    for i = 1:oblist_size(2)
        obstaclesize = size(obstaclelist{i});
        for j = 1:(obstaclesize(1)-1)
            lineseg_A  = [now(1)    now(2);next(1)   next(2)]; 
            lineseg_B  = [obstaclelist{i}(j,1) obstaclelist{i}(j,2);obstaclelist{i}(j+1,1) obstaclelist{i}(j+1,2);];
            [real_x, real_y] =polyxpoly(lineseg_A(:,1),lineseg_A(:,2),lineseg_B(:,1),lineseg_B(:,2));
            real_xy = [real_x, real_y];
            if isempty(real_y) || isequal(real_xy, obstaclelist{i}(j+1,:)) || isequal(real_xy, obstaclelist{i}(j,:)) || isequal(real_xy, now)
                real_next = next;
                state = 0;
            else
                state = 1;
                real_next(1) = real_x;
                real_next(2) = real_y;
                break;
            end
        end
        if state == 1
            break;
        end
    end
end