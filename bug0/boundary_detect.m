function[state, k_obs, real_next] = boundary_detect(obstaclelist, now, next)
    state = 0;
    k_obs = 0;
    oblist_size = size(obstaclelist);
    for i = 1:oblist_size(3)
        for j = 1:(oblist_size(1)-1)
            lineseg_A  = [now(1)    now(2);next(1)   next(2)]; 
            lineseg_B  = [obstaclelist(j,1,i) obstaclelist(j,2,i);obstaclelist(j+1,1,i) obstaclelist(j+1,2,i);];
            [real_x, real_y] =polyxpoly(lineseg_A(:,1),lineseg_A(:,2),lineseg_B(:,1),lineseg_B(:,2));
            real_xy = [real_x, real_y];
            if isempty(real_y) || isequal(real_xy, obstaclelist(j+1,:,i)) || isequal(real_xy, obstaclelist(j,:,i))
                real_next = next;
                state = 0;
            else
                state = 1;
                real_next(1) = real_x;
                real_next(2) = real_y;
                k_obs = (obstaclelist(j+1,2,i) - obstaclelist(j,2,i))/(obstaclelist(j+1,1,i) - obstaclelist(j,1,i));
                break;
            end
        end
        if state == 1
            break;
        end
    end
end