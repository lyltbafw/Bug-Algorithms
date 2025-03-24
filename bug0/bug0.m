%从哪里出发？
%从地图出发，我们可以先绘制出地图，这一点是容易实现的
%其次是规划算法
%step1 首先计算出起点到终点的方向斜率 k=（g_y-s_y）/(g_x-s_x)
%step2 通过斜率计算出最大步长的下一个点，并检查该点是否在障碍物上 next = now  + k*step_size
%step3 若点在障碍物上，则移动到距离障碍物最近的点处 
%      并让机器人运动方向左转，沿障碍物边界线运动，并不断重复step2过程
%      （问题1：如何判断机器人撞到了哪个边界线？
%           突发奇想，解决方案：判断now和next之间的线段和障碍物哪个线有交点？
%                     可以同时解决是否撞击和撞击边界是哪个的问题。）
%      若点不在障碍物上，继续移动，(记得判断终点是否在线段上)，回到step2
clear all;
start = [0,0];
goal = [5,3];
step_size = 0.1;
obstacle1 = [1,0;1,2;3,0;1,0];
obstacle2 = [4,1;2,3;5,2;4,1];
obstaclelist = cat(3,obstacle1,obstacle2); %每个障碍物由n个点顺时针排列，之后依次连接而成
disp(obstaclelist(2,:,2))
path = [];
now = start;
path = [path;start];
next = [0,0];
state = 0; %模拟撞击传感器
while now ~= goal
    if state == 1
        if isinf(k_obs)
            next(1) = next(1);
            next(2) = next(2) + step_size;
            now = next;
            path = [path;now];
        else
            if k_obs >= 0
                next(1) = next(1) + sqrt(power(step_size,2)/(power(k_obs,2) + 1));
                next(2) = next(2) + k_obs * sqrt(power(step_size,2)/(power(k_obs,2) + 1));
                now = next;
                path = [path;now];
            elseif k_obs < 0
                next(1) = next(1) - sqrt(power(step_size,2)/(power(k_obs,2) + 1));
                next(2) = next(2) - k_obs * sqrt(power(step_size,2)/(power(k_obs,2) + 1));
                now = next;
                path = [path;now];
            end
        end
    end
    k = (goal(2)-now(2))/(goal(1)-now(1));
    next = next_cal(k, now, step_size);
    [state, k_obs, next] = boundary_detect(obstaclelist,now,next);
    disp(now);
    disp(next);
    disp(k_obs);
    if isPointOnSegment(now, next, goal, 1e-10)
        now = next;
        path = [path;goal];
        break;
    end
    if now ~= next
        now = next;
        path = [path;now];
    end
end

% 清空环境
clf; hold on; grid on; axis equal;

%% 定义障碍物（示例为多边形）
% 障碍物1：矩形（顶点按顺序排列）

% 将所有障碍物存入cell数组
obstaclesList = {obstacle1, obstacle2};

%% 定义路径点（示例路径）

%% 绘制障碍物
for i = 1:length(obstaclesList)
    obs = obstaclesList{i};
    % 绘制多边形边界（红色实线）
    h_obs_edge  = plot(obs(:,1), obs(:,2), 'r-', 'LineWidth', 1.5); 
    % 填充多边形内部（浅红色）
    h_obs_fill = fill(obs(:,1), obs(:,2), [1, 0.8, 0.8]); 
end

%% 绘制路径
% 路径点用蓝色圆圈标记
h_path = plot(path(:,1), path(:,2), 'bo-', 'MarkerSize', 8, 'LineWidth', 1.5); 

%% 标记起点和终点
h_start = plot(path(1,1), path(1,2), 'g^', 'MarkerSize', 12, 'MarkerFaceColor', 'g','DisplayName', '起点'); % 绿色三角形起点
h_goal = plot(path(end,1), path(end,2), 'rs', 'MarkerSize', 12, 'MarkerFaceColor', 'r'); % 红色方块终点

%% 设置图形属性
xlabel('X轴'); ylabel('Y轴');
title('路径与障碍物可视化');
legend([h_obs_edge,h_path,h_start,h_goal],'障碍物边界', '路径', '起点', '终点', 'Location', 'best');
hold off;


