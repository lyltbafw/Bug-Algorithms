start = [1,2];
goal = [3,4];
disp(start(1)-goal(1));
start(2) = 4;
disp(start)
lineseg_A  = [0.9432    0.5659;1.0290    0.6174]; % [线段A端点1的横坐标，线段A端点1的纵坐标；线段A端点2的横坐标，线段A端点2的纵坐标]
lineseg_B  = [1 0;1 2]; % [线段B端点1的横坐标，线段B端点1的纵坐标；线段B端点2的横坐标，线段B端点2的纵坐标]
[xi,yi] =polyxpoly(lineseg_A(:,1),lineseg_A(:,2),lineseg_B(:,1),lineseg_B(:,2)) ;
if isempty(xi) 
    disp(1)
end
disp(xi)
disp(yi)