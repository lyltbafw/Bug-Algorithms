%% 修复无限循环问题的Bug1算法
clear; close all; clc;

%% 初始化参数（增加障碍物复杂度测试）
start_point = [0, 0];       % 起始点
goal_point = [10, 10];      % 目标点
step_size = 0.05;           % 减小步长提高精度
tolerance = 0.2;            % 目标到达阈值
obstacle1 = [                % 非凸多边形测试
    1,0.5;
    1,2;
    3,0;
    2,0.5;
    1,0.5
            ]; 
obstacle2 = [
    4,1;
    2,3;
    5,2;
    5,1;
    4,1
            ];
obstaclelist = {obstacle1,obstacle2}; %每个障碍物由n个点顺时针排列，之后依次连接而成
%% 新增调试参数
debug_mode = true;           % 显示调试信息

%% 状态变量增强
current_pos = start_point;
path = start_point;
status = 'moving_to_goal';
circumvent_obstacle_num = 0;
%% 增强可视化
figure;
hold on;
h_obstacle1 = plot(obstacle1(:,1), obstacle1(:,2), 'r-', 'LineWidth', 2);
h_obstacle2 = plot(obstacle2(:,1), obstacle2(:,2), 'r-', 'LineWidth', 2);
h_start = plot(start_point(1), start_point(2), 'go', 'MarkerSize', 10);
h_goal = plot(goal_point(1), goal_point(2), 'mo', 'MarkerSize', 10);
h_robot = plot(current_pos(1), current_pos(2), 'bo', 'MarkerFaceColor', 'b');
h_path = plot(path(:,1), path(:,2), 'b:');
axis equal tight;
grid on;
title('Bug1 Algorithm - Enhanced Debug View');
legend([h_obstacle1,h_path,h_start,h_goal],'障碍物边界', '路径', '起点', '终点', 'Location', 'best');
while norm(current_pos - goal_point) > tolerance
    switch status
        case 'moving_to_goal'
            % 增强方向计算（增加微小扰动避免死锁）
            direction = goal_point - current_pos;
            if norm(direction) < eps
                break;
            end
            direction = direction / norm(direction) + randn(1,2)*0.001;
            
            % 增强碰撞检测
            [collision, new_pos] = checkCollision_pro(obstaclelist, current_pos, current_pos + step_size * direction);
            if collision
                status = 'circumvent_obstacle';
                circumvent_start = current_pos;
                min_dist_to_goal = Inf;
                boundary_memory = {current_pos}; % 初始化边界记忆
                full_circuit = false;
                path = [path; new_pos];
                current_pos = new_pos;
                collision_pos = current_pos;
                path_currentsize = size(path);
                collision_index = path_currentsize(1);
                cir_endindex =  collision_index;
                if debug_mode
                    fprintf('碰撞触发绕障 at [%.2f,%.2f]\n',...
                         current_pos(1), current_pos(2));
                end
            else
                new_pos = current_pos + step_size * direction;
                path = [path; new_pos];
                current_pos = new_pos;
            end
        case 'circumvent_obstacle'
            cir_endindex = cir_endindex + 1;
            if norm(goal_point, 2) >= norm(start_point, 2)
                if circumvent_obstacle_num == 0
                    [new_pos, last_close] = followBoundary(current_pos, obstacle1, step_size);
                elseif circumvent_obstacle_num == 1
                    [new_pos, last_close] = followBoundary(current_pos, obstacle2, step_size);
                end
            else
                if circumvent_obstacle_num == 0
                    [new_pos, last_close] = followBoundary(current_pos, obstacle2, step_size);
                elseif circumvent_obstacle_num == 1
                    [new_pos, last_close] = followBoundary(current_pos, obstacle1, step_size);
                end
            end

            if dist([new_pos(1) new_pos(2)],[collision_pos(1) collision_pos(2)]') < 0.05 && (cir_endindex - collision_index) > 5
                new_pos = collision_pos;
                path = [path; new_pos];
                current_pos = new_pos;
                %% 这个部分目前已经完成了循环一圈并返回起始碰撞点，
                % 下一步添加计算出距离终点最近点并更新路径，并切换至第一个状态
                status = 'moving_to_goal';
                if debug_mode
                    fprintf('完成绕障 at [%.2f,%.2f]\n',...
                         current_pos(1), current_pos(2));
                end
                circumvent_obstacle_num = circumvent_obstacle_num + 1;
                closeindex = calClosetPoint(goal_point, path);
                path = [path;path(collision_index:closeindex, :)];
                current_pos = path(end, :);
                new_pos = current_pos;
                if debug_mode
                    fprintf('障碍物%.d距离终点最近点 at [%.2f,%.2f]\n',...
                         circumvent_obstacle_num, path(closeindex, 1), path(closeindex, 2));
                end
            else
                path = [path; new_pos];
                current_pos = new_pos;
            end
            if norm(goal_point, 2) >= norm(start_point, 2)
                if circumvent_obstacle_num == 0
                    if ismember(new_pos, obstacle1)
                        path = rotationWithPoint(current_pos, obstacle1, step_size, path, last_close);
                        current_pos = path(end,:);
                    end
                elseif circumvent_obstacle_num == 1
                    if ismember(new_pos, obstacle2)
                        path = rotationWithPoint(current_pos, obstacle2, step_size, path, last_close);
                        current_pos = path(end,:);
                    end
                end
            else
                if circumvent_obstacle_num == 0
                    if ismember(new_pos, obstacle2)
                        path = rotationWithPoint(current_pos, obstacle2, step_size, path, last_close);
                        current_pos = path(end,:);
                    end
                elseif circumvent_obstacle_num == 1
                    if ismember(new_pos, obstacle1)
                        path = rotationWithPoint(current_pos, obstacle1, step_size, path, last_close);
                        current_pos = path(end,:);
                    end
                end
            end

    end
    % 实时可视化更新
    set(h_robot, 'XData', current_pos(1), 'YData', current_pos(2));
    set(h_path, 'XData', path(:,1), 'YData', path(:,2));
    title(sprintf('State: %s', status));
    
    drawnow limitrate;
end
goalindex_size = size(path);
goalindex = goalindex_size(1);
if debug_mode
        fprintf('历经%.d步到达终点\n',...
             goalindex);
end